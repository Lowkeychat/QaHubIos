import XCTest

class Matcher<T> {
    let description: String
    let reference: T
    let checkFunction: (T, T) -> Bool
    
    init (description: String, reference: T, checkFunction: @escaping (T, T) -> Bool) {
        self.description = description

        self.reference = reference
        self.checkFunction = checkFunction
    }
    
    func check(value: T) -> Bool {
        autotestLog("Performing check: '\(value)' \(description) '\(String(describing: reference))'")
        let result = checkFunction(value, reference)

        return result
    }
}

func isTrue() -> Matcher<Bool> {
    return Matcher(description: "is", reference: true, checkFunction: {
        value, reference in return value == reference
    })
}

func isNotTrue() -> Matcher<Bool> {
    return Matcher(description: "is not", reference: true, checkFunction: {
        value, reference in return value != reference
    })
}

func equalTo<T: Equatable> (_ reference: T) -> Matcher<T> {
    return Matcher(description: "equals", reference: reference, checkFunction: {
        value, reference in return value == reference
    })
}

func containsString(_ reference: String) -> Matcher<String> {
    return Matcher(description: "contains string", reference: reference, checkFunction: {
        value, reference in return value.contains(reference)
    })
}

func doesntContainString(_ reference: String) -> Matcher<String> {
    return Matcher(description: "doesn't contain string", reference: reference, checkFunction: {
        value, reference in return !value.contains(reference)
    })
}
