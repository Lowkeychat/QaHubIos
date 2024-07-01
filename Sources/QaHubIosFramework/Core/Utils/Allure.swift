import XCTest

private extension String {
    static let allureId = "AS_ID"
    static let allureLabel = "allure.label."
    static let allureName = "allure.name"
    static let component = "component"
    static let epic = "epic"
    static let feature = "feature"
    static let issue = "issue"
    static let layer = "layer"
    static let package = "package"
    static let page = "page"
    static let platform = "platform"
    static let runType = "run_type"
    static let service = "service"
    static let severity = "severity"
    static let story = "story"
    static let subfeature = "subfeature"
    static let suite = "suite"
    static let tag = "tag"
    static let team = "team"
    static let testId = "testId"
    static let testSuite = "testSuite"
    static let thread = "thread"
}

public enum Allure {
    static func allureId(_ value: String) {
        label(.allureId, value)
    }

    static func component(_ value: String) {
        label(.component, value)
    }

    static func epic(_ value: String) {
        label(.epic, value)
    }

    static func feature(_ value: String) {
        label(.feature, value)
    }

    static func issue(_ value: String) {
        label(.issue, value)
    }

    static func layer(_ value: String) {
        label(.layer, value)
    }

    static func package(_ value: String) {
        label(.package, value)
    }

    static func page(_ value: String) {
        label(.page, value)
    }

    static func platform(_ value: String) {
        label(.platform, value)
    }

    static func run_type(_ value: String) {
        label(.runType, value)
    }

    static func service(_ value: String) {
        label(.service, value)
    }

    static func severity(_ value: Severity) {
        label(.severity, value.rawValue)
    }

    static func story(_ value: String) {
        label(.story, value)
    }

    static func subfeature(_ value: String) {
        label(.subfeature, value)
    }

    static func suite(_ value: String) {
        label(.suite, value)
    }

    static func tag(_ value: String) {
        label(.tag, value)
    }
  
    static func tags(_ values: String...) {
        values.forEach { value in
            label(.tag, value)
        }
    }

    static func team(_ value: String) {
        label(.team, value)
    }

    static func testId(_ value: String) {
        label(.testId, value)
    }

    static func testSuite(_ value: String) {
        label(.testSuite, value)
    }

    static func thread(_ value: String) {
        label(.thread, value)
    }

    static func label(_ name: String, _ value: String) {
        XCTContext.runActivity(named: .allureLabel + name + ":" + value) { _ in }
    }

    static func name(_ value: String) {
        XCTContext.runActivity(named: .allureName + ":" + value) { _ in }
    }

    func step(_ name: String, step: () -> Void) {
        XCTContext.runActivity(named: name) { _ in
            step()
        }
    }
}

public enum Severity: String {
    case blocker
    case critical
    case normal
    case minor
    case trivial
}
