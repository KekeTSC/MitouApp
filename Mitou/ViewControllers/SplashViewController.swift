//
//  SplashViewController.swift
//  Mitou
//
//  Created by Kelian Daste on 11/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SplashViewController: UIViewController, Observer {
    
    var isAuth = false
    var gameController: GameController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameController?.observer = self

        _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(splashTimeOut), userInfo: nil, repeats: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthController.sharedInstance.isThereCurrentUser() {
            isAuth = true
            GameController.sharedInstance.loadGamerModel()
            GameController.sharedInstance.loadListOfChallenges()
        } else {
            isAuth = false
        }
    }
    
    @objc func splashTimeOut() {
        GameController.sharedInstance.isAnimationFinished = true
        passSplash()
    }
    
    func passSplash() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Chargement des données"
        if GameController.sharedInstance.isAnimationFinished
            && GameController.sharedInstance.isChallengesLoaded
            && GameController.sharedInstance.isGamerModelLoaded {
            if isAuth {
                hud.dismiss()
                self.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        } else if GameController.sharedInstance.isAnimationFinished {
            hud.show(in: self.view)
        }
    }
    
    func updateModel() {
        passSplash()
    }
    
    func updateChallenges() {
        passSplash()
    }
}
