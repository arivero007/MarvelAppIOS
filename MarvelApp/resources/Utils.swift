//
//  Utils.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 28/11/20.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class Utils {
    
    //MARK: Global functions
    
    // Deprecated: Return localized translation
    static func translateText(text: String) -> String {
        
        let selectedLanguage = UserDefaults.standard.value(forKey: "AppLanguage")
        let path = Bundle.main.path(forResource: selectedLanguage as? String, ofType: "lproj")
        let bundle = Bundle(path: path!)
        guard let trad = bundle?.localizedString(forKey: text, value: "", table: nil) else { return "" }
        return trad
    }
    
    // Returns hash md5 generated data value
    static func MD5(string: String) -> Data {
            let length = Int(CC_MD5_DIGEST_LENGTH)
            let messageData = string.data(using:.utf8)!
            var digestData = Data(count: length)

            _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }
            return digestData
        }
}
