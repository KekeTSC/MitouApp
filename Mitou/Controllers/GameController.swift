//
//  GameController.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class GameController {
    
    var ref: DatabaseReference! = Database.database().reference()
    let authController: AuthController = AuthController.sharedInstance
    var myGamerModel: GamerModel? = nil
    var mListOfChallenges = [ChallengeModel]()
    var isAnimationFinished = false
    var isGamerModelLoaded = false
    var isChallengesLoaded = false
    
    static let sharedInstance = GameController()
    weak var observer: Observer?
    
    private init() {}
    
    func createGamer() {
        myGamerModel = GamerModel(firstName: "Goku", lastName: "Son", myUID: authController.myUID, partnerUID: "", currentChallenge: "", challengeDone: [""], challengeFailed: [""], hasChallenge: false)
        ref.child("Gamers").child(authController.myUID).setValue(["firstName": myGamerModel!.firstName,
                                                                  "lastName":myGamerModel!.lastName, "myUID": myGamerModel!.myUID, "partnerUID": myGamerModel!.partnerUID, "currentChallenge": myGamerModel!.currentChallenge, "challengeDone": myGamerModel!.challengeDone, "challengeFailed": myGamerModel!.challengeFailed, "hasChallenge": myGamerModel!.hasChallenge])
    }
    
    func loadGamerModel() {
        ref.child("Gamers").child(authController.myUID).observe(DataEventType.value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
    
            let firstName = value["firstName"] as? String ?? ""
            let lastName = value["lastName"] as? String ?? ""
            let myUID = value["myUID"] as! String
            let partnerUID = value["partnerUID"] as? String ?? ""
            let currentChallenge = value["currentChallenge"] as? String ?? ""
            let challengeDone = (value["challengeDone"] as! NSArray) as? [String] ?? [String]()
            let challengeFailed = (value["challengeFailed"] as! NSArray) as? [String] ?? [String]()
            let hasChallenge = value["hasChallenge"] as! Bool
            self.myGamerModel = GamerModel(firstName: firstName, lastName: lastName, myUID: myUID, partnerUID: partnerUID, currentChallenge: currentChallenge, challengeDone: challengeDone, challengeFailed: challengeFailed, hasChallenge: hasChallenge)
            self.isGamerModelLoaded = true
            self.observer?.updateModel()
            print("----------Model-----------")
            print(self.myGamerModel!.firstName)
            print(self.myGamerModel!.lastName)
            print(self.myGamerModel!.currentChallenge)
            print("Model----------------Model")
        }
    }
    
    func loadListOfChallenges() {
        ref.child("Challenges").observe(DataEventType.value) { (snapshot) in
            self.mListOfChallenges = [ChallengeModel] ()
            let values = snapshot.value as! NSDictionary
            for value in values.allValues {
                let challengeModel = value as! NSDictionary
                let challenge = challengeModel["challenge"] as! String
                let location = challengeModel["location"] as! String
                let categorie = challengeModel["categorie"] as! String
                let id = challengeModel["id"] as! String
                self.mListOfChallenges.append(ChallengeModel(
                    challenge: challenge,
                    location: location,
                    categorie: categorie,
                    id: id))
                self.isChallengesLoaded = true
            }
            print("------------Challenges-------------")
            for challenge in self.mListOfChallenges {
                print(challenge.challenge)
            }
            print("Challenges---------------Challenges")
            self.observer?.updateChallenges()
        }
    }
    
    func getSingleChallenge(challenge id: String) -> ChallengeModel? {
        var theChallenge: ChallengeModel?
        
        for challenge in mListOfChallenges {
            if challenge.id == id {
                theChallenge = challenge
                return theChallenge
            } else {
                theChallenge = nil
            }
        }
        return theChallenge
    }
}
