//
//  AkaraBundle.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/24/22.
//

import Foundation

final class AkaraBundle: Bundle {
    override class var main: Bundle {
        let podBundle = Bundle(for: self)
        guard let resourceBundleURL = podBundle.url(forResource: "akara-ios", withExtension: "bundle") else {
            fatalError("akara-ios.bundle is not found!")
        }
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Cannot access akara-ios.bundle!")
        }
        return resourceBundle
    }
}
