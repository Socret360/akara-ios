//
//  StringExt.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/23/22.
//

import Foundation

extension String {
    /// Calculates differences between two words based on Lavensthein Distance Theory
    ///
    /// References:  https://en.wikipedia.org/wiki/Levenshtein_distance
    ///  - Parameters:
    ///     - word: the string to calculate against the current one
    func distance(to word: String) -> Int {
        let word1 = NSString(string: self)
        let word2 = NSString(string: word)
        
        let columnCount: Int = word1.length + 1
        let rowCount: Int = word2.length + 1
        
        let columnRange = 0..<columnCount
        let rowRange = 0..<rowCount
        
        var matrix: [[Int]] = columnRange.map { _ in return rowRange.map { _ in return -1 } }
        
        // Set up default footprint for the matrix
        columnRange.forEach({ matrix[$0][0] = $0 })
        rowRange.forEach({ matrix[0][$0] = $0 })
        
        (1..<columnCount).forEach { columnIndex in
            (1..<rowCount).forEach { rowIndex in
                let leftItem = matrix[columnIndex - 1][rowIndex]
                let topItem = matrix[columnIndex][rowIndex - 1]
                let topLeftItem = matrix[columnIndex - 1][rowIndex - 1]
                let min = Swift.min(leftItem, topItem, topLeftItem)
                
                print("leftItem: \(leftItem), topItem: \(topItem), topLeftItem: \(topLeftItem), min: \(min)")
                
                if word1.character(at: columnIndex - 1).uniCharString != word2.character(at: rowIndex - 1).uniCharString {
                    matrix[columnIndex][rowIndex] = min + 1
                }else {
                    matrix[columnIndex][rowIndex] = topLeftItem
                }
                
//                print("columnIndex: \(columnIndex):\(columnElement)")
            }
        }
        
        print("[] columnCount: \(columnCount)")
        print("[] rowCount: \(rowCount)")
        print("[] matrix:\n\n \(matrix)")
        
        return matrix[columnCount - 1][rowCount - 1]
    }
}
