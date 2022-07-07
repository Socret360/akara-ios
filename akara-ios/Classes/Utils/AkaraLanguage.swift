//
//  AkaraLanguage.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import Foundation

public enum AkaraLanguage: String, Equatable {
    case english = "en"
    case khmer = "km"
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
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
