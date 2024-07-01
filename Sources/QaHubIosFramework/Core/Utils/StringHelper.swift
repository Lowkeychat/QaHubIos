import XCTest

@available(iOS 16.0, *)
public extension String {
    func filterDigits() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func takeFirst(_ count: Int = 1) -> String {
        let startIndex = index(startIndex, offsetBy: 0)
        let endIndex = index(startIndex, offsetBy: count - 1)
        let range = startIndex...endIndex

        return String(self[range])
    }
    
    func slice(_ start: Int, _ end: Int) -> String {
        
        let startIndex = index(startIndex, offsetBy: start)
        let endIndex = index(startIndex, offsetBy: end - start)
        let range = startIndex...endIndex

        return String(self[range])
    }
    
    func matchRegex(_ regex: String) -> Bool {
        let regexParsed = try? Regex(regex)
        
        if let regexParsed = regexParsed {
            return !(self.matches(of: regexParsed).isEmpty)
        } else {
            XCTFail("Failed to parse regex in string: \(regex)")
            return false
        }
    }
    
    func substringBeforeLast(_ substring: String) -> String {
        let split = self.split(separator: substring)
        
        if split.count > 1 {
            let dropLast = split[0 ..< split.count - 1]
            
            return dropLast.joined(separator: substring)
        }
        
        return self
    }
    
    func substringAfterLast(_ substring: String) -> String {
        let split = self.split(separator: substring)
        
        if split.count > 1 {
            let match = String(describing: split.last)

            return match
        }
        
        return self
    }
    
    func substringSinceLast(_ substring: String) -> String {
        let split = self.split(separator: substring)
        
        if split.count > 1 {
            return "\(substring)\(split.last ?? "")"
        }
        
        return self
    }
}
