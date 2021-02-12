//
//  ApiRequest.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 11/2/21.
//

import Foundation

protocol ApiRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension ApiRequest {
    
    // Returns ts, hashHex
    func generateTimeAndHash() -> (Int64, String) {
        let ts =  Int64(NSDate().timeIntervalSince1970)
        let md5 = String.init(format: "\(ts)%@%@", Constants.apiKeyPri, Constants.apiKeyPub)
        let hashData = Utils.MD5(string: md5)
        let hashHex =  hashData.map { String(format: "%02hhx", $0) }.joined()
        return (ts, hashHex)
    }
    
    // Returns URLRequest for WebService call
    func request(with baseURL: String) -> URLRequest {
        
        let (ts, hashHex) = generateTimeAndHash()
        let finalPath = String.init(format: "%@%@?ts=\(ts)&apikey=%@&hash=\(hashHex)", baseURL, path
                                           ,Constants.apiKeyPub)

        guard let url = URL(string: finalPath), var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        print("Web Service URL: \(url)")
        
        if(!parameters.isEmpty){
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 15
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
