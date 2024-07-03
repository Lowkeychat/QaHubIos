import XCTest

public class Observer: NSObject, XCTestObservation {
    let qaHubClient: QaHubClient
    
    public init(qaHubClient: QaHubClient) {
        self.qaHubClient = qaHubClient
    }
    
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        let qaHubClient = self.qaHubClient
        let testRunId = ProcessInfo.processInfo.environment["TEST_RUN_ID"] ?? ""
        let runner = ProcessInfo.processInfo.environment["RUNNER"] ?? ""
        let udid = ProcessInfo.processInfo.environment["SIMULATOR_UDID"] ?? ""
        let retry = Int(ProcessInfo.processInfo.environment["RETRY"] ?? "1") ?? 1
        
        let deviceInfoComponents = ProcessInfo.processInfo.environment["SIMULATOR_VERSION_INFO"]?.components(separatedBy: " - ")
        
        let model = deviceInfoComponents?
            .first( where: { $0.contains("DeviceType:") })?
            .components(separatedBy: ": ").last ?? ""
        
        let runtime = deviceInfoComponents?
            .first( where: { $0.contains("Runtime:") })?
            .components(separatedBy: ": ").last ?? ""
        
        let targetName = (Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "").split(separator: "-")[0]
        let testName = testCase.name.split(separator: " ")[1].replacingOccurrences(of: "]", with: "")
        let suitName = testCase.name.split(separator: " ")[0].replacingOccurrences(of: "-[", with: "")
        let fullName = "\(targetName).\(suitName).\(testName)"
        
        
        if testCase is BaseTest && testRunId != "" {
            let duration = Double(testCase.testRun!.testDuration)
            var status = "SUCCESS"
            var message: String?
            var attachments: [TestResultAttachment] = []
            
            if (testCase as! BaseTest).errorMessage != nil {
                status = "FAILURE"
                message = (testCase as! BaseTest).errorMessage
                
                //sending screenshot to QA Hub
                let imageData = (testCase as! BaseTest).failureScreenshot
                
                if let imageData = imageData {
                    let attachment = try? qaHubClient.sendScreenshot(
                        imageData: imageData,
                        project: self.qaHubClient.qaHubProject,
                        testRunId: testRunId,
                        fullName: fullName
                    )
                    
                    if let attachment = attachment {
                        attachments.append(attachment)
                    }
                }
            }
            
            do {
                try qaHubClient.sendTestSteps(
                    TestStepRecord(
                        testRunId: testRunId,
                        fullName: fullName,
                        retry: retry,
                        steps: Report.testSteps
                    )
                )
            } catch {
                autotestLog("\n\nError during sending test steps in QA_Hub\n\n")
            }
            
            do {
                try qaHubClient.sendTestResult(
                    TestResultRequest(
                        testRunId: testRunId,
                        fullName: fullName,
                        testcaseId: Report.testId,
                        project: self.qaHubClient.qaHubProject,
                        duration: duration,
                        status: status,
                        message: message,
                        runner: runner,
                        device: model,
                        deviceId: udid,
                        deviceRuntime: runtime,
                        attachments: attachments
                    )
                )
            } catch {
                autotestLog("\n\nError during sending results in QA_Hub\n\n")
            }
        }
        
        XCTestObservationCenter.shared.removeTestObserver(self)
    }

    public func testCase(_ testCase: XCTestCase,
                              didFailWithDescription description: String,
                              inFile filePath: String?,
                              atLine lineNumber: Int) {
        Report.currentStepId = "0"
        if testCase is BaseTest {
            (testCase as! BaseTest).errorMessage = description
            
            Report.step("Printing the elements tree") {
                autotestLog(XCUIApplication().debugDescription)
            }
        }
    }
}
