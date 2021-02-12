//
//  ApiCharacters.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 11/2/21.
//

import Foundation

struct MarvelData: Codable {
    let data: DataResult
}

struct DataResult: Codable {
    var results: [Character]
}


