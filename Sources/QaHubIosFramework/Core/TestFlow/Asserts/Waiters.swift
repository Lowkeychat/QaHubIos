import XCTest

public func syncWait(_ time: Double) {
    let group = DispatchGroup()
    group.enter()
    DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + time) {
        group.leave()
    }
    group.wait()
}

public func retryForResult<T>(
    _ description: String,
   retries: Int = 5,
   retryTimeout: Double = 1.0,
   silent: Bool = false,
   action: () throws -> T,
   expectation: (T?) throws -> Bool
) -> T {
    var result = false
    var actionResult: T? = nil

    let maxWaitTime = round((Double(retries) - 1) * retryTimeout * 10) / 10
    let retryString = "\nMax wait time: \(maxWaitTime)s. Retries: \(retries). Timeout: \(retryTimeout)с"

    return Report.step("\(description). \(retries > 1 ? retryString : "")") {
        for retry in 1 ... retries {
            do {
                try actionResult = action()
            } catch {  }

            do {
                result = try expectation(actionResult)
            } catch {
                result = false
            }

            if !silent {
                let retryString = "Try \(retry) out of \(retries): "
                let resultString = "\(result ? "Success.\n": "Failure. Waiting \(retryTimeout) s.")"
                autotestLog(retryString + resultString)
            }

            if result { break }

            if retry < retries {
                syncWait(retryTimeout)
            }
        }
        
        XCTAssertTrue(result, "Failed to wait for condition: \(description)")
        
        return actionResult.unwrap()
    }
}

@discardableResult
public func waitForResult<T>(
    _ description: String,
    maxWaitTime: Double = 5.0,
    retryTimeout: Double = 1.0,
    silent: Bool = false,
    failOnError: Bool = true,
    action: () throws -> T,
    expectation: (T?) throws -> Bool
) -> T {
    let startTime = Date()
    let finishTime = startTime.addingTimeInterval(maxWaitTime)

    var result = false
    var actionResult: T? = nil
    

    let retryString = "\nMax wait time: \(maxWaitTime)s. Timeout: \(retryTimeout)с"

    return Report.step("\(description). \(retryString)") {
        var currentTime = Date()

        while currentTime < finishTime {
            do {
                try actionResult = action()
            } catch {  }

            do {
                result = try expectation(actionResult)
            } catch {
                result = false
            }


            if !silent {
                let waitString = "Passed: \(Int(currentTime.timeIntervalSince(startTime)))s. "
                let resultString = "\(result ? "Success.\n": "Failure. Wait \(retryTimeout) s.")"
                autotestLog(waitString + resultString)
            }

            if result { break }

            syncWait(retryTimeout)

            currentTime = Date()
        }

        if failOnError {
            XCTAssertTrue(result, "Failed to wait for condition: \(description)")
        }
        
        return actionResult.unwrap()
    }
}


@discardableResult
public func waitForResult(
    _ description: String,
    maxWaitTime: Double = 5.0,
    retryTimeout: Double = 1.0,
    silent: Bool = false,
    failOnError: Bool = true,
    expectation: () throws -> Bool
) -> Bool {
    return waitForResult(
        description,
        maxWaitTime: maxWaitTime,
        retryTimeout: retryTimeout,
        silent: silent,
        failOnError: failOnError,
        action: {
            do {
                return try expectation()
            } catch {
                return false
            }
        },
        expectation: { result in result == true }
    )
}

public func retry(
    _ description: String,
    retries: Int = 5,
    retryTimeout: Double = 1.0,
    action: () throws -> Void
) {
    Report.step("\(description). \(retries > 1 ? "Retries: \(retries). Timeout: \(retryTimeout)s" : "")") {
        for retry in 1 ... retries {
            do {
                try action()
            } catch {  }

            autotestLog(
                "Try \(retry) out of \(retries)"
            )

            if retry < retries {
                let group = DispatchGroup()

                group.enter()
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + retryTimeout) {
                    group.leave()
                }
                group.wait()
            }
        }
    }
}


