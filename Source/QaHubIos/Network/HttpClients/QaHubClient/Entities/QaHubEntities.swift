struct TestStepRecord: Codable {
    var testRunId: String
    var fullName: String
    var retry: Int
    var steps: [TestStep]
}

struct TestResultRequest: Codable {
    let testRunId: String
    let fullName: String
    let testcaseId: String?
    var project: String
    let duration: Double
    let status: String
    var message: String? = nil
    let runner: String
    let device: String
    let deviceId: String
    let deviceRuntime: String
    let attachments: [TestResultAttachment]?
}

struct TestResultAttachment: Codable {
    let type: String
    let path: String
    let fileName: String
}

struct SlackTextMessageRequest: Codable {
    let channel: String
    let message: String
    let token: String
}

struct SlackMessageResponse: Codable {
    let ok: Bool
}
