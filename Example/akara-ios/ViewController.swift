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
        
        DispatchQueue.global(qos: .background).async {
            do {
                let corrections = try akara
                    .getWordCorrections(word: .init(text: "complition", language: .english))
                    .map { "\($0.language) : \($0.text)" }
                
                DispatchQueue.main.async {
                    corrections.forEach {
                        print($0)
                    }
                }
                
            } catch {
                print("[x] \(error.localizedDescription)")
            }
        }
    }
}

