//
//  Akara.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import Foundation

final public class Akara {
    private var language: AkaraLanguage!
    
    private var spellChecker: SpellCheckable {
        return language.spellChecker
    }
    
    public init(akaraLanguage: AkaraLanguage) {
        self.language = akaraLanguage
    }
    
    // MARK: - Public methods
    
    public func getWordCorrections (word: String, completion: @escaping ((_ corrections: [String]) -> Void)) throws {
        guard !word.isEmpty else {
            throw AkaraError.emptyTargetString
        }
        spellChecker.corrections(word: word, completion: completion)
    }
    
    // MARK: Using autocompletion function to check if target word is correct
    public func isWordCorrect(word: String) -> Bool {
        return false
    }
    
    // MARK: Using wordbreaker function to check if target word is correct
    public func getWordsFromSequence(sequences: String) -> [String] {
        return []
    }
}
