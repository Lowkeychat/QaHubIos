import Foundation

@propertyWrapper
public struct Lateinit<T> {
    var propertyValue: T?

    var wrappedValue: T {
        get {
            guard let value = propertyValue else {
                fatalError("Property being accessed without initialization")
            }
            return value
        }
        set {
            guard propertyValue == nil else {
                fatalError("Property already initialized")
            }
            propertyValue = newValue
        }
    }

    init() {}
}
