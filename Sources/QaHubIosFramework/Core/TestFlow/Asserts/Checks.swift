import XCTest


func checkThat<T>(
    _ description: String,
    errorMessage: String? = nil,
    retries: Int = 1,
    retryTimeout: Double = 0.5,
    _ closure: () -> T,
    _ matcher: Matcher<T>
) {
    var result = false
    Report.check("\(description). \(retries > 1 ? "Retries: \(retries). Timeout: \(retryTimeout)с" : "")") {
        for retry in 1 ... retries {
            result = matcher.check(value: closure())
            
            autotestLog(
                "Try \(retry) out of \(retries): \(result ? "Success.\n" : "Failure. Wait \(retryTimeout) s.")"
            )
            if result { break }
            
            if retry < retries {
                let group = DispatchGroup()
                
               syncWait(retryTimeout)
            }
        }
        
        let errorMessage = errorMessage ?? "Check failed: \(description)"
        
        XCTAssertTrue(result, errorMessage)
    }
}

func checkThat<T>(
    _ description: String,
    errorMessage: String? = nil,
    retries: Int = 1,
    retryTimeout: Double = 0.5,
    _ value: T,
    _ matcher: Matcher<T>
) {
    checkThat(
        description,
        errorMessage: errorMessage,
        retries: retries,
        retryTimeout: retryTimeout,
        { return value },
        matcher
    )
}

func checkThat(
    _ description: String,
    errorMessage: String? = nil,
    retries: Int = 1,
    retryTimeout: Double = 0.5,
    _ closure:() -> Bool
) {
    checkThat(
        description,
        errorMessage: errorMessage,
        retries: retries,
        retryTimeout: retryTimeout,
        closure,
        isTrue()
    )
}
