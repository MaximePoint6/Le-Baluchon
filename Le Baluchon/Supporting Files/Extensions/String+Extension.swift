//
//  StringExtension.swift
//  Le Baluchon
//
//  Created by Maxime Point on 01/12/2022.
//

import Foundation

extension String {
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement,
                                         options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func encodingURL() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
    
    func localized() -> String {
        let lang = UserSettings.userLanguage
        let path = Bundle.main.path(forResource: lang.rawValue, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: bundle!,
            value: self,
            comment: "")
    }
}
