//
//  RXWrapper.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 10/2/21.
//

import Foundation
import RxSwift
import RxCocoa

class RXWrapper {
    
    static let shared = RXWrapper()
    
    private init(){}
}

extension RXWrapper{
    
    func request<T: Codable>(apiRequest: ApiRequest) -> Observable<T>{
                
        return Observable<T>.create { observer in

            let request = apiRequest.request(with: Constants.marvelUrl)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
