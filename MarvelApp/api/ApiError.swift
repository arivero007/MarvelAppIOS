//
//  ApiError.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 13/2/21.
//

import Foundation

class ApiError: LocalizedError{
    
    var errorType: ErrorTypes
    
    init(error: ErrorTypes) {
        errorType = error
    }
}
