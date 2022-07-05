//
//  EnglishWordBreaker.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/27/22.
//

import Foundation
import TensorFlowLite

final class EnglishWordBreaker: WordBreakable {
    var modelName: String { return "" }
    
    var name: String { return String(describing: self) }
    
    var model: Interpreter?
    
    func split(sentence: String) -> [String] {
        return sentence.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").map({ String($0) })
    }
    
    func loadModel() {}
    
    func close() {}
}
