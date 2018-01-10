//
//  MainViewController.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {
    
    let authController = AuthController.sharedInstance

    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var container: UIView!
    
    //Home cell
    @IBOutlet weak var homeCellView: UIView!
    @IBOutlet weak var homeCellImage: UIImageView!
    
    //MyChallenge cell
    @IBOutlet weak var myChallengeCellView: UIView!
    @IBOutlet weak var myChallengeCellImage: UIImageView!
    
    //PartnerChallenge cell
    @IBOutlet weak var partnerChallengeCellView: UIView!
    @IBOutlet weak var partnerChallengeCellImage: UIImageView!
    
    //SexCounter cell
    @IBOutlet weak var sexCounterCellView: UIView!
    @IBOutlet weak var sexCounterCellImage: UIImageView!
    
    //ProposeActivity cell
    @IBOutlet weak var proposeActivityCellView: UIView!
    @IBOutlet weak var proposeActivityCellImage: UIImageView!
    
    //Deconnection cell
    @IBOutlet weak var deconnectionCellView: UIView!
    @IBOutlet weak var deconnectionCellImage: UIImageView!
    
    @IBOutlet weak var nameUserLabel: UIButton!
    
    
    
    let sideViewWidth: CGFloat = -240
    var isDrawerOpen = false
    
    lazy var homeViewController: HomeViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        return viewController
    }()
    
    lazy var myChallengeController: MyChallengesViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "MyChallengesViewController") as! MyChallengesViewController
        return viewController
    }()
    
    lazy var partnerChallengeController: PartnerChallengesViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "PartnerChallengesViewController") as! PartnerChallengesViewController
        return viewController
    }()
    
    lazy var sexCounterController: SexCounterViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "SexCounterViewController") as! SexCounterViewController
        return viewController
    }()
    
    lazy var proposeActivityController: ProposeActivityViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProposeActivityViewController") as! ProposeActivityViewController
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.authController.isThereCurrentUser() {
            //nameUserLabel.setTitle("\(authController.myUser!.email) Modifier le profil", for: .normal) 
        } else {
            print("bizarre")
        }
        //Put all views in array
        
        let listCellView: [UIView] =
            [homeCellView, myChallengeCellView
            , partnerChallengeCellView, sexCounterCellView
            ,proposeActivityCellView, deconnectionCellView]
        
        //Put all imageviews in array
        
        let listCellImages: [UIImageView] =
            [homeCellImage, myChallengeCellImage
            , partnerChallengeCellImage, sexCounterCellImage
            ,proposeActivityCellImage, deconnectionCellImage]
        
        //Set for all views 25 corner radius
        
        for cellView in listCellView {
            cellView.layer.cornerRadius = 25
        }
        
        //Set for all imageViews 20 corner radius
        
        for cellImage in listCellImages {
            cellImage.layer.cornerRadius = 20
        }
        
        blurView.layer.cornerRadius = 10
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        viewConstraint.constant = sideViewWidth
        
        allowTapGestures()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: -Panel slide gesture
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            
            let translation = sender.translation(in: self.view).x
            
            if translation > 0 { // swipe right
                
                if viewConstraint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
                
            }else {             // swipe left
                if viewConstraint.constant > sideViewWidth {
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
            
        } else if sender.state == .ended {
            
            if viewConstraint.constant < -120 {
                closeSideView()
            } else {
                //Open side view
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.viewConstraint.constant = 5
                    self.view.layoutIfNeeded()
                    self.isDrawerOpen = true
                })
            }
        }
    }
    
    // MARK: -Cell click event
    
    //Home cell
    @objc func homeCellClicked(sender : UITapGestureRecognizer) {
        //Remove all precedent view
        container.subviews[0].removeFromSuperview()
        
        //Add new view
        container.addSubview(homeViewController.view)
        
        closeSideView()
    }
    
    //MyChallenge cell
     @objc func myChallengeCellClicked(sender : UITapGestureRecognizer) {
        
        //Remove all precedent view
        container.subviews[0].removeFromSuperview()
        
        //Add new view
        container.addSubview(myChallengeController.view)
        
        closeSideView()
    }
    
    //PartnerChallenge cell
    @objc func partnerChallengeCellClicked(sender : UITapGestureRecognizer) {
        
        //Remove all precedent view
        container.subviews[0].removeFromSuperview()
        
        //Add new view
        container.addSubview(partnerChallengeController.view)
        
        closeSideView()
    }
    
    //SexCounter cell
    @objc func sexCounterCellClicked(sender : UITapGestureRecognizer) {
        
        //Remove all precedent view
        container.subviews[0].removeFromSuperview()
        
        //Add new view
        container.addSubview(sexCounterController.view)
        
        closeSideView()
    }
    
    //ProposeActivity cell
    @objc func proposeActivityCellClicked(sender : UITapGestureRecognizer) {
        
        //Remove all precedent view
        container.subviews[0].removeFromSuperview()
        print(container.subviews)
        
        //Add new view
        container.addSubview(proposeActivityController.view)
        
        closeSideView()
    }
    
    //Deconnection cell
    @objc func deconnectionCellClicked(sender : UITapGestureRecognizer) {
        authController.signOut()
        performSegue(withIdentifier: "Deconnection", sender: self)
        closeSideView()
    }
    
    //Container click to close drawer
    @objc func containerClicked(sender : UITapGestureRecognizer) {
        if isDrawerOpen {
            closeSideView()
        }
    }

    func closeSideView() {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.viewConstraint.constant = self.sideViewWidth
            self.view.layoutIfNeeded()
            self.isDrawerOpen = false
        })
    }
    
    func allowTapGestures() {
        //Home cell
        let homeCellGesture = UITapGestureRecognizer(target: self, action:  #selector (self.homeCellClicked(sender:)))
        self.homeCellView.addGestureRecognizer(homeCellGesture)
        
        //MyChallenge cell
        let myChallengeCellGesture = UITapGestureRecognizer(target: self, action:  #selector (self.myChallengeCellClicked(sender:)))
        self.myChallengeCellView.addGestureRecognizer(myChallengeCellGesture)
        
        //PartnerChallenge cell
        let partnerChallengeCellGesture = UITapGestureRecognizer(target: self, action:  #selector (self.partnerChallengeCellClicked(sender:)))
        self.partnerChallengeCellView.addGestureRecognizer(partnerChallengeCellGesture)
        
        //SexCounter cell
        let sexCounterCellGesture = UITapGestureRecognizer(target: self, action:  #selector (self.sexCounterCellClicked(sender:)))
        self.sexCounterCellView.addGestureRecognizer(sexCounterCellGesture)
        
        //ProposeActivity cell
        let proposeActivityCellGesture = UITapGestureRecognizer(target: self, action:  #selector (self.proposeActivityCellClicked(sender:)))
        self.proposeActivityCellView.addGestureRecognizer(proposeActivityCellGesture)
        
        //Deconnection cell
        let deconnectionCellGesture = UITapGestureRecognizer(target: self, action:  #selector (self.deconnectionCellClicked(sender:)))
        self.deconnectionCellView.addGestureRecognizer(deconnectionCellGesture)
        
        let containerGesture = UITapGestureRecognizer(target: self, action: #selector (self.containerClicked(sender:)))
        self.container.addGestureRecognizer(containerGesture)
        
        //Initialize container with the MainVC
        container.subviews[0].removeFromSuperview()
        container.addSubview(homeViewController.view)
    }
}
