//
//  NetworkConnection.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 28/11/20.
//

import Foundation
import Alamofire

class NetworkConnection {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
