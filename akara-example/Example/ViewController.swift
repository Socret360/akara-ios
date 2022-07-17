//
//  ViewController.swift
//  Example
//
//  Created by Vaifat Huy on 7/17/22.
//

import UIKit
import AkaraIOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let akara = Akara()
        DispatchQueue.global(qos: .background).async {
            let sentence = "ឯងនេះមួយយប់ៗដេកខ្វល់រឿងអនាគតមិនដឹងធ្វើអីចិញ្ចឹមខ្លួនមួយនេះរស់"
            akara.suggest(sentence: sentence) { (suggestionType, suggestions, sequences, words) -> Void in
                DispatchQueue.main.async {
                    print("input: \(sentence)")
                    print("sequences: \(sequences)")
                    print("words: \(words)")
                    print("suggestions: \(suggestions.suffix(3))")
                    print("suggestionType: \(suggestionType)")
                    print("======")
                }
            }
        }
    }


}

