//
//  CharacterViewController.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 28/11/20.
//

import UIKit
import RxSwift
import JGProgressHUD

final class CharacterInfoViewController: UIViewController {
    
    var characterId: Int64?
    
    lazy private var characterVM: CharacterInfoViewModel = {
        return CharacterInfoViewModel()
    }()
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCharacter: UIImageView!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblModified: UILabel!
    
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setBindings()
        getCharactersData()
        
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}

extension CharacterInfoViewController {
    
    private func setBindings(){
        characterVM.bindCharacterViewModelToController = {
            self.fillCharacterData()
        }
    }
    
    private func getCharactersData(){
        if(NetworkConnection.isConnected()){
            characterVM.getCharacterInfo(view: self, id: characterId ?? 0)
        }else{
            showAlert(title: Utils.translateText(text: "GEN_ADVISE"), message: Utils.translateText(text: "NO_INTERNET"))
        }
    }
    
    private func fillCharacterData(){
        guard let character = characterVM.character else {return}
        lblName.text = character.name
        let imgPath = String.init(format: "%@.%@", character.thumbnail?.path ?? "", character.thumbnail?.type ?? "")
        if(imgPath != "."){
            imgCharacter.load(url: URL.init(string: imgPath)!)
        }
        lblDescription.text = character.description
        lblModified.text = character.modified
        
    }
    
    //MARK: - Literals
    private func setLiterals(){
        self.navigationItem.title = characterVM.character?.name ?? "character".localized()
    }
}
