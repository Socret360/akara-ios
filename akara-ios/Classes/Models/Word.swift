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
    
    public init(text: String, language: AkaraLanguage) {
        self.text = text
        self.language = language
    }

    public func toString() -> String {
        return "{\(self.text): \(self.language)}"
    }
}

public typealias Words = [Word]
