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
    case unknownResource(String)
    case loadModelFailure(String)
    case generic(String)
    
    public var localizedDescription: String {
        let base = "[x] \(String(describing: Self.self)):"
        var baseDescription = "\(base) "
        switch self {
        case .emptyTargetString:
            baseDescription += "Target string cannot be empty"
        case .loadModelFailure(let info):
            baseDescription += info
        case .generic(let description):
            baseDescription += description
        case .unknownLanguage:
            baseDescription += "No language was identified"
        case .unknownResource(let name):
            baseDescription += "Resource name '\(name) cannot be found in the bundle!"
        }
        return baseDescription
    }
}
