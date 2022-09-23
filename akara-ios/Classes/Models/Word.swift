//
//  Word.swift
//  akara-ios
//
//  Created by Vaifat Huy on 7/4/22.
//

import Foundation

final public class Word {
    public var text: String
    public var language: AkaraLanguage
    public var start: Int
    public var end: Int
    
    public init(text: String, language: AkaraLanguage, start: Int, end: Int) {
        self.text = text
        self.language = language
        self.start = start
        self.end = end
    }

    public func toString() -> String {
        return "{\(self.text): \(self.language) | start: \(self.start) end: \(self.end)}"
    }
}

public typealias Words = [Word]
