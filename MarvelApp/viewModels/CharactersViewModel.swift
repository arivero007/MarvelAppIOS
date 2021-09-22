//
//  CharactersViewModel.swift
//  MarvelApp
//
//  Created by AlexR on 21/9/21.
//

import Foundation
import RxSwift

class CharactersViewModel: NSObject {
    
    private(set) var filteredCharacters : [Character] = [] {
        didSet {
            self.bindCharactersViewModelToController()
        }
    }
    
    private(set) var characters : [Character]! {
        didSet {
            self.bindCharactersViewModelToController()
        }
    }
    
    private var disposeBag: DisposeBag!
    var bindCharactersViewModelToController : (() -> ()) = {}
        
    override init() {
        super.init()
        disposeBag = DisposeBag()
    }
    
    //MARK: - WebService
    func getCharacters(view: UIViewController){
        
        let characters: Observable<MarvelData> = RXWrapper.shared.request(apiRequest: CharactersRequest())
        
        characters
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { marvelData in
                print("[Api] Response -> \(marvelData)")
                self.characters = marvelData.data.results
                self.filteredCharacters = marvelData.data.results
            } onError: { error in
                guard let error = error as? ApiError else{
                    return
                }
                view.showAlert(title: "error-ws".localized(), message: error.localizedError())
            } onCompleted: {
                
            }.disposed(by: disposeBag)
    }
    
    func applyTextFilter(text: String){
        if text == ""{
            filteredCharacters = characters
        }else{
            filteredCharacters = []
            for item in characters{
                if item.name.contains(text){
                    filteredCharacters.append(item)
                }
            }
        }
    }
}
