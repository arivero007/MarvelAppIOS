//
//  Error+Extension.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 13/2/21.
//

import Foundation
import UIKit

extension ApiError{
    
    func localizedError() -> String{
        switch errorType {
        case .badRequest:
            return "error-bad-request".localized()
        case .unauthorized:
            return "error-unauthorized".localized()
        case .notFound:
            return "error-not-found".localized()
        case .unknown:
            return "error-unknown-error".localized()
        }
    }
}
