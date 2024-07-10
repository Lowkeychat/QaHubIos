import Foundation
import XCTest

public extension MobileElement {

    enum Direction: Int {
        case upward
        case down
        case left
        case right
    }
  
   @discardableResult
   func waitForElement(_ predicateFormat: PredicateFormats = .exists,
                       timeout: Double = Timeout.longest,
                       failOnError: Bool = true
   ) -> Bool {
       rootView.waitForElement(predicateFormat, timeout: timeout, failOnError: failOnError)
   }

    @discardableResult
    func tap(predicateFormat: PredicateFormats = .isHittable, timeout: Double = Timeout.longer) -> MobileElement {
        Report.step("Tap: \(rootView)") {
            rootView.tap()
        }
        
        return self
    }
    
    @discardableResult
    func longTap(_ duration: Double = 1.5) -> MobileElement {
        Report.step("Long Tap: \(rootView)") {
            rootView.press(forDuration: duration)
        }
        
        return self
    }
    
    @discardableResult
    func doubleTap(predicateFormat: PredicateFormats = .isHittable, timeout: Double = Timeout.longer) -> MobileElement {
        Report.step("Double Tap: \(rootView)") {
            rootView.doubleTap()
        }
        
        return self
    }

    @discardableResult
    func tapAtCenter() -> MobileElement {
        Report.step("TapAtCenter: \(rootView)") {
            let xTapPoint = CGFloat(rootView.frame.width * 0.5)
            let yTapPoint = CGFloat(rootView.frame.height * 0.5)
            
            rootView.waitForElement()
            let coordinate = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            coordinate.withOffset(CGVector(dx: xTapPoint, dy: yTapPoint)).tap()
        }
        
        return self
    }
    
    @discardableResult
    func tapAtRelativeCoords(_ relX: Double = 0.5, _ relY: Double = 0.5) -> MobileElement {
        Report.step("Tap at relative position: \(rootView), relX=\(relX), relY=\(relY)") {
            let xTapPoint = CGFloat(rootView.frame.width * relX)
            let yTapPoint = CGFloat(rootView.frame.height * relY)
            
            rootView.waitForElement()
            let coordinate = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            coordinate.withOffset(CGVector(dx: xTapPoint, dy: yTapPoint)).tap()
        }
        
        return self
    }

    @discardableResult
    func selectAndType(_ text: String, clear: Bool = false, slowInput: Bool = true) -> MobileElement {
        Report.step("SelectAndType: \(rootView). Text: \(text)") {
            if !self.rootView.hasFocus {
                self.tapAtCenter()
            }
            
            if clear { self.clear()}

            if slowInput {
                for character in text {
                    rootView.typeText(String(character))
                }
            } else {
                rootView.typeText(text)
            }
        }
        
        return self
    }
    
    @discardableResult
    func clear() -> MobileElement {
        var counter = 0
        repeat {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue,
                                      count: rootView.stringValue.count
            )
            self.rootView.typeText(deleteString)
            counter += 1
            self.tapAtRelativeCoords(0.95, 0.5)
        } while !(rootView.stringValue).isEmpty && counter <= 3
        
