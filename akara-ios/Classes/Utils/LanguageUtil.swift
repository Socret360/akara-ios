//
//  LanguageUtils.swift
//  akara-ios
//
//  Created by Socret Lee on 7/10/22.
//

import Foundation

class LanguageUtil {
    static let EN_ALPHABET_LOWER = "abcdefghijklmnopqrstuvwxyz"
    static let EN_ALPHABET_UPPER = EN_ALPHABET_LOWER.uppercased()
    static let EN_ALPHABET = EN_ALPHABET_LOWER + EN_ALPHABET_UPPER
    static let KH_SEPARATOR = "\u{200b}\u{200c}?"
    static let KH_CONSTS = "កខគឃងចឆជឈញដឋឌឍណតថទធនបផពភមយរលវឝឞសហឡអឣឤឥឦឧឨឩឪឫឬឭឮឯឰឱឲឳ"
    static let KH_VOWELS = "឴឵ាិីឹឺុូួើឿៀេែៃោៅ\u{17c6}\u{17c7}\u{17c8}"
    static let KH_SUB = "្៎់័៍៌៉៊៏"
    static let KH_DIAC = "\u{17c9}\u{17ca}\u{17cb}\u{17cc}\u{17cd}\u{17ce}\u{17cf}\u{17d0}"
    static let KH_SYMS = "៕។៛ៗ៚៙៘,.?!@#%^&*()_+-=[]/\\<>"
    static let KH_NUMBERS = "០១២៣៤៥៦៧៨៩"
    static let EN_NUMBERS = "0123456789"
    static let NUMBERS = KH_NUMBERS + EN_NUMBERS
}
