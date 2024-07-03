import XCTest


public class MobileApp {
    public var app: XCUIApplication
   
    public required init(_ bundleId: String) {
        self.app = XCUIApplication(bundleIdentifier: bundleId)
    }

    public func childElement<T: MobileElement>(_ identifier: String, _ type: XCUIElement.ElementType = .any) -> T {
        T(
            app.descendants(matching: .any)
               .matching(identifier: identifier)
               .firstMatch
        )
    }
    
    public func childElements<R: MobileElement, T: MobileElements<R>>(_ identifier: String, _ type: XCUIElement.ElementType = .any) -> T {
        T(
            app.descendants(matching: .any)
               .matching(identifier: identifier)
        )
    }
    
    public func close() {
        app.terminate()
    }
    
    public func hide() {
        app.hide()
    }
}
