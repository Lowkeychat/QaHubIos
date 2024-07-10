import XCTest

public class SafariApp: MobileApp {
    
    enum Identifiers {
        static let tabBarItemTitle = "TabBarItemTitle"
        static let urlTextField = "URL"
        static let reloadButton = "ReloadButton"
    }
    
    public convenience init() {
        self.init(BundleIds.safari)
    }
    
    public lazy var tabBarItemTitle = childElement(Identifiers.tabBarItemTitle)
    public lazy var urlTextField = childElement(Identifiers.urlTextField)
    public lazy var reloadButton = childElement(Identifiers.reloadButton)
    
    public func checkCurrentUrl(_ expectableUrl: String) {
        reloadButton.waitForElement()
        tabBarItemTitle.tapAtCenter()
        urlTextField.waitForElement()
        urlTextField.checkValue(expectableUrl)
    }
}
