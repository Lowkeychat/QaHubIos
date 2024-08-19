import XCTest

public class Report {
    public static var testId: String = ""
    public static var testSteps: [TestStep] = []
    public static var currentStepId = "0"
    
    public static func clear() {
        currentStepId = "0"
        testSteps = []

        testId = ProcessInfo.processInfo.environment["TEST_ID"] ?? ""
        if !testId.isEmpty {
            Allure.allureId(testId)
        }
        
        let thread = ProcessInfo.processInfo.environment["SIMULATOR_UDID"] ?? "Unknown device"
        Allure.thread(thread)
    }

    public static func preparation(_ description: String, stepBody: () -> Void) {
        let name = "SetUp: \(description)"
        wrapActivity(activityName: name) { stepBody() }
    }

    public static func tearDown(_ description: String, stepBody: () -> Void) {
        let name = "TearDown: \(description)"
        wrapActivity(activityName: name) { stepBody() }
    }

    public static func test(_ testcaseId: String, _ testcaseName: String, testBody: () -> Void) {
        let activityName = "Test: \(testcaseName). TestcaseId: \(testcaseId)"
        
        if testId.isEmpty {
            testId = testcaseId
            Allure.allureId(testcaseId)
        }
        Allure.name(testcaseName)

        wrapActivity(activityName: activityName) { testBody() }
    }

    @discardableResult
    public static func step<T: Any>(_ description: String, stepBody: () -> T) -> T {
        let name = "Step: \(description)"

        return wrapActivity(activityName: name) { stepBody() }
    }
    
    @discardableResult
    public static func unsafeStep<T: Any>(_ description: String, stepBody: ()  throws -> T) rethrows -> T {
        let name = "Step: \(description)"
        return try wrapActivity(activityName: name) { try stepBody() }
    }

    public static func check(_ description: String, stepBody: () -> Void) {
        let name = "Check: \(description)"
        wrapActivity(activityName: name) { stepBody() }
    }

    public static func sql(_ description: String, stepBody: () -> Void) {
        let name = "SQL-query: \(description)"
        wrapActivity(activityName: name) { stepBody() }
    }
    
    public static func http<T: Any>(_ description: String, stepBody: () throws -> T?) rethrows -> T? {
        let name = "HTTPS-request: \(description)"
        return try wrapActivity( activityName: name) { try stepBody() }
    }

    static func wrapActivity<T: Any>(activityName: String, stepBody: () throws -> T) rethrows -> T {
        let newStep = appendStep(name: activityName, parentId: currentStepId)
        currentStepId = newStep.id
        
        @Lateinit var result: T
        autotestLog("[\(Date.localDate())]")
        autotestLog("Starting step \(newStep.id):")

        do {
            try XCTContext.runActivity(named: activityName) { _ in
                result = try stepBody()
            }

            findStepRecursively(id: currentStepId)?.result = "success"
            currentStepId = newStep.parentId
        } catch {
            findStepRecursively(id: currentStepId)?.result = "failure"
            currentStepId = newStep.parentId

            throw error
        }

        return result
    }

    public static func appendStep(name: String, parentId: String) -> TestStep {
        if parentId == "0" {
            let testStep = TestStep(
                name: name,
                id: "\(testSteps.count + 1)",
                parentId: parentId,
                steps: []
            )
            
            testSteps.append(testStep)
            
            return testStep
        } else {
            let parentStep = findStepRecursively(id: parentId)!
            
            let testStep = TestStep(
                name: name,
                id: "\(parentId).\(parentStep.steps.count + 1)",
                parentId: parentId,
                steps: []
            )
            
            parentStep.steps.append(testStep)
            
            return testStep
        }
    }

    public static func findStepRecursively(id: String, _ currentSteps: [TestStep] = testSteps) -> TestStep? {
        var result: TestStep?
        currentSteps.forEach { existingStep in
            if existingStep.id == String(id) {
                result = existingStep
            } else {
                result = findStepRecursively(id: id, existingStep.steps)
            }
        }
        return result
    }

    init() {}
}
