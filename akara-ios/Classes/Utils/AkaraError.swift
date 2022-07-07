//
//  AkaraError.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import Foundation

public enum AkaraError: Error {
    case emptyTargetString
    case unknownLanguage
    case generic(String)
    
    public var localizedDescription: String {
        let base = "[x] \(String(describing: Self.self)):"
        switch self {
        case .emptyTargetString:
            return "\(base) Target string cannot be empty"
        case .generic(let description):
            return "\(base) \(description)"
        case .unknownLanguage:
            return "\(base) No language was identified"
        }
    }
}
