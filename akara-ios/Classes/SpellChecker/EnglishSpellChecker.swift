//
//  EnglishSpellChecker.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/23/22.
//

import Foundation

final class EnglishSpellChecker: SpellCheckable {
    var name: String { return String(describing: self) }
    
    var modelName: String { return "english_spell_correction_model" }
    
    var root: BKNode?
    
    init() {
        do {
            guard let loadedRoot = try loadModel() else { return }
            self.root = loadedRoot
            assert(root != nil, "Root node of the \(name) cannot be nil")
        } catch {
            print(error.localizedDescription)
        }
    }
}
