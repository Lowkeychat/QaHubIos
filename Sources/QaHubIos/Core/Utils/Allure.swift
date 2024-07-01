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
    public static func allureId(_ value: String) {
        label(.allureId, value)
    }

    public static func component(_ value: String) {
        label(.component, value)
    }

    public static func epic(_ value: String) {
        label(.epic, value)
    }

    public static func feature(_ value: String) {
        label(.feature, value)
    }

    public static func issue(_ value: String) {
        label(.issue, value)
    }

    public static func layer(_ value: String) {
        label(.layer, value)
    }

    public static func package(_ value: String) {
        label(.package, value)
    }

    public static func page(_ value: String) {
        label(.page, value)
    }

    public static func platform(_ value: String) {
        label(.platform, value)
    }

    public static func run_type(_ value: String) {
        label(.runType, value)
    }

    public static func service(_ value: String) {
        label(.service, value)
    }

    public static func severity(_ value: Severity) {
        label(.severity, value.rawValue)
    }

    public static func story(_ value: String) {
        label(.story, value)
    }

    public static func subfeature(_ value: String) {
        label(.subfeature, value)
    }

    public static func suite(_ value: String) {
        label(.suite, value)
    }

    public static func tag(_ value: String) {
        label(.tag, value)
    }
  
    public static func tags(_ values: String...) {
        values.forEach { value in
            label(.tag, value)
        }
    }

    public static func team(_ value: String) {
        label(.team, value)
    }

    public static func testId(_ value: String) {
        label(.testId, value)
    }

    public static func testSuite(_ value: String) {
        label(.testSuite, value)
    }

    public static func thread(_ value: String) {
        label(.thread, value)
    }

    public static func label(_ name: String, _ value: String) {
        XCTContext.runActivity(named: .allureLabel + name + ":" + value) { _ in }
    }

    public static func name(_ value: String) {
        XCTContext.runActivity(named: .allureName + ":" + value) { _ in }
    }
}

public enum Severity: String {
    case blocker
    case critical
    case normal
    case minor
    case trivial
}
