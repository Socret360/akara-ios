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

