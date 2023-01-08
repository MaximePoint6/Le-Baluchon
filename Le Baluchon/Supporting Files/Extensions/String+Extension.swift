//
//  StringExtension.swift
//  Le Baluchon
//
//  Created by Maxime Point on 01/12/2022.
//

import Foundation

extension String {
    
    /// Function to replace string of a text by others
    /// - Parameters:
    ///   - string: string to replace
    ///   - replacement: string that replaces
    /// - Returns: the new string with the changes
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement,
                                         options: NSString.CompareOptions.literal, range: nil)
    }
    
    /// Function to remove spaces in text
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    /// Function to encode a string in correct url
    /// - Returns: Url encoded as String
    func encodingURL() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    /// To capitalize the first letter of the sentence.
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
    
    /// Function to return the translated text according to the language of the user indicated in the UserSettings.
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
