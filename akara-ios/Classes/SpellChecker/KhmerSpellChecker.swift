//
//  KhmerSpellChecker.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/24/22.
//

import Foundation

final class KhmerSpellChecker: SpellCheckable {
    var name: String { return String(describing: self) }
    
    var modelName: String { return "khmer_spell_correction_model" }
    
    var root: BKNode?
    
    init() {
        guard let loadedRoot = loadModel() else { return }
        self.root = loadedRoot
        assert(root != nil, "Root node of the \(name) cannot be nil")
    }
}
