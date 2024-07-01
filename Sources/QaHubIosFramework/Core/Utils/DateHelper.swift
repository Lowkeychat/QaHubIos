import XCTest

public extension Date {
    func toISOString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
    static func fromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: string)
    }
    
    static func localDate() -> Date {
        let currentUtc = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: currentUtc))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: currentUtc) else {return Date()}

        return localDate
    }
}
