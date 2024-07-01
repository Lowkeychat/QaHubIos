import Foundation

enum NetworkError: Error {
    case requestFailed(String)
    case errorStatusCode(String)
    case unacceptableResponse(String)
    case jsonParsingError(String)
    case wrongUrl(String)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestFailed(let message):
            return "HTTP request failed: \n\(message)"
        case .errorStatusCode(let message):
            return "ERROR: HTTP response status code >= 400. \n\(message)"
        case .unacceptableResponse(let message):
            return "Response is unacceptable:\n \(message)"
        case .jsonParsingError(let message):
            return "ERROR: Failed to parse json\n \(message)"
        case .wrongUrl(let url):
            return "Wrong URL: \(url)"
        }
    }
}
