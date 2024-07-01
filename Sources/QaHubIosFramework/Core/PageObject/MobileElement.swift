import Foundation
import XCTest

public class MobileElement: ScopingFunctionSupported {
    let rootView: XCUIElement

    required init(_ element: XCUIElement = XCUIApplication()) {
        self.rootView = element
    }
    
    convenience init(_ identifier: String, _ type: XCUIElement.ElementType = .any) {
        let view = XCUIApplication()
            .descendants(matching: type)
            .element(matching: type, identifier: identifier)
        
        self.init(view)
    }
    
    convenience init(_ e: MobileElement) {
        self.init(e.rootView)
    }
  
    func childElement<T: MobileElement>(_ identifier: String, _ type: XCUIElement.ElementType = .any) -> T {
        T(
            rootView
                .descendants(matching: type)
                .matching(identifier: identifier)
                .firstMatch
        )
    }
    
    func childElements<R: MobileElement, T: MobileElements<R>>(_ identifier: String, _ type: XCUIElement.ElementType = .any) -> T {
        T(
            rootView
                .descendants(matching: type)
                .matching(identifier: identifier)
        )
    }
}
