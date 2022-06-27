//
//  WordBreakable.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/27/22.
//

import Foundation

protocol WordBreakable {
    /// Splits words from a sentence
    func split(sentence: String) -> [String]
    
    func close() {}
}
