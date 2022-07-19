//
//  TrieNode.swift
//  akara-ios
//
//  Created by Socret Lee on 7/10/22.
//

import Foundation

class TrieNode {
    var char: String?
    var isEnd: Bool
    public var children: [String: TrieNode]
    
    public init(
        char: String?,
        isEnd: Bool,
        children: [String: TrieNode]
    ) {
        self.char = char
        self.isEnd = isEnd
        self.children = children
    }
    
    func hasChar(char: String) -> Bool {
        return self.children[char] != nil
    }
}
