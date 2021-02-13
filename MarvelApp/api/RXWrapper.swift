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
                
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else {return}
                
                print("WebService status code: \(response.statusCode)")
                switch ResponseStatusCode(rawValue: response.statusCode) {
                case .ok:
                    do {
                        let model: T = try JSONDecoder().decode(T.self, from: data )
                        observer.onNext(model)
                    } catch let error {
                        observer.onError(error)
                    }
                case .badRequest:
                    observer.onError(ApiError(error: .badRequest))
                case .unauthorized:
                    observer.onError(ApiError(error: .unauthorized))
                case .notFound:
                    observer.onError(ApiError(error: .notFound))
                case .none:
                    observer.onError(ApiError(error: .unknown))
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
