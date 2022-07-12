//
//  NextWordPredictable.swift
//  akara-ios
//
//  Created by Socret Lee on 7/12/22.
//

import Foundation

protocol NextWordPredictable {
    func predict(_ input: String) -> [String]
    func close()
}
