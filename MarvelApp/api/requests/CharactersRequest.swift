//
//  CharactersRequest.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 11/2/21.
//

import Foundation

class CharactersRequest: ApiRequest {
    
    var method = RequestType.GET
    var path = Constants.marvelAllCharacters
    var parameters = [String: String]()

    init() {}
}
