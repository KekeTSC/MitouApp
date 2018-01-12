//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.

import UIKit
import Koloda
import pop

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BackgroundAnimationViewController: UIViewController {

    @IBOutlet weak var kolodaView: CustomKolodaView!
    let gameController = GameController.sharedInstance
    var listChallenge = [ChallengeModel]() { didSet {
            kolodaView.reloadData()
            print("culcul")
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        listChallenge += gameController.mListOfChallenges
        listChallenge.append(ChallengeModel(challenge: "Rouler sur moi", location: "Toulouse", categorie: "ZIZI", id: "1"))
        listChallenge.append(ChallengeModel(challenge: "Rouler sur toi", location: "Toulouse", categorie: "TOTO", id: "2"))
        listChallenge.append(ChallengeModel(challenge: "Rouler sur nous", location: "Toulouse", categorie: "TETE", id: "234"))
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    
    //MARK: IBActions
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }

    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
        print("leftButtonTapped")
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
        print("rightButtonTapped")
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
        print("undoButtonTapped")
    }
    
    @IBAction func closeChallengeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
        print("resetCards")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .left {
            print("left\(index)")
        } else if direction == .right {
            print("right\(index)")
        }
    }
}

// MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return listChallenge.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)?[0] as? CardView
        cardView?.layer.cornerRadius = 15
        cardView?.challengeNameLabel.text = listChallenge[index].challenge
        cardView?.challengeCategorieLabel.text = listChallenge[index].categorie
        cardView?.challengeLocationLabel.text = listChallenge[index].location
        return cardView!
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
