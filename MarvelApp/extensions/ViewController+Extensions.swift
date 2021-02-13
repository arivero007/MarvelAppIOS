//
//  ViewController.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 10/2/21.
//

import UIKit
import JGProgressHUD

extension UIViewController{
    
    open func showAlert(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    open func showProgressHud() -> JGProgressHUD{
        var hud = JGProgressHUD()
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = Utils.translateText(text: "GEN_CHARGING")
        hud.show(in: self.view)
        return hud
    }

}
