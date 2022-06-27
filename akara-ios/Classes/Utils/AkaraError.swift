//
//  AkaraError.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import Foundation

public enum AkaraError: Error {
    case emptyTargetString
    
    public var localizedDescription: String {
        switch self {
        case .emptyTargetString:
            return "Target string cannot be empty"
        }
    }
}
