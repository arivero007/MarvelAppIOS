//
//  String+Extensions.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 12/2/21.
//

import Foundation
import UIKit

extension String{
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
