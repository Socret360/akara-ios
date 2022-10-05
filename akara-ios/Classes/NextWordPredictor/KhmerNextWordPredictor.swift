//
//  KhmerNextWordPredictor.swift
//  akara-ios
//
//  Created by Socret Lee on 7/12/22.
//

import Foundation
import TensorFlowLite

class KhmerNextWordPredictor: NextWordPredictable {
    private var SEQUENCE_LENGTH = 40
    private var N_UNIQUE_CHARS = 105
    private var PADDING_CHAR = "%"
    private var charToIndex : [String: Int] = [:]
    private var indexToChar : [Int: String] = [:]
    var model: Interpreter?
    
    public init() {
        self.model = loadModel()
        prepareCharMap()
    }
    
    func predict(_ input: String) -> [String] {
        do {
            var results: [String] = []
            let initialCharacters = try getNextChar(input: input)
            
            for predictedChar in initialCharacters {
                var tempInput: String = input + predictedChar
                var nextChar = try getNextChar(input: tempInput)[0]
                while (nextChar != PADDING_CHAR + "") {
                    tempInput += nextChar
                    nextChar = try getNextChar(input: tempInput)[0]
                }
                let chunks = tempInput.components(separatedBy: CharacterSet(charactersIn: " \(PADDING_CHAR)"))
                results.append(chunks.last!)
           }

           return results
        } catch {
            return []
        }
    }
    
    func close() {
        if model != nil {
            model = nil
        }
    }
    
    private func prepareCharMap() {
        guard let fileURL = AkaraBundle.main.url(forResource: "khmer_nextword_pred_char_map", withExtension: "txt") else {
            assertionFailure("[x] [prepareCharMap]: khmer_nextword_pred_char_map cannot be found in the bundle")
            return
        }
        
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let contentComponents = content.components(separatedBy: .newlines)
            contentComponents.forEach { content in
                guard !content.isEmpty else { return }
                let splittedContent = content.split(separator: "\t").map({ String($0) })
                guard splittedContent.count > 1, let index = Int(splittedContent[1]) else { return }
                let character = splittedContent[0]
                charToIndex[character] = index
                indexToChar[index] = character
            }
        } catch {
            print("[x] [prepareCharMap]: \(error.localizedDescription)")
        }
    }
    
    func loadModel() -> Interpreter? {
        guard let tfURL = AkaraBundle.main.url(forResource: "khmer_nextword_pred_model", withExtension: "tflite") else { return nil }
        do {
            let interpreter = try Interpreter(modelPath: tfURL.path)
            return interpreter
        } catch {
            return nil
        }
    }
    
    private func getNextChar(input: String, nChars: Int = 3) throws -> [String] {
        var inputText = String(input.unicodeScalars.suffix(SEQUENCE_LENGTH))
        inputText = inputText.unicodeScalars.padLeft(repeating: PADDING_CHAR, inLength: SEQUENCE_LENGTH)
        let inputVector: [Float32] = convertInput(inputText)
              
        let data = Data(bytes: inputVector, count: inputVector.count * MemoryLayout<Float>.stride)
        try model!.copy(data, toInputAt: 0)
        try model!.invoke()
        let outputTensor = try model!.output(at: 0)
        let probabilities =
                UnsafeMutableBufferPointer<Float32>.allocate(capacity: N_UNIQUE_CHARS * SEQUENCE_LENGTH)
        _ = outputTensor.data.copyBytes(to: probabilities)
        let results = Array(probabilities)
        let sortedIndexes: [Int] = argsort(a: results)
        
        var output: [String] = []
        
        for i in 0..<nChars {
            let predIdx = sortedIndexes[i]
            let char: String = indexToChar[predIdx]!
            output.append(char)
        }
        
        return output
    }
        
    func argsort<T:Comparable>( a : [T] ) -> [Int] {
        var r = Array(a.indices)
        r.sort(by: { a[$0] > a[$1] })
        return r
    }
    
    private func convertInput(_ text: String) -> [Float32] {
        var inputVector: [Float32] = [Float32](repeating: 0, count: SEQUENCE_LENGTH * N_UNIQUE_CHARS)
        var sequenceIdx = 0
        for char in text.unicodeScalars {
            let charIdx = Int(charToIndex[String(char)] ?? 0)
            inputVector[(sequenceIdx * N_UNIQUE_CHARS) + charIdx] = 1
            sequenceIdx+=1
        }
        
        return inputVector
    }
}

