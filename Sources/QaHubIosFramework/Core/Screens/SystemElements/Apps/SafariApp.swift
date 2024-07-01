import XCTest

enum SharedUrls {
    static let termsLink = "https://www.mistplay.com/legal/onplay-terms-of-use"
    static let privacyLink = "https://www.mistplay.com/legal/onplay-privacy-notice"
}

let safari = SafariApp()

class SafariApp: MobileApp {
    
    enum Identifiers {
        static let tabBarItemTitle = "TabBarItemTitle"
        static let urlTextField = "URL"
        static let reloadButton = "ReloadButton"
    }
    
    convenience init() {
        self.init(BundleIds.safari)
    }
    
    lazy var tabBarItemTitle = childElement(Identifiers.tabBarItemTitle)
    lazy var urlTextField = childElement(Identifiers.urlTextField)
    lazy var reloadButton = childElement(Identifiers.reloadButton)
    
    func checkCurrentUrl(_ expectableUrl: String) {
        reloadButton.waitForElement()
        tabBarItemTitle.tapAtCenter()
        urlTextField.waitForElement()
        urlTextField.checkValue(expectableUrl)
    }
}
