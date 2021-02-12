//
//  ApiCharacter.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 11/2/21.
//

import Foundation

struct Character: Codable {
    let id: Int64
    let name: String
    let thumbnail: Thumbnail?
    let description: String?
    let modified: String?
}

struct Thumbnail: Codable {
    let path: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case type = "extension"
    }
}
