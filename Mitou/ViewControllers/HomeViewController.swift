//
//  HomeViewController.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var viewProposeChallenge: UIView!
    @IBOutlet weak var challengeView: UIView!
    @IBOutlet weak var noChallengeView: UIView!
    @IBOutlet weak var challengeText: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var failButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let proposeChallengeGesture = UITapGestureRecognizer(target: self, action:  #selector (self.proposeChallenge(sender:)))
        self.viewProposeChallenge.addGestureRecognizer(proposeChallengeGesture)
        print("LOAD-----------------------------")
        
        doneButton.layer.cornerRadius = 20
        failButton.layer.cornerRadius = 20
        challengeView.layer.cornerRadius = 10
        noChallengeView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("APPEAR---------------------------")
    }
    
    @IBAction func challengeDone(_ sender: Any) {
        switchChallengeView()
        
        GameController.sharedInstance.createGamer()
    }
    
    @IBAction func challengeFailed(_ sender: Any) {
        switchChallengeView()
    }
    
    func switchChallengeView() {
        challengeView.isHidden = !challengeView.isHidden
        noChallengeView.isHidden = !noChallengeView.isHidden
    }
    
    @objc func proposeChallenge(sender : UITapGestureRecognizer) {
        performSegue(withIdentifier: "ProposeChallenge", sender: self)
    }
}
