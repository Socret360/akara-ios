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
    
    /// The name of the xml model
    var modelName: String { get }
    
    // The root node loaded from xml model file
    var root: BKNode? { set get }
    
    /// Load xml model file from specified modelName
    func loadModel() -> BKNode?
    
    /// Returns an array of correctly suggestion strings
    func corrections(word: String, completion: @escaping ((_ corrections: [String]) -> Void))
}

extension SpellCheckable {
    func loadModel() -> BKNode? {
        guard !modelName.isEmpty else {
            assertionFailure("[x] [SpellCheckable: \(name)]: modelName cannot be empty")
            return nil
        }
        guard let xmlPath = AkaraBundle.main.url(forResource: modelName, withExtension: "xml") else { return nil }
        do {
            let data = try Data(contentsOf: xmlPath)
            let tree = try XMLDecoder().decode(BKRoot.self, from: data)
            return tree.node
        } catch {
            print("[x] [SpellCheckable: \(name)]: \(error.localizedDescription)")
            return nil
        }
    }
    
    func corrections(word: String, completion: @escaping ((_ corrections: [String]) -> Void)){
        var matches: [String] = []
        guard let root = root else {
            DispatchQueue.main.async {
                completion(matches)
            }
            return
        }
        var stack: [BKNode] = [root]
        let N = 2  // threshold
        
        DispatchQueue.global(qos: .background).async {
            while !stack.isEmpty {
                guard let currentNode = stack.popLast() else {
                    DispatchQueue.main.async {
                        completion(matches)
                    }
                    return
                }
                if currentNode.word.distance(to: word) > N {
                    if let children = currentNode.children?.nodes, children.count > 0 {
                        children.forEach({
                            if currentNode.word.distance(to: word) - N <= $0.weightInt && $0.weightInt <= currentNode.word.distance(to: word) + N {
                                stack.append($0)
                            }
                        })
                    }
                }else {
                    matches.append(currentNode.word)
                }
            }
            
            DispatchQueue.main.async {
                completion(matches)
            }
        }
    }
}
