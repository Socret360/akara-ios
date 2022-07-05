//
//  UnicharExt.swift
//  akara-ios
//
//  Created by Vaifat Huy on 6/28/22.
//

import Foundation

extension unichar {
    /// Returns `String` value of the `unichar` by converting it to `UnicodeScarlar` and finally to `String`
    ///
    /// If there is failure on the `UnicodeScalar` conversion operation from the `unichar`, this property will return an empty string. Otherwise, it continues converting the retrieved `UnicodeScalar` to `String`
    var uniCharString: String {
        guard let unicodeScalar = UnicodeScalar(self) else { return "" }
        return String(unicodeScalar)
    }
}
