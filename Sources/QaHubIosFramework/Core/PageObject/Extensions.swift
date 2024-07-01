import XCTest


enum PredicateFormats: String {
    case exists = "exists == 1"
    case notExists = "exists == 0"
    case isHittable = "isHittable == 1"
    case isNotHittable = "isHittable == 0"
    case isEnabled = "isEnabled == 1"
    case isDisabled = "isEnabled == 0"
    case isSelected = "isSelected == 1"
    case isNotSelected = "isSelected == 0"
    case hasFocus = "hasFocus == 1"
    case hasNotFocus = "hasFocus == 0"
}


extension XCUIElement {
    @discardableResult
    func waitForElement(_ predicateFormat: PredicateFormats = .exists,
                        timeout: Double = Timeout.long,
                        failOnError: Bool = true) -> Bool {
        Report.step("WaitForElement: \(self). State: \(predicateFormat.rawValue)") {
            let testcase = XCTestCase()

            let predicate = NSPredicate(format: predicateFormat.rawValue)
            let expecation = testcase.expectation(for: predicate, evaluatedWith: self, handler: nil)

            let result = XCTWaiter().wait(for: [expecation], timeout: timeout) == XCTWaiter.Result.completed

            if failOnError {
                XCTAssert(result, "Element \(self) has state \(predicateFormat.rawValue)")
            }

            return result
        }
    }
    
    var stringValue: String {
        self.value as? String ?? ""
    }
}

extension XCUIElementQuery {
    var lastMatch: XCUIElement {
        let lastMatchElement = self.element(boundBy: self.count - 1)
        return lastMatchElement
    }
}
