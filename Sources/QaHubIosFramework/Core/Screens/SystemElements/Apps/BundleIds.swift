import XCTest

public enum BundleIds {
    static let messages = "com.apple.MobileSMS"
    static let safari = "com.apple.mobilesafari"
    static let settings = "com.apple.Preferences"
    static let springboard = "com.apple.springboard"
}

public let messagesApp =  XCUIApplication(bundleIdentifier: BundleIds.messages)
public let springboardApp = XCUIApplication(bundleIdentifier: BundleIds.springboard)

public extension XCUIApplication {
    func hide() {
        XCUIDevice.shared.press(XCUIDevice.Button.home)
    }
    
    func printArgsAndLaunch() {
        autotestLog("Starting the app with launch args: \(self.launchArguments)")
        self.launch()
    }
}
