import Foundation

class QaHubClient {
    let baseUrl: String
    let qaHubProject: String
    let client = HttpClient()
    
    init(baseUrl: String, qaHubProject: String) {
        self.baseUrl = baseUrl
        self.qaHubProject = qaHubProject
    }
    
    @discardableResult
    func sendTestResult(_ requestBody: TestResultRequest) throws -> String? {
        let response: String? = try client.request(
            url: "\(self.baseUrl)/api/testResults",
            httpMethod: .post,
            dataBody: requestBody.data(),
            deserializeResponse: false
        )
        return response
    }

    @discardableResult
    func sendTestSteps(_ testStepRecord: TestStepRecord) throws -> String? {
        let response: String? = try client.request(
            url: "\(self.baseUrl)/api/testResults/steps",
            httpMethod: .post,
            dataBody: testStepRecord.data(),
            deserializeResponse: false
        )
        return response
    }
    
    @discardableResult
    func sendSlackMessage(channel: String, message: String, token: String) -> SlackMessageResponse? {
        let requestBody = SlackTextMessageRequest(
            channel: channel, message: message, token: token
        )
    
        let response: SlackMessageResponse? = try? client.request(
            url: "\(self.baseUrl)/api/slack/text",
            httpMethod: .post,
            dataBody: requestBody.data()
        )
        
        return response        
    }
    
    @discardableResult
    func sendScreenshot(
        imageData: Data,
        project: String,
        testRunId: String,
        fullName: String
    ) throws -> TestResultAttachment? {
       
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let body = NSMutableData()
        body.append(formDataTextParam(boundary: boundary, paramName: "project", paramValue: project))
        body.append(formDataTextParam(boundary: boundary, paramName: "testRunId", paramValue: testRunId))
        body.append(formDataTextParam(boundary: boundary, paramName: "fullName", paramValue: fullName))
        body.append(formDataFileParam(boundary: boundary, paramName: "image", data: imageData))
        body.append("--\(boundary)--\r\n".toUtf8Data())
       
        let response: TestResultAttachment? = try? client.request(
            url: "\(self.baseUrl)/api/attachments/images",
            httpMethod: .post,
            headers: [
                "Content-Type": "multipart/form-data; boundary=\(boundary)"
            ],
            dataBody: Data(body),
            contentType: .passedInHeader
        )
        
        return response
    }
    
    private func formDataTextParam(boundary: String, paramName: String, paramValue: String) -> Data {
        let result = NSMutableData()
        result.append("--\(boundary)\r\n".toUtf8Data())
        result.append("Content-Disposition: form-data; name=\"\(paramName)\"".toUtf8Data())
        result.append("\r\n\r\n\(paramValue)\r\n".toUtf8Data())
        
        return Data(result)
    }
    
    private func formDataFileParam(boundary: String, paramName: String, data: Data, contentType: String = "image/png") -> Data {
        let result = NSMutableData()
        result.append("--\(boundary)\r\n".toUtf8Data())
        result.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"file.png\"\r\n".toUtf8Data())
        result.append("Content-Type: \(contentType)\r\n\r\n".toUtf8Data())
        result.append(data)
        result.append("\r\n".toUtf8Data())
        
        return Data(result)
    }
}

private extension String {
    func toUtf8Data() -> Data {
       return self.data(using: .utf8, allowLossyConversion: false)!
    }
}
