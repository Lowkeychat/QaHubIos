import XCTest

public extension Optional {
    func unwrap(_ description: String = "Optional value") -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            return Report.step("Unwrapping optional value: \(description)") {
                XCTFail("Failed to unwrap \(description): nil found")
                return self!
            }
        }
    }
}
