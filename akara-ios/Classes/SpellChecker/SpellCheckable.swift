//
//  SpellCheckProtocol.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/23/22.
//

import Foundation
import XMLCoder

protocol SpellCheckable {
    /// Checker's name/identifier
    var name: String { get }
    
    /// The name of the xml model; Specifying the `modelName` correct to ensure `loadModel` will be able to load the model correctly.
    var modelName: String { get }
    
    // The root node loaded from xml model file
    var root: BKNode? { set get }
    
    /// Load xml model file from specified `modelName`
    func loadModel() throws -> BKNode?
    
    /// Returns an array of correctly suggestion strings
    func corrections(word: String) -> [String]
}

extension SpellCheckable {
    func loadModel() throws -> BKNode? {
        guard !modelName.isEmpty else {
            throw AkaraError.generic("modelName '\(modelName)'cannot be empty")
        }
        guard let xmlPath = AkaraBundle.main.url(forResource: modelName, withExtension: "xml") else {
            throw AkaraError.unknownResource(modelName)
        }
        do {
            let data = try Data(contentsOf: xmlPath)
            let tree = try XMLDecoder().decode(BKRoot.self, from: data)
            return tree.node
        } catch {
            throw AkaraError.loadModelFailure(error.localizedDescription)
        }
    }
    
    func corrections(word: String) -> [String] {
        var matches: [String] = []
        guard let root = root else { return matches }
        var stack: [BKNode] = [root]
        let N = 2  // threshold
        
        while !stack.isEmpty {
            guard let currentNode = stack.popLast() else {
                return matches
            }
            if (currentNode.word ?? "").distance(to: word) > N {
                if let children = currentNode.children?.nodes, children.count > 0 {
                    children.forEach({
                        if (currentNode.word ?? "").distance(to: word) - N <= $0.weightInt ?? 0 && $0.weightInt ?? 0 <= (currentNode.word ?? "").distance(to: word) + N {
                            stack.append($0)
                        }
                    })
                }
            }else {
                matches.append(currentNode.word ?? "")
            }
        }
        
        return matches
    }
}
