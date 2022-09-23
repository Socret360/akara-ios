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
    public var start: Int
    public var end: Int

    public init(language: AkaraLanguage, text: String, start: Int, end: Int) {
        self.language = language
        self.text = text
        self.start = start
        self.end = end
    }

    public func toString() -> String {
        return "{\(self.text): \(self.language) | start: \(self.start), end: \(self.end)}"
    }
}

public typealias Sequences = [Sequence]
