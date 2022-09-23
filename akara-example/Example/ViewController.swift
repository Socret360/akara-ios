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
//            var sentence = "ឯងនេះមួយយប់ៗដេកខ្វល់រឿងអនាគតមិនដឹងធ្វើអីចិញ្ចឹមខ្លួនមួយនេះរស់"
            let sentence = "សើច លេង មែន"
            akara.suggest(sentence: sentence) { (suggestionType, suggestions, wordOfInterest) -> Void in
                DispatchQueue.main.async {
                    print("input: \(sentence)")
                    print("wordOfInterest: \(wordOfInterest?.toString())")
                    print("suggestions: \(suggestions.prefix(3))")
                    print("suggestionType: \(suggestionType)")
                    
                    for w in suggestions {
                        print("if \(w) is chosen: ")
                        var s = String(sentence).unicodeScalars
                        if (suggestionType != .nextWord) {
                            var i = String(s[...s.index(s.startIndex, offsetBy: wordOfInterest!.start-1)])
                            print("-- \(i)\(w)")
                        } else {
                            print("-- \(s)\(w)")
                        }
                    }
                    print("======")
                }
            }
        }
    }
}

