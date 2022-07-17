# AkaraIOS

[![CI Status](https://img.shields.io/travis/vaifathuy/akara-ios.svg?style=flat)](https://travis-ci.org/vaifathuy/akara-ios)
[![Version](https://img.shields.io/cocoapods/v/akara-ios.svg?style=flat)](https://cocoapods.org/pods/akara-ios)
[![License](https://img.shields.io/cocoapods/l/akara-ios.svg?style=flat)](https://cocoapods.org/pods/akara-ios)
[![Platform](https://img.shields.io/cocoapods/p/akara-ios.svg?style=flat)](https://cocoapods.org/pods/akara-ios)

The AKARA (អក្ខរា) project aims to give developers the power to easily add multi-language word suggestions support to their applications. 

AkaraIOS offers this exciting feature to iOS developers.

## Features
- [x] Word Suggestion

## Language Support
- [x] Khmer
- [x] English

## Road Maps

- [ ]  Next Word Suggestion for English
- [ ]  Personalize Suggestions based on NGram
- [ ]  Support for Other Languages. (Planing for Thai and Chinese)

## Requirements

- iOS 11.0+
- Xcode 10.0+
- Swift 4+

## Installation

### CocoaPods

AkaraIOS is available through [CocoaPods](https://cocoapods.org). To integrate
AkaraIOS into your project, simply add the following line to your Podfile:

```ruby
pod 'AkaraIOS'
```

## Usage

```swift
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
        
```

## Want to Help?

Code contributions are welcome for this project and other AKARA related projects.

| Project        | Status           | URL  |
| ------------- |:-------------:| -----:|
| akara-android      | Active | https://github.com/Socret360/akara-android |
| akara-ios      | Active      |   https://github.com/Socret360/akara-ios |
| akara-python | Active      | https://github.com/Socret360/akara-python |
| akara-web | TBC      ||
| akara-flutter | TBC      ||


## Credits

### Sequence Breaker:
- Using simple space splitting and [MLKit Language Identification](https://developers.google.com/ml-kit/language/identification) to determine sequence language.

### WordBreaker:
- Khmer: Deep Learning (LSTM) based on [Joint Khmer Word Segmentation and Part-of-Speech Tagging Using Deep Learning](https://arxiv.org/abs/2103.16801) from [https://github.com/Socret360/joint-khmer-word-segmentation-and-pos-tagging](https://github.com/Socret360/joint-khmer-word-segmentation-and-pos-tagging).
- English: Simple space spliting.

### Auto Completion
- Khmer: Prefix Tree (a.k.a Trie) with dictionaries from [https://github.com/sbbic/khmerlbdict](https://github.com/sbbic/khmerlbdict).
- English: Prefix Tree (a.k.a Trie) with dictionary from [https://github.com/dwyl/english-words](https://github.com/dwyl/english-words).

### Spell Checker / Corrections
- Khmer: BK Tree with dictionaries from [https://github.com/sbbic/khmerlbdict](https://github.com/sbbic/khmerlbdict).
- English: BK Tree with dictionaries from [https://github.com/derekchuank/high-frequency-vocabulary](https://github.com/derekchuank/high-frequency-vocabulary).

### Next Word Suggestions
- Khmer: Deep Learning (LSTM) trained by [@ssokhavirith](https://github.com/ssokhavirith?tab=repositories).
- English: N/A

## License

AkaraIOS is available under the MIT license. See the LICENSE file for more info.
