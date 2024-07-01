import Foundation
import XCTest
import Alamofire

enum ContentType: String {
    case applicationJson = "application/json"
    case passedInHeader = "passedInHeader"
}


public class HttpClient {
    private let XCtest = XCTestCase()
    private let sessionManager: Session

    //IT is impossible to ignore all SSL certs errors in Swift, so we need to create HTTP client that configuring each host that shoul skip SSL Verification
    init (disabledSslHosts: [String] = []) {
        var evaluators: [String: DisabledTrustEvaluator] = [:]
    

        disabledSslHosts.forEach { host in
            let domen = host
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .split(separator: "/")[0].description

            evaluators[domen] = DisabledTrustEvaluator()
        }

        self.sessionManager = {
            let trustManager = ServerTrustManager(
                evaluators: evaluators
            )
            let configuration = URLSessionConfiguration.af.default

            configuration.timeoutIntervalForRequest = Timeout.longest
            configuration.timeoutIntervalForResource = Timeout.longest

            return Session(configuration: configuration, serverTrustManager: trustManager)
         }()
    }

    private func requestData(
        url: String,
        httpMethod: HTTPMethod = .get,
        headers: [String: String] = [:],
        parameters: [String: String?] = [:],
        dataBody: Data? = nil,
        contentType: ContentType = .applicationJson
    ) throws -> Data? {
        autotestLog("\n------------------START REQUEST------------------\n")
        var data: Data?
        var statusCode: Int?
        
        let request = try Report.unsafeStep("Request") {
            let url = try urlAbsoluteString(url: url, parameters: parameters)
            
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.httpBody = dataBody
            request.headers = buildHeaders(headers, contentType)
            
            logRequest(request)
            
            return request
        }

        try Report.unsafeStep("Response") {
            let response = sessionManager.request(request)
                .validate(statusCode: 200 ..< 299)
                .responseData { _ in }
            
            waitForResult(
                "Waiting for server response",
                maxWaitTime: Timeout.longest,
                retryTimeout: 0.2,
                silent: true,
                action: {
                    statusCode = response.response?.statusCode
                    data = response.data
                },
                expectation: { _ in response.isFinished }
            )
            
            guard let statusCode = statusCode else {
                throw NetworkError.requestFailed("Status code is nil. Request failed.")
            }
            
            autotestLog("\nStatus code: \(statusCode)")
            if let data = data {
                logResponseData(data)
            }
        }

        autotestLog("\n-------------------END REQUEST-------------------\n")

        return data
    }

    @discardableResult
    func request<T: Codable>(url: String,
                                    httpMethod: HTTPMethod = .get,
                                    headers: [String: String] = [:],
                                    parameters: [String: String?] = [:],
                                    dataBody: Data? = nil,
                                    contentType: ContentType = .applicationJson,
                                    deserializeResponse: Bool = true
    ) throws -> T? {
        do {
            let data = try requestData(url: url,
                                       httpMethod: httpMethod,
                                       headers: headers,
                                       parameters: parameters,
                                       dataBody: dataBody,
                                       contentType: contentType)

            var serializedResponse: T?

            if deserializeResponse {
                guard let data = data else {
                    throw NetworkError.jsonParsingError("data is nil")
                }

                do {
                    let decoder = JSONDecoder()
                    serializedResponse = try decoder.decode(T.self, from: data)
                } catch let DecodingError.dataCorrupted(context) {
                    throw NetworkError.jsonParsingError("\(context)")
                } catch let DecodingError.keyNotFound(key, context) {
                    throw NetworkError.jsonParsingError("Key '\(key.stringValue)' not found: \(context.debugDescription) CodingPath: \(context.codingPath)")
                } catch let DecodingError.valueNotFound(value, context) {
                    throw NetworkError.jsonParsingError("Value '\(value)' not found: \(context.debugDescription). CodingPath: \(context.codingPath)")
                } catch let DecodingError.typeMismatch(type, context)  {
                    throw NetworkError.jsonParsingError("Type '\(type)' mismatch: \(context.debugDescription). CodingPath: \(context.codingPath)")
                } catch {
                    throw NetworkError.jsonParsingError("\(error)")
                }
            } else {
                guard let data = data else {
                    return nil
                }

                let stringData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                serializedResponse = stringData as? T
            }

            return serializedResponse
        } catch {
            autotestLog(error.localizedDescription)
            throw error
        }
    }

    private func logRequest(_ request: URLRequest) {
        autotestLog("\(request.httpMethod ?? "UNKOWN METHOD") \(request.url?.absoluteString ?? "UNKNOWN URL")")

        let headerFields = request.allHTTPHeaderFields
        autotestLog("Request Headers: \n\((headerFields ?? [:]))\n")

        if let requestBody = request.httpBody {
            let body = NSString(data: requestBody, encoding: String.Encoding.utf8.rawValue)
            let prettyJsonBody = body?.data(using: String.Encoding.utf8.rawValue)?
                .prettyPrintedJSONString
            let string = prettyJsonBody ?? body ?? ""
            autotestLog("Request Body: \n\(string)\n")
        }
    }

    private func logResponseData(_ responseData: Data) {
        autotestLog("\nResponse body:")
        if let json = responseData.prettyPrintedJSONString {
            autotestLog(json)
        } else {
            let rawResponseString = String(
                describing: NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
            )
            autotestLog(rawResponseString)
        }
    }

    private func buildHeaders(
        _ headers: [String: String],
        _ contentType: ContentType = .applicationJson
    ) -> HTTPHeaders {
        var resultHeaders = HTTPHeaders()

        if contentType != .passedInHeader {
            resultHeaders.add(name: "Content-Type", value: contentType.rawValue)
        }

        for header in headers {
            resultHeaders.add(name: header.key, value: header.value)
        }

        return resultHeaders
    }

    private func urlAbsoluteString(url: String, parameters: [String: String?] = [:]) throws -> URL {
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard var urlComps = URLComponents(string: url) else {
            return URL(fileURLWithPath: "")
        }

        if urlComps.queryItems == nil { urlComps.queryItems = [] }
        queryItems.forEach {
            urlComps.queryItems?.append($0)
        }

        guard let url = urlComps.url else {
            throw NetworkError.wrongUrl(urlComps.debugDescription)
        }

        return url
    }
}
