//
//  AkaraLanguage.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/26/22.
//

import Foundation

public enum AkaraLanguage: String, Equatable {
    case english = "en"
    case khmer = "km"
    case other = "other"
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
