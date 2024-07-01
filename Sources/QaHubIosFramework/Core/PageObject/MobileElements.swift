import Foundation
import XCTest

class MobileElements<T: MobileElement> {
    let query: XCUIElementQuery

    var count: Int {
        get { query.count }
    }
    
    required init(_ query: XCUIElementQuery) {
        self.query = query
    }
    
    func getRawElements() -> [XCUIElement] {
        return query.allElementsBoundByIndex
    }
    
    func getElements() -> [T] {
        return query.allElementsBoundByIndex.map { element in
            T(element)
        }
    }
    
    func last() -> T {
        getElement(count - 1)
    }
    
    func first() -> T {
        getElement(0)
    }

    func getElement(_ number: Int) -> T {
        let element = query.element(boundBy: number)
        element.waitForElement()

        return T(element)
    }
}
