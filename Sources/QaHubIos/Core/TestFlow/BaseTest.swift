import XCTest
import OSLog

open class BaseTest: XCTestCase {
    public var skipAlerts: Bool = true
    public var errorMessage: String?
    public var failureScreenshot: Data? = nil
    
    public var qaHubClient: QaHubClient? = nil
    
    private var interruptionMonitors: [NSObjectProtocol] = []
    
    open override func setUp() {
        Report.clear()
        
        super.setUp()
        
        setupQaHubClient()
        if let qaHubClient = qaHubClient {
            XCTestObservationCenter.shared.addTestObserver(Observer(qaHubClient: qaHubClient))
        }
       
        if skipAlerts {
            addAutoSkipAlertsMonitor()
        }
    }
   
    open override func tearDown() {
        super.tearDown()
        
        if (errorMessage != nil) {
            failureScreenshot = XCUIScreen.main.screenshot().image.jpegData(compressionQuality: 0.5)
        }
        
        interruptionMonitors.forEach { monitor in
            removeUIInterruptionMonitor(monitor)
        }
    }
   
    
    public func addAutoSkipAlertsMonitor() {
        let monitor = addUIInterruptionMonitor(withDescription: "System dialog") { alert -> Bool in
            Report.step("Auto-accepting alert") {
                alert.buttons.element(boundBy: 1).tap()

                return true
            }
        }
        
        interruptionMonitors.append(monitor)
    }
    
    public func clearInterruptionMonitors() {
        Report.step("Disable interruption monitiors") {
            interruptionMonitors.forEach { monitor in
                removeUIInterruptionMonitor(monitor)
            }
            
            interruptionMonitors = []
        }
    }
    
    open func setupQaHubClient() {
        self.qaHubClient = nil
    }
}

public func autotestLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    print(items, separator: separator, terminator: terminator)
}
