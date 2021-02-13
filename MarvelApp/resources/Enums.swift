//
//  Enums.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 13/2/21.
//

import Foundation

enum RequestType: String {
    case GET, POST
}

enum ResponseStatusCode: Int{
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
}

enum ErrorTypes: Error {
    case badRequest
    case unauthorized
    case notFound
    case unknown
}