        return self
    }

    @discardableResult
    func tapIfExists(timeout: Double = Timeout.short) -> MobileElement {
        Report.step("TapIfExists: \(rootView)") {
            if rootView.waitForExistence(timeout: timeout) {
                Report.step("Element found. Tap.") {
                    rootView.tap()
                }
            }
            
            return self
        }
    }

    @discardableResult
    func customScroll(
        _ direction: Direction,
        xTapPoint: CGFloat = 0.5 + CGFloat.random(in: -0.15...0.15),
        yTapPoint: CGFloat = 0.5 + CGFloat.random(in: -0.15...0.15),
        velocity: XCUIGestureVelocity = .default,
        adjustment: CGFloat = 0.25
    ) -> MobileElement {
        let pressDuration: TimeInterval = 0.02

        let tapPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: xTapPoint, dy: yTapPoint))
        let aboveCenter = rootView.coordinate(withNormalizedOffset: CGVector(dx: xTapPoint, dy: yTapPoint - adjustment))
        let belowCenter = rootView.coordinate(withNormalizedOffset: CGVector(dx: xTapPoint, dy: yTapPoint + adjustment))
        let leftOfCenter = rootView.coordinate(withNormalizedOffset: CGVector(dx: xTapPoint - adjustment, dy: yTapPoint))
        let rightOfCenter = rootView.coordinate(withNormalizedOffset: CGVector(dx: xTapPoint + adjustment, dy: yTapPoint))

        switch direction {
        case .down:
            tapPoint.press(
                forDuration: pressDuration,
                thenDragTo: aboveCenter,
                withVelocity: velocity,
                thenHoldForDuration: 0
            )

        case .upward:
            tapPoint.press(
                forDuration: pressDuration,
                thenDragTo: belowCenter,
                withVelocity: velocity,
                thenHoldForDuration: 0
            )

        case .right:
            tapPoint.press(
                forDuration: pressDuration,
                thenDragTo: leftOfCenter,
                withVelocity: velocity,
                thenHoldForDuration: 0
            )

        case .left:
            tapPoint.press(
                forDuration: pressDuration,
                thenDragTo: rightOfCenter,
                withVelocity: velocity,
                thenHoldForDuration: 0
            )
        }
        
        return self
    }

    func isVisible(
        horizontallyBy horizontalPercentage: CGFloat = 50,
        verticallyBy verticalPercentage: CGFloat = 50,
        in parentElement: XCUIElement = XCUIApplication()
    ) -> Bool {
        if rootView.exists {
            let parentFrame = parentElement.frame
            let elementTapPointX = rootView.frame.minX + rootView.frame.width * horizontalPercentage / 100
            let elementTapPointY = rootView.frame.minY + rootView.frame.height * verticalPercentage / 100

            return (parentFrame.minX..<parentFrame.maxX).contains(elementTapPointX) &&
            (parentFrame.minY..<parentFrame.maxY).contains(elementTapPointY)
        }

        return false
    }

    func swipeForElement(
        element: MobileElement,
        _ direction: Direction = .left,
        _ velocity: XCUIGestureVelocity = .default,
        maxSwipes: Int = 20,
        xTapPoint: CGFloat = 0.5 + CGFloat.random(in: -0.15...0.15),
        yTapPoint: CGFloat = 0.5 + CGFloat.random(in: -0.15...0.15),
        adjustment: CGFloat = 0.25,
        horizontalVisiblePercentage: CGFloat = 70,
        verticalVisiblePercentage: CGFloat = 70
    ) -> MobileElement {
        Report.step("SwipeForElement. Parent: \(rootView). Target: \(element). Direction: \(direction.rawValue)") {
            var counter = 0
            self.waitForElement(.isHittable, timeout: Timeout.short)

            while !element.isVisible(
                horizontallyBy: horizontalVisiblePercentage,
                verticallyBy: verticalVisiblePercentage,
                in: rootView
            ) && counter < maxSwipes {
                counter += 1
                customScroll(
                    direction,
                    xTapPoint: xTapPoint,
                    yTapPoint: yTapPoint,
                    velocity: element.rootView.exists ? .slow : velocity,
                    adjustment: adjustment
                )
                element.waitForElement(.isHittable, timeout: Timeout.short, failOnError: false)
            }
        }
        
        return element
    }

    var stringValue: String {
        rootView.value as? String ?? ""
    }
    
    @discardableResult
    func checkExists(timeout: Double = Timeout.double) -> MobileElement {
        Report.check("Element is displayed: '\(rootView)'") {
            XCTAssertTrue(rootView.waitForExistence(timeout: timeout),
                          "Failed to find displayed element: \(rootView)")
        }
        
        return self
    }

    @discardableResult
    func checkNotExists(timeout: Double = Timeout.medium) -> MobileElement {
        Report.check("Element is not displayed: '\(rootView)'") {
            XCTAssertTrue(rootView.waitForElement(.notExists, timeout: timeout),
                          "Failed to wait until element is disappeared: \(rootView)")
        }
        
        return self
    }
    
    @discardableResult
    func checkEnabled(timeout: Double = Timeout.medium) -> MobileElement {
        Report.check("Element is disabled: '\(rootView)'") {
            XCTAssertTrue(rootView.waitForElement(.isEnabled, timeout: timeout),
                          "Failed to wait until element is enabled: \(rootView)")
        }
        
        return self
    }
        
    @discardableResult
    func checkDisabled(timeout: Double = Timeout.medium) -> MobileElement {
        Report.check("Element is disabled: '\(rootView)'") {
            XCTAssertTrue(rootView.waitForElement(.isDisabled, timeout: timeout),
                          "Failed to wait until element is disabled: \(rootView)")
        }
        
        return self
    }
    
    @discardableResult
    func checkVisible(timeout: Double = Timeout.double) -> MobileElement {
        Report.check("Element is visible: '\(rootView)'") {
            XCTAssertTrue(isVisible(), "Failed to confirm that element is visible: \(rootView)")
        }
        
        return self
    }
    
    @discardableResult
    func checkNotVisible(timeout: Double = Timeout.double) -> MobileElement {
        Report.check("Element is not visible: '\(rootView)'") {
            XCTAssertTrue(!isVisible(), "Failed to confirm that element is not visible: \(rootView)")
        }
        
        return self
    }
    
    @discardableResult
    func checkSelected(timeout: Double = Timeout.double) -> MobileElement {
        Report.check("Element is selected: '\(rootView)'") {
            XCTAssertTrue(rootView.waitForElement(.isSelected, timeout: timeout),
                          "Failed to confirm that element is selected: \(rootView)")
        }
        
        return self
    }
    
    @discardableResult
    func checkNotSelected(timeout: Double = Timeout.double) -> MobileElement {
        Report.check("Element is not selected: '\(rootView)'") {
            XCTAssertTrue(rootView.waitForElement(.isNotSelected, timeout: timeout),
                          "Failed to confirm that element is not selected: \(rootView)")
        }
        
        return self
    }

    @discardableResult
    func checkLabel(_ text: String, retries: Int = 5, retryTimeout: Double = 0.5) -> MobileElement {
        let description = "Element \(rootView) has label '\(text)'"
        let errorMessage =  "Element \(rootView) doesn't have label \(text). Actual text: \(rootView.label)"
        
        checkThat(
            description,
            errorMessage: errorMessage,
            retries: retries,
            retryTimeout: retryTimeout,
            { rootView.label },
            equalTo(text)
        )
        
        return self
    }

    @discardableResult
    func checkLabelContains(_ text: String, retries: Int = 5, retryTimeout: Double = 0.5) -> MobileElement {
        let description = "Element \(rootView) has label containing text '\(text)'"
        let errorMessage = "Element \(rootView) doesn't have label containing \(text). Actual text: \(rootView.label)"
        
        checkThat(
            description,
            errorMessage: errorMessage,
            retries: retries,
            retryTimeout: retryTimeout,
            { rootView.label },
            containsString(text)
        )
        
        return self
    }
    
    @discardableResult
    func checkLabeDoesntlContain(_ text: String, retries: Int = 5, retryTimeout: Double = 0.5) -> MobileElement {
        let description = "Element \(rootView)'s label doesn't contain text '\(text)'"
        let errorMessage = "Element \(rootView)'s label contains \(text). Actual text: \(rootView.label)"
        
        checkThat(
            description,
            errorMessage: errorMessage,
            retries: retries,
            retryTimeout: retryTimeout,
            { rootView.label },
            doesntContainString(text)
        )
        
        return self
    }

    @discardableResult
    func checkValue(_ text: String, retries: Int = 5, retryTimeout: Double = 0.5) -> MobileElement {
        let description = "Element \(rootView) has value '\(text)'"
        let errorMessage = "Element \(rootView)'s value doesn't match with expected one. Actual Value: \(rootView.stringValue)"
        
        checkThat(
            description,
            errorMessage: errorMessage,
            retries: retries,
            retryTimeout: retryTimeout,
            { rootView.stringValue },
            equalTo(text)
        )
        
        return self
    }
    
    @discardableResult
    func checkPlaceholder(_ text: String, retries: Int = 5, retryTimeout: Double = 0.5) -> MobileElement {
        let description = "Element \(rootView) has placeholder '\(text)'"
        let errorMessage = "Element \(rootView) doesn't have placeholer \(text). Actual placeholder: \(rootView.placeholderValue ?? "")"
        
        checkThat(
            description,
            errorMessage: errorMessage,
            retries: retries,
            retryTimeout: retryTimeout,
            { rootView.placeholderValue },
            equalTo(text)
        )
        
        return self
    }
}
