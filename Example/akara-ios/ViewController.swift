//
//  ViewController.swift
//  akara-ios
//
//  Created by vaifathuy on 06/22/2022.
//  Copyright (c) 2022 vaifathuy. All rights reserved.
//

import UIKit
import akara_ios

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let akara = Akara(akaraLanguage: .khmer)
        
//        akara.getSequences(sentence: "ខ្ញុំគឺ ជាខ្មែរ") { sequences in
//            sequences.enumerated().forEach {
//                print("[] index: \($0), text: \($1.text), language: \($1.language.rawValue)")
//            }
//        }
    }
}

