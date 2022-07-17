//
//  Akara.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import MLKitLanguageID

public class Akara {
    private var languageId = LanguageIdentification.languageIdentification()
    
    private var khmerSpellChecker = KhmerSpellChecker()
    private var englishSpellChecker = EnglishSpellChecker()
    
    private var khmerWordBreaker = KhmerWordBreaker()
    private var englishWordBreaker = EnglishWordBreaker()
    
    private var khmerAutoComplete = KhmerAutoCompletion()
    private var englishAutoComplete = EnglishAutoCompletion()
    
    private var khmerNextWordPredictor = KhmerNextWordPredictor()
    
    public init() { }
    
    public func suggest(sentence: String, completion: @escaping((AkaraSuggestionType, [String], [Sequence], [String]) -> Void)) {
        let sequences = getSequences(sentence: sentence)
        let sequencesOfInterest = self.getSequencesOfInterest(sequences)
        let words = self.getWordsFromSequences(sequencesOfInterest)
        let completions = self.getWordCompletions(words)
        
        if (completions.count > 0) {
            completion(
                .completion,
                completions,
                sequences,
                words.map { (word) -> String in
                    word.text
                }
            );
        } else {
            let isLastWordCorrect = self.isWordCorrect(words.last!)

            if (isLastWordCorrect) {
                
                completion(
                    .nextWord,
                    self.getNextWordSuggestions(words),
                    sequences,
                    words.map { (word) -> String in
                        word.text
                    }
                );

            } else {
                
                completion(
                    .correction,
                    self.getWordCorrections(words.last!),
                    sequences,
                    words.map { (word) -> String in
                        word.text
                    }
                );

            }
        }
    }
    
    private func getLanguage(text: String) -> AkaraLanguage {
        var languageCode: String = "und"
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        self.languageId.identifyLanguage(for: text) { lc, error in
            if (error == nil && lc != nil) {
                languageCode = lc!
            }
            
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.wait()
        
        if (languageCode == "km") {
            return .khmer
        }
        
        if (languageCode == "en") {
            return .english
        }
        
        for charUnicode in text.unicodeScalars {
            let char = String(charUnicode)
            if LanguageUtil.EN_ALPHABET.contains(char) {
                return .english
            }
        }
        
        return .other
    }
    
    private func getSequences(sentence: String) -> [Sequence] {
        let chunks = sentence.trimmingCharacters(in: .whitespaces).split(separator: " ").map{String($0)}
        var temp = ""
        var prevLanguage: AkaraLanguage? = nil
        var sequences: [Sequence] = []
                
        for i in 0...chunks.count {
            if (i < chunks.count) {
                let chunk = chunks[i]
                let currentLanguage = self.getLanguage(text: chunk)
                if prevLanguage == nil {
                    temp.append(chunk)
                } else if (prevLanguage == currentLanguage && currentLanguage == .english) {
                    temp.append(" \(chunk)")
                } else {
                    sequences.append(Sequence(language: prevLanguage!, text: temp))
                    temp = chunk
                }
                
                prevLanguage = currentLanguage
            } else {
                sequences.append(Sequence(language: prevLanguage!, text: temp))
            }
        }
        
        return sequences
    }
    
    private func getWordCorrections (_ word: Word) -> [String] {
        if word.language == .english {
            return englishSpellChecker.corrections(word: word.text)
        } else {
            return khmerSpellChecker.corrections(word: word.text)
        }
    }
    
    // MARK: Using wordbreaker function to check if target word is correct
    private func getWordsFromSequences(_ sequences: Sequences) -> Words {
        var words: Words = []
        sequences.forEach { sequence in
            let text = sequence.text.filter({ !$0.isNumber })
            var splittedWords: Words = []
            if sequence.language == .english {
                splittedWords = englishWordBreaker.split(sentence: text).map { word in Word(text: word, language: sequence.language) }
            }else {
                splittedWords = khmerWordBreaker.split(sentence: text).map { word in Word(text: word, language: sequence.language) }
            }
            guard splittedWords.count > 0 else { return }
            words.append(contentsOf: splittedWords)
        }
        return words
    }
    
    // MARK: Using nextWordPredictor to get next words
    private func getNextWordSuggestions(_ words: [Word]) -> [String] {
        var inputText = words.map {(s) -> String in
            return s.text
        }.joined(separator: "%")
        inputText += "%"
        
        if (words.last?.language == .khmer) {
            return khmerNextWordPredictor.predict(inputText)
        }
        
        return []
    }
    
    // MARK: Using autoComplete to predict next likely words
    private func getWordCompletions(_ words: [Word]) -> [String] {
        if (words.last!.language == .english) {
            return englishAutoComplete.predict(words.last!.text)
        }
        
        return khmerAutoComplete.predict(words.last!.text)
    }
    
    // MARK: Using autocompletion function to check if target word is correct
    private func isWordCorrect(_ word: Word) -> Bool {
        if (word.language == .khmer) {
            return khmerAutoComplete.isCorrect(word.text)
        }
        
        return englishAutoComplete.isCorrect(word.text)
    }
    
    private func getSequencesOfInterest(_ sequences: [Sequence]) -> [Sequence] {
        var prevLanguage: AkaraLanguage? = nil
        var tmp = [Sequence]()
        
        for i in (0..<sequences.count).reversed() {
            let currentLanguage = sequences[i].language
            if (prevLanguage != nil && prevLanguage != currentLanguage) {
                return tmp
            }
            tmp.insert(sequences[i], at: 0)
            prevLanguage = currentLanguage
        }
        
        return tmp
   }
}
