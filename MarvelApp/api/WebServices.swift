//
//  WebServices.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 28/11/20.
//

import Foundation
import RxSwift

class WebServices{
    
    static func getAllCharacters() -> Observable<MarvelData>{
        
        let ts =  Int64(NSDate().timeIntervalSince1970)
        let md5 = String.init(format: "\(ts)%@%@", Constants.apiKeyPri, Constants.apiKeyPub)
        let hashData = Utils.MD5(string: md5)
        let hashHex =  hashData.map { String(format: "%02hhx", $0) }.joined()
        
        return Observable.create { observer in
            
            let session = URLSession.shared
            let urlString = String.init(format: "%@public/characters?ts=\(ts)&apikey=%@&hash=\(hashHex)", Constants.marvelUrl, Constants.apiKeyPub)
                
            var request = URLRequest.init(url: URL(string: urlString )!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
            
            request.httpMethod = "GET"
            
            session.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else {return}
                                                
                if(response.statusCode == 200){
                    do {
                        let decoder = JSONDecoder()
                        let marvelData = try decoder.decode(MarvelData.self, from: data)
                        observer.onNext(marvelData)
                    } catch let error {
                        observer.onError(error)
                        print("Error decodificación: \(error.localizedDescription)")
                    }
                }else if (response.statusCode == 401){
                    observer.onError(NSError(domain:"", code:response.statusCode, userInfo:nil))
                    print("Error 401: Invalid credentials")
                }else{
                    print("Web Service Code -> \(response.statusCode)")
                }
                
                observer.onCompleted()
                
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
            
        }
    }
    
    static func getCharacter(id: Int64) -> Observable<Character?>{
        
        let ts =  Int64(NSDate().timeIntervalSince1970)
        let md5 = String.init(format: "\(ts)%@%@", Constants.apiKeyPri, Constants.apiKeyPub)
        let hashData = Utils.MD5(string: md5)
        let hashHex =  hashData.map { String(format: "%02hhx", $0) }.joined()
        
        return Observable.create { observer in
            
            let session = URLSession.shared
            let urlString = String.init(format: "%@public/characters/\(id)?ts=\(ts)&apikey=%@&hash=\(hashHex)", Constants.marvelUrl, Constants.apiKeyPub)
                
            var request = URLRequest.init(url: URL(string: urlString )!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
            
            request.httpMethod = "GET"
            
            session.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else {return}
                                                
                if(response.statusCode == 200){
                    do {
                        let decoder = JSONDecoder()
                        let marvelData = try decoder.decode(MarvelData.self, from: data)
                        if(marvelData.data.results.count > 0){
                            let character = marvelData.data.results.first
                            observer.onNext(character)
                        }else{
                            observer.onNext(nil)
                        }
                    } catch let error {
                        observer.onError(error)
                        print("Error decodificación: \(error.localizedDescription)")
                    }
                }else if (response.statusCode == 401){
                    observer.onError(NSError(domain:"", code:response.statusCode, userInfo:nil))
                    print("Error 401: Invalid credentials")
                }else{
                    print("Web Service Code -> \(response.statusCode)")
                }
                
                observer.onCompleted()
                
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
            
        }
        
    }

}

