//
//  LanguagesTest.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 06/01/2023.
//

import XCTest
@testable import Le_Baluchon

final class LanguagesTest: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    func testLanguageDescription() {
        let languageDescription = "Français"
        
        XCTAssertEqual(languageDescription, UserSettings.userLanguage.description)
    }
    
    
}
    
