//
//  AutoCompletionable.swift
//  akara-ios
//
//  Created by Socret Lee on 7/10/22.
//

import Foundation

protocol AutoCompletionable {
    func isCorrect(_ word: String) -> Bool
    func predict(_ text: String) -> [String]
    func close()
}
