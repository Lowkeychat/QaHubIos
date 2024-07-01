import XCTest

class MailhogClient {
    let baseUrl: String
    let client = HttpClient()
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getMessages() -> MailhogResponse {
        let response: MailhogResponse? = try? client.request(
            url: "\(self.baseUrl)/api/v2/message",
            httpMethod: .get
        )
        
        guard let response = response else {
            XCTFail("Failed to receive response from mailhog")
            return response!
        }
        
        return response
    }
    
    func searchMessages(_ string: String, kind: String = "containing") -> MailhogResponse {
        let response: MailhogResponse? = try? client.request(
            url: "\(self.baseUrl)/api/v2/search",
            httpMethod: .get,
            parameters: ["query": string, "kind": kind ]
        )
        
        guard let response = response else {
            XCTFail("Failed to receive response from mailhog")
            return response!
        }
        
        return response
    }
}
