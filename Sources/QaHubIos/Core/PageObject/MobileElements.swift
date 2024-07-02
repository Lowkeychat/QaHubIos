import Foundation
import XCTest

open class MobileElements<T: MobileElement> {
    public let query: XCUIElementQuery

    public var count: Int {
        get { query.count }
    }
    
    required public init(_ query: XCUIElementQuery) {
        self.query = query
    }
    
    public func getRawElements() -> [XCUIElement] {
        return query.allElementsBoundByIndex
    }
    
    public func getElements() -> [T] {
        return query.allElementsBoundByIndex.map { element in
            T(element)
        }
    }
    
    public func last() -> T {
        getElement(count - 1)
    }
    
    public func first() -> T {
        getElement(0)
    }

    public func getElement(_ number: Int) -> T {
        let element = query.element(boundBy: number)
        element.waitForElement()

        return T(element)
    }
}
