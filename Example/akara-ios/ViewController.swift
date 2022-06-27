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
        spellChecking()
    }
    
    private func spellChecking() {
        let akara = Akara(akaraLanguage: .khmer)
        do {
            try akara.getWordCorrections(word: "ខ្មែរ") { corrections in
                print("[!] suggestions: \(corrections)")
            }
        }catch {
            if let error = error as? AkaraError {
                print("[x] \(error.localizedDescription)")
            }
        }
    }
}

