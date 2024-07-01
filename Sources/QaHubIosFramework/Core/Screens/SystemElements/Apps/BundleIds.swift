import XCTest

enum BundleIds {
    static let messages = "com.apple.MobileSMS"
    static let safari = "com.apple.mobilesafari"
    static let settings = "com.apple.Preferences"
    static let springboard = "com.apple.springboard"
}

let messagesApp =  XCUIApplication(bundleIdentifier: BundleIds.messages)
let springboardApp = XCUIApplication(bundleIdentifier: BundleIds.springboard)

extension XCUIApplication {
    func hide() {
        XCUIDevice.shared.press(XCUIDevice.Button.home)
    }
    
    func printArgsAndLaunch() {
        autotestLog("Starting the app with launch args: \(self.launchArguments)")
        self.launch()
    }
}
