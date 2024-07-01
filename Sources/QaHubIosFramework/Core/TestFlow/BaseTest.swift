import XCTest
import OSLog

class BaseTest: XCTestCase {
    var skipAlerts: Bool = true
    var errorMessage: String?
    var failureScreenshot: Data? = nil
    var qaHubClient: QaHubClient? = nil
    
    private var interruptionMonitors: [NSObjectProtocol] = []
    
    override func setUp() {
        Report.clear()
        
        super.setUp()
        
        if let qaHubClient = qaHubClient {
            XCTestObservationCenter.shared.addTestObserver(Observer(qaHubClient: qaHubClient))
        }
       
        if skipAlerts {
            addAutoSkipAlertsMonitor()
        }
    }
    
   
   override func tearDown() {
        if (errorMessage != nil) {
            failureScreenshot = XCUIScreen.main.screenshot().image.jpegData(compressionQuality: 0.5)
        }
        
        interruptionMonitors.forEach { monitor in
            removeUIInterruptionMonitor(monitor)
        }
    }
   
    
    func addAutoSkipAlertsMonitor() {
        let monitor = addUIInterruptionMonitor(withDescription: "System dialog") { alert -> Bool in
            Report.step("Auto-accepting alert") {
                alert.buttons.element(boundBy: 1).tap()

                return true
            }
        }
        
        interruptionMonitors.append(monitor)
    }
    
    func clearInterruptionMonitors() {
        Report.step("Disable interruption monitiors") {
            interruptionMonitors.forEach { monitor in
                removeUIInterruptionMonitor(monitor)
            }
            
            interruptionMonitors = []
        }
    }
}

func autotestLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    print(items, separator: separator, terminator: terminator)
}
