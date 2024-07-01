import XCTest


class MobileApp {
    var app: XCUIApplication
   
    required init(_ bundleId: String) {
        self.app = XCUIApplication(bundleIdentifier: bundleId)
    }

    func childElement<T: MobileElement>(_ identifier: String, _ type: XCUIElement.ElementType = .any) -> T {
        T(
            app.descendants(matching: .any)
               .matching(identifier: identifier)
               .firstMatch
        )
    }
    
    func childElements<R: MobileElement, T: MobileElements<R>>(_ identifier: String, _ type: XCUIElement.ElementType = .any) -> T {
        T(
            app.descendants(matching: .any)
               .matching(identifier: identifier)
        )
    }
    
    func close() {
        app.terminate()
    }
    
    func hide() {
        app.hide()
    }
}
