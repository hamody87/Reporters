//
//  StringExtension.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func localized(withComment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
    func capitalizingFirstLetterOfSentence() -> String {
        var result: String = ""
        for word in self.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ") {
            if word != "" {
                result = "\(result) \(word.prefix(1).uppercased() + word.lowercased().dropFirst())"
            }
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
