//
//  TranslationTest.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 06/01/2023.
//

import XCTest
@testable import Le_Baluchon

final class TranslationTest: XCTestCase {
    
    var translation: Translation?
    
    override func setUpWithError() throws {
        translation = try! SnakeCaseJSONDecoder().decode(Translation.self,
                                                                from: FakeResponseData.translationCorrectData!)
    }
    
    func testWhenTranslationsIsEmpty() {
        translation?.translations = []
        let resultText = "-"
        
        XCTAssertEqual(resultText, translation?.resultText)
    }
    
    
}
