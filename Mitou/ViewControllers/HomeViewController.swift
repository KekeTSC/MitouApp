//
//  HomeViewController.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class HomeViewController: UIViewController, Observer {
    
    
    @IBOutlet weak var viewProposeChallenge: UIView!
    @IBOutlet weak var challengeView: UIView!
    @IBOutlet weak var noChallengeView: UIView!
    @IBOutlet weak var challengeText: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var failButton: UIButton!
    
    let gameController = GameController.sharedInstance
    let authController = AuthController.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        gameController.observer = self
        changeChallenge()
        let proposeChallengeGesture = UITapGestureRecognizer(target: self, action:  #selector (self.proposeChallenge(sender:)))
        self.viewProposeChallenge.addGestureRecognizer(proposeChallengeGesture)
        print("LOAD-----------------------------")
        
        doneButton.layer.cornerRadius = 20
        failButton.layer.cornerRadius = 20
        challengeView.layer.cornerRadius = 10
        noChallengeView.layer.cornerRadius = 10
        viewProposeChallenge.layer.cornerRadius = 10
    }
    
    @IBAction func challengeDone(_ sender: Any) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Chargement..."
        hud.show(in: self.view)
        
        gameController.myGamerModel!.challengeDone.append(gameController.myGamerModel!.currentChallenge)
        gameController.myGamerModel!.currentChallenge = ""
        gameController.myGamerModel!.hasChallenge = false
        gameController.ref.child("Gamers").child(authController.myUID).setValue(["firstName": gameController.myGamerModel!.firstName,                                                                         "lastName": gameController.myGamerModel!.lastName, "myUID": gameController.myGamerModel!.myUID, "partnerUID": gameController.myGamerModel!.partnerUID, "currentChallenge": gameController.myGamerModel!.currentChallenge, "challengeDone": gameController.myGamerModel!.challengeDone, "challengeFailed": gameController.myGamerModel!.challengeFailed, "hasChallenge": gameController.myGamerModel!.hasChallenge]) {
                (error, ref) in
            if error == nil{
                UIView.animate(withDuration: 0.1, animations: {
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                hud.textLabel.text = "Bravo ! Vous avez réussis votre challenge"
                hud.dismiss(afterDelay: 1.0, animated: true)
                    self.switchChallengeView(haveChallenge: false)
            }
        }
    }
    
    @IBAction func challengeFailed(_ sender: Any) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Chargement..."
        hud.show(in: self.view)
        
        gameController.myGamerModel!.challengeFailed.append(gameController.myGamerModel!.currentChallenge)
        gameController.myGamerModel!.currentChallenge = ""
        gameController.myGamerModel!.hasChallenge = false
        gameController.ref.child("Gamers").child(authController.myUID).setValue(["firstName": gameController.myGamerModel!.firstName,                                                                         "lastName": gameController.myGamerModel!.lastName, "myUID": gameController.myGamerModel!.myUID, "partnerUID": gameController.myGamerModel!.partnerUID, "currentChallenge": gameController.myGamerModel!.currentChallenge, "challengeDone": gameController.myGamerModel!.challengeDone, "challengeFailed": gameController.myGamerModel!.challengeFailed, "hasChallenge": gameController.myGamerModel!.hasChallenge]) {
            (error, ref) in
            if error == nil{
                UIView.animate(withDuration: 0.1, animations: {
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                hud.textLabel.text = "Vous etes mauvais"
                hud.dismiss(afterDelay: 1.0, animated: true)
                self.switchChallengeView(haveChallenge: false)
            }
        }
    }
    
    func switchChallengeView(haveChallenge: Bool) {
        challengeView.isHidden = !haveChallenge
        noChallengeView.isHidden = haveChallenge
    }
    
    @objc func proposeChallenge(sender : UITapGestureRecognizer) {
        performSegue(withIdentifier: "ProposeChallenge", sender: self)
    }
    
    func updateModel() {
        changeChallenge()
    }
    
    func updateChallenges() {
        //Nothing
    }
    
    func changeChallenge() {
        if gameController.myGamerModel != nil {
            if gameController.myGamerModel!.hasChallenge {
                switchChallengeView(haveChallenge: true)
                let currentChallenge = gameController.getSingleChallenge(challenge: gameController.myGamerModel!.currentChallenge)
                if let currentChallenge = currentChallenge {
                    challengeText.text = currentChallenge.challenge
                } else {
                    switchChallengeView(haveChallenge: false)
                }
            } else {
                switchChallengeView(haveChallenge: false)
            }
        }
    }
}
