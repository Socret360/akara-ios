//
//  WordBreakable.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/27/22.
//
import TensorFlowLite

protocol WordBreakable {
    /// Checker's name/identifier
    var name: String { get }
    
    /// Interpreter from Tensorflow ' s model
    var model: Interpreter? { set get }
    
    /// The name of the xml model; Specifying the `modelName` correctly to ensure `loadModel` will be able to load properly.
    var modelName: String { get }
    
    /// Splits words from a sentence
    func split(sentence: String) -> [String]
    
    /// Returns an Interpreter by loading Tensorflow's model file from specified `modelName`
    func loadModel() throws -> Interpreter?
    
    /// Clear retrieved content of the model
    mutating func close()
}

extension WordBreakable {
    
    func loadModel() throws -> Interpreter? {
        guard !modelName.isEmpty else {
            throw AkaraError.generic("modelName '\(name)'cannot be empty")
        }
        guard let tfURL = AkaraBundle.main.url(forResource: modelName, withExtension: "tflite") else {
            throw AkaraError.unknownResource(modelName)
        }
        do {
            let interpreter = try Interpreter(modelPath: tfURL.path)
            return interpreter
        } catch {
            throw AkaraError.loadModelFailure(error.localizedDescription)
        }
    }
}
