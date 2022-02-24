//
//  StringExtensions.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 20.02.22.
//

import Foundation

extension String {
    mutating func removingRegexMatches(pattern: String, replaceWith: String = "") {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch { return }
    }
    
    func capitalizeFirst() -> String {
        let firstIndex = self.index(startIndex, offsetBy: 1)
        return self.substring(to: firstIndex).capitalized + self.substring(from: firstIndex).lowercased()
    }
    
    func withQuotationMarksRaw() -> String {
        return #"""# + self + #"""#
    }
}

extension CharacterSet {
    var allCharacters: [Character] {
        var result: [Character] = []
        for plane: UInt8 in 0...16 where self.hasMember(inPlane: plane) {
            for unicode in UInt32(plane) << 16 ..< UInt32(plane + 1) << 16 {
                if let uniChar = UnicodeScalar(unicode), self.contains(uniChar) {
                    result.append(Character(uniChar))
                }
            }
        }
        return [result[4]]
    }
}
