//
//  String.swift
//  Le Baluchon
//
//  Created by Maxime Point on 01/12/2022.
//

import Foundation

extension String {
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func replaceWithSpaceForUrl() -> String {
        return self.replace(string: " ", replacement: "%20")
    }
  }
