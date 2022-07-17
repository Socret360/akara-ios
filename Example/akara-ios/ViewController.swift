//
//  ViewController.swift
//  akara-ios
//
//  Created by vaifathuy on 06/22/2022.
//  Copyright (c) 2022 vaifathuy. All rights reserved.
//

import UIKit
import AkaraIOS

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let akara = Akara()
//        let input = "this is my holid"
//        let input = "ឯងនេះមួយយប់ៗដេកខ្វល់រឿងអនាគតមិនដឹងធ្វើអីចិញ្ចឹមខ្លួនមួយនេះរស់"
        
        DispatchQueue.global(qos: .background).async { [self] in
//            let sentence = "ឯងនេះមួយយប់ៗដេកខ្វល់រឿងអនាគតមិនដឹងធ្វើអីចិញ្ចឹមខ្លួនមួយនេះរស់"
            let sentence = "ឯងនេះមួយយប់ៗដេកខ្វល់រឿងអនាគតមិនដឹងធ្វើអីចិញ្ចឹមខ្លួនមួយនេះរស់"
            var string = sentence.map {(c) -> String in
                return String(c)
            }
            var input = ""
            var isProcessing = false
            while (!string.isEmpty) {
                if (!isProcessing) {
                    isProcessing = true
                    input += string.removeFirst()
                    akara.suggest(sentence: input) { (suggestionType, suggestions, sequences, words) -> Void in
                        print("input: \(input)")
                        print("sequences: \(sequences)")
                        print("words: \(words)")
                        print("suggestions: \(suggestions.suffix(3))")
                        print("suggestion_type: \(suggestionType)")
                        print("======")
                        isProcessing = false
                    }
                }
            }
        }
    }
}

