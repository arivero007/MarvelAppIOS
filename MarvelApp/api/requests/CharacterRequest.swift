//
//  CharacterRequest.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 11/2/21.
//

import Foundation

class CharacterRequest: ApiRequest {
    
    var method = RequestType.GET
    var path = Constants.marvelCharacter
    var parameters = [String: String]()

    init() {}
}
