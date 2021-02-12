//
//  CharacterViewController.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 28/11/20.
//

import UIKit
import RxSwift
import JGProgressHUD

final class CharacterViewController: UIViewController {
    
    var characterId: Int64?
    private var character: Character?
    
    private var hud: JGProgressHUD?
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCharacter: UIImageView!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblModified: UILabel!
    
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getCharactersData()
        
    }
    
    //MARK: Class functions
    
    private func getCharactersData(){
        if(NetworkConnection.isConnected()){
            getCharacterWS()
        }else{
            showAlert(title: Utils.translateText(text: "GEN_ADVISE"), message: Utils.translateText(text: "NO_INTERNET"))
        }
    }
    
    private func fillCharacterData(){
        
        if(character != nil){
            lblName.text = character!.name
            let imgPath = String.init(format: "%@.%@", character?.thumbnail?.path ?? "", character?.thumbnail?.type ?? "")
            if(imgPath != "."){
                imgCharacter.load(url: URL.init(string: imgPath)!)
            }
            lblDescription.text = character?.description
            lblModified.text = character?.modified
        }
    }
    
    //MARK: WS
    
    private func getCharacterWS(){
        
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = Utils.translateText(text: "GEN_CHARGING")
        hud?.show(in: self.view)
                
        return WebServices.getCharacter(id: characterId ?? 0)
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { character in
                self.character = character
                self.fillCharacterData()
                self.hud?.dismiss()
            } onError: { error in
                self.hud?.dismiss()
                self.showAlert(title: Utils.translateText(text: "WS_ERROR"), message: nil)
            } onCompleted: {
                self.hud?.dismiss()
            }.disposed(by: disposeBag)
    }
    
    //MARK: VIEW
    
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
