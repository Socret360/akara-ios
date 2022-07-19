//
//  KhmerWordBreaker.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/27/22.
//

import TensorFlowLite

final class KhmerWordBreaker: WordBreakable {
    private let N_UNIQUE_CHARS: Int = 133
    private let N_UNIQUE_POS: Int = 16
    private let MAX_SENTENCE_LENGTH: Int = 687
    
    private var charToIndex : [String: Int] = [:]
    private var indexToChar : [Int: String] = [:]
    private var posToIndex : [String: Int] = [:]
    private var indexToPos : [Int: String] = [:]
    
    // MARK: - Protocol's stubs
    var name: String { return String(describing: self) }
    
    var model: Interpreter?
    
    var modelName: String {
        // .tflite
        return "khmer_word_seg_model"
    }
    
    func close() {
        if model != nil {
            model = nil
        }
    }
    
    func split(sentence: String) -> [String] {
        var wordBreaks: [String] = []
        
        let results = runModel(input: sentence)
        
        var tmp: String = ""
        for (charIdx, char) in sentence.unicodeScalars.enumerated() {
            let startingPos = (charIdx * N_UNIQUE_POS)
            let posVector = results[startingPos...startingPos + N_UNIQUE_POS - 1]
            let posIndex = posVector.firstIndex(of: posVector.max()!)! - startingPos

            if indexToPos[posIndex] == "NS" {
                tmp.append(String(char))
            } else {
                if tmp.unicodeScalars.count > 0 {
                    wordBreaks.append(tmp)
                    tmp = ""
                }
                tmp.append(String(char))
            }
        }
        
        if tmp.unicodeScalars.count > 0 {
            wordBreaks.append(tmp)
        }
        return wordBreaks
    }
    
    // MARK: - Init
    public init() {
        do {
            self.model = try loadModel()
            try prepareCharMap()
            try preparePosMap()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Helper methods
    private func prepareCharMap() throws {
        guard let fileURL = AkaraBundle.main.url(forResource: "khmer_word_seg_char_map", withExtension: "txt") else {
            throw AkaraError.unknownResource("khmer_word_seg_char_map.txt")
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
            charToIndex["UNK"] = N_UNIQUE_CHARS - 1
            indexToChar[N_UNIQUE_CHARS - 1] = "UNK"
        } catch {
            throw AkaraError.generic(error.localizedDescription)
        }
    }
    
    private func preparePosMap() throws {
        guard let fileURL = AkaraBundle.main.url(forResource: "khmer_word_seg_pos_map", withExtension: "txt") else {
            throw AkaraError.unknownResource("khmer_word_seg_pos_map.txt")
        }
        
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let contentComponents = content.components(separatedBy: .newlines)
            contentComponents.enumerated().forEach { index, content in
                guard !content.isEmpty else { return }
                posToIndex[content] = index
                indexToPos[index] = content
            }
        } catch {
            throw AkaraError.generic(error.localizedDescription)
        }
    }
    
    private func runModel(input: String) -> [Float32] {
        do {
            guard let interpreter = model else { return [] }
            
            // Allocate memory for the model's input `Tensor`s.
            try interpreter.allocateTensors()
            
            // Prepare input data
            let input = NSString(string: input)
            var inputVector: [Float32] = [Float32](repeating: 0, count: MAX_SENTENCE_LENGTH * N_UNIQUE_CHARS)
            
            (0..<input.length).forEach { sequenceIndex in
                let character = input.character(at: sequenceIndex).uniCharString
                let characterIndex = (charToIndex[character] ?? charToIndex["UNK"]) ?? 0
                inputVector[(sequenceIndex * N_UNIQUE_CHARS) + characterIndex] = 1.0
            }
                        
            let inputData = Data(bytes: inputVector, count: inputVector.count * MemoryLayout<Float32>.stride)
            
            // Copy the input data to the input `Tensor`.
            try interpreter.copy(inputData, toInputAt: 0)
            
            // Run inference by invoking the `Interpreter`.
            try interpreter.invoke()
            
            // Get the output `Tensor`
            let outputTensor = try interpreter.output(at: 0)
            
            let outputSize = outputTensor.shape.dimensions.reduce(1, {x, y in x * y})
            
            let outputData = UnsafeMutableBufferPointer<Float32>.allocate(capacity: outputSize)
            
            _ = outputTensor.data.copyBytes(to: outputData)
            
            let results = Array(outputData)
            return results
        } catch {
            return []
        }
    }
}
