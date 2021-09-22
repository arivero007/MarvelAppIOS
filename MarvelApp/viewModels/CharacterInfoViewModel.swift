//
//  CharacterInfoViewModel.swift
//  MarvelApp
//
//  Created by AlexR on 21/9/21.
//

import Foundation
import RxSwift

class CharacterInfoViewModel: NSObject {
    
    private(set) var character: Character? {
        didSet{
            self.bindCharacterViewModelToController()
        }
    }
    
    var bindCharacterViewModelToController : (() -> ()) = {}

    private var disposeBag : DisposeBag!
    
    override init() {
        disposeBag = DisposeBag()
    }
    
    func getCharacterInfo(view: UIViewController, id: Int64){
        let request = CharacterRequest()
        request.path = "\(request.path)/\(id)"
        
        let character: Observable<MarvelData> = RXWrapper.shared.request(apiRequest: request)
                
        character
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { characters in
                print("[Api] Response -> \(String(describing: characters.data.results.first))")
                self.character = characters.data.results.first
            } onError: { error in
                view.showAlert(title: "WS_ERROR".localized(), message: error.localizedDescription)
            } onCompleted: {
            }.disposed(by: disposeBag)
    }
    
}
