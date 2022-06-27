//
//  BKTree.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/23/22.
//

import XMLCoder

public struct BKRoot: Codable, DynamicNodeEncoding {
    let node: BKNode
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .element
    }
}

public struct BKNode: Codable, DynamicNodeEncoding {
    public let word: String
    public let weight: String
    public let children: BKChildren?
    
    public var weightInt: Int {
        return Int(weight) ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case word
        case weight
        case children
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case BKNode.CodingKeys.children:
            return .element
        default:
            return .attribute
        }
    }
}

public struct BKChildren: Codable, DynamicNodeEncoding {
    public  let nodes: [BKNode]?
    
    enum CodingKeys: String, CodingKey {
        case nodes = "node"
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .element
    }
}

