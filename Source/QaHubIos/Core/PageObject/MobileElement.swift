import Foundation
import XCTest

open class MobileElement: ScopingFunctionSupported {
    public let rootView: XCUIElement

    required public init(_ element: XCUIElement = XCUIApplication()) {
        self.rootView = element
    }
    
    convenience public init(_ identifier: String, _ type: XCUIElement.ElementType = .any) {
        let view = XCUIApplication()
            .descendants(matching: type)
            .element(matching: type, identifier: identifier)
        
        self.init(view)
    }
    
    convenience public init(_ e: MobileElement) {
        self.init(e.rootView)
    }
  
    public func childElement<T: MobileElement>(_ identifier: String, _ type: XCUIElement.ElementType = .any) -> T {
        T(
            rootView
                .descendants(matching: type)
                .matching(identifier: identifier)
                .firstMatch
        )
    }
    
    public func childElements<R: MobileElement, T: MobileElements<R>>(_ identifier: String, _ type: XCUIElement.ElementType = .any) -> T {
        T(
            rootView
                .descendants(matching: type)
                .matching(identifier: identifier)
        )
    }
}
