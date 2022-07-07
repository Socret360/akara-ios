//
//  Akara.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import MLKitLanguageID

final public class Akara {
    private var language: AkaraLanguage!
    
    private lazy var languageId = LanguageIdentification.languageIdentification()
    
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
    public func getLanguage(text: String, completion: @escaping((AkaraLanguage?, AkaraError?) -> Void)){
        languageId.identifyLanguage(for: text) { languageCode, error in
            if let error = error {
                completion(nil, .generic(error.localizedDescription))
            }
            
            if let languageCode = languageCode, languageCode != "und" {
                print("[i] Identified Language: \(languageCode)")
                if let akaraLanguage = AkaraLanguage(rawValue: languageCode){
                    completion(akaraLanguage, nil)
                }else {
                    completion(nil, .generic("Language detected <\(languageCode)> is not supported"))
                }
            } else {
                completion(nil, .unknownLanguage)
            }
        }
    }
    
    public func getSequences(sentence: String) -> Sequences {
        return []
    }
    
    public func getSequences(sentence: String, completion: @escaping ((Sequences) -> Void)) {
        let chunks = sentence.trimmingCharacters(in: .whitespaces).split(separator: " ").map{String($0)}
        var temp = ""
        var prevLanguage: AkaraLanguage? = nil
        var sequences: Sequences = []
        
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            chunks.forEach { chunk in
                dispatchGroup.enter()
                self.getLanguage(text: chunk) { currentLanguage, error in
                    if let currentLanguage = currentLanguage {
                        if prevLanguage == nil {
                            temp.append(chunk)
                        } else {
                            guard let prevLang = prevLanguage else { return }
                            if prevLang == currentLanguage, currentLanguage == .english {
                                temp.append(" \(chunk)")
                            } else {
                                sequences.append(Sequence(language: prevLang, text: temp))
                                temp = chunk
                            }
                        }
                        prevLanguage = currentLanguage
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(sequences)
        }
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
