//
//  Sequence.swift
//  akara-ios
//
//  Created by Vaifat Huy on 7/4/22.
//

import Foundation

final public class Sequence {
    public var language: AkaraLanguage
    public var text: String

    public init(language: AkaraLanguage, text: String) {
        self.language = language
        self.text = text
    }

    public func toString() -> String {
        return "{\(self.text): \(self.language)}"
    }
}

public typealias Sequences = [Sequence]
