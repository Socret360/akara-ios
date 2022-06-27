//
//  EnglishWordBreaker.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/27/22.
//

import Foundation

final class EnglishWordBreaker: WordBreakable {
    func split(sentence: String) -> [String] {
        return sentence.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").map({ String($0) })
    }
    
    func close() {}
}
