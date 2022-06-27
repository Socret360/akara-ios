//
//  AkaraLanguage.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import Foundation

public enum AkaraLanguage {
    case english
    case khmer
    
    var spellChecker: SpellCheckable {
        switch self {
        case .english:
            return EnglishSpellChecker()
        case .khmer:
            return KhmerSpellChecker()
        }
    }
    
    var wordBreaker: WordBreakable {
        switch self {
        case .english:
            return EnglishWordBreaker()
        case .khmer:
            return KhmerWordBreaker()
        }
    }
}
