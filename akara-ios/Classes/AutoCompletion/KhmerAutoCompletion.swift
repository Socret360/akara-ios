//
//  KhmerAutoCompletion.swift
//  akara-ios
//
//  Created by Socret Lee on 7/10/22.
//

import Foundation

class KhmerAutoCompletion: AutoCompletionable {
    private let charMap = (LanguageUtil.KH_CONSTS + LanguageUtil.KH_SUB + LanguageUtil.KH_VOWELS + LanguageUtil.KH_SEPARATOR + LanguageUtil.KH_SYMS + LanguageUtil.KH_DIAC).unicodeScalars.map {(s) -> String in
        return String(s)
    }
    private var root: TrieNode
    private var results: [String]? = nil
    
    public init() {
        self.root = TrieNode(
            char: nil,
            isEnd: false,
            children: [String: TrieNode]()
        )
        
        self.loadModel()
    }
    
    private func loadModel() {
        let path = AkaraBundle.main.path(forResource: "khmer_words_dict", ofType: "txt")!
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            for line in lines {
                let word = line.trimmingCharacters(in: .whitespacesAndNewlines)
                var currentNode = self.root
                for charUnicode in word.unicodeScalars {
                    let char = String(charUnicode)
                    if (!currentNode.hasChar(char: char)) {
                        currentNode.children[char] = TrieNode(
                            char: char,
                            isEnd: false,
                            children: [String: TrieNode]()
                        )
                    }
                    
                    currentNode = currentNode.children[char]!
                }
                
                currentNode.isEnd = true
            }
        } catch {
            print(error)
        }
    }
    
    private func getPrefixNode(_ text: String) -> TrieNode? {
        var currNode = self.root
        for charUnicode in text.unicodeScalars {
            let char = String(charUnicode)
            if (currNode.hasChar(char: char)) {
                currNode = currNode.children[char]!
            } else {
                return nil
            }
        }

        return currNode
    }
    
    private func getCompletionsRec(currNode: TrieNode, currPrefix: String) {
        if (currNode.isEnd) {
            results!.append(currPrefix)
        }

        for charNode in currNode.children {
            getCompletionsRec(
                currNode: charNode.value,
                currPrefix: currPrefix.appending(String(charNode.value.char!))
            )
        }
    }

    func isCorrect(_ word: String) -> Bool {
        let prefixNode = getPrefixNode(word)
        return prefixNode != nil && prefixNode!.isEnd
    }
    
    func predict(_ text: String) -> [String] {
        let prefixNode = getPrefixNode(text)
        if (prefixNode == nil) {
            return []
        }
        
        results = [String]()
        getCompletionsRec(currNode: prefixNode!, currPrefix: text)
        
        let finalResults = results!.map { (it) -> [String: Any?] in
            return [
                "text": it,
                "distance": it.distance(to: text)
            ]
        }.filter { (it) -> Bool in
            it["distance"] as! Int >= 2
        }.sorted { (a, b) -> Bool in
            a["distance"] as! Int > b["distance"] as! Int
        }

        return finalResults.map { (it) -> String in
            return it["text"] as! String
        }
    }
    
    func close() { }
}
