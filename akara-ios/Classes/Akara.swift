//
//  Akara.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import Foundation

final public class Akara {
    private var language: AkaraLanguage!
    
//    private lazy var languageId = NaturalLanguage
    
    private var spellChecker: SpellCheckable {
        return language.spellChecker
    }
    
    private var wordBreaker: WordBreakable {
        return language.wordBreaker
    }
    
    public init(akaraLanguage: AkaraLanguage) {
        self.language = akaraLanguage
    }
    
    // MARK: - Public methods
    public func getLanguage(text: String) -> AkaraLanguage {
        
        return .english
    }
    
    public func getSequences(sentence: String) -> Sequences {
        return []
    }
    
    public func getWordCorrections (word: Word) throws -> Words {
        guard !word.text.isEmpty else { throw AkaraError.emptyTargetString }
        return spellChecker.corrections(word: word.text).map { Word(text: $0, language: word.language) }
    }
    
    // MARK: Using autocompletion function to check if target word is correct
    public func isWordCorrect(word: String) -> Bool {
        return false
    }
    
    // MARK: Using wordbreaker function to check if target word is correct
    public func getWordsFromSequence(sequences: Sequences) -> Words {
        var words: Words = []
        sequences.forEach { sequence in
            let text = sequence.text.filter({ !$0.isNumber })
            let splittedWords = sequence.language.wordBreaker.split(sentence: text).map { word in Word(text: word, language: sequence.language) }
            guard splittedWords.count > 0 else { return }
            words.append(contentsOf: splittedWords)
        }
        return words
    }
    
    // MARK: Using nextWordPredictor to get next words
    public func getNextWordSuggestions(words: Words) -> Words {
        return []
    }
    
    // MARK: Using autoComplete to predict next likely words
    public func getWordCompletions(words: Words) -> Words {
        return []
    }
}
