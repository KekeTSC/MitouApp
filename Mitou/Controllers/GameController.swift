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
    
    func createGamer() {
        myGamerModel = GamerModel(firstName: "", lastName: "", myUID: authController.myUID, partnerUID: "", currentChallenge: "", challengeDone: [""], challengeFailed: [""], hasChallenge: false)
        ref.child("Gamers").child(authController.myUID).setValue(["firstName": myGamerModel!.firstName,
                                                                  "lastName":myGamerModel!.lastName, "myUID": myGamerModel!.myUID, "partnerUID": myGamerModel!.partnerUID, "currentChallenge": myGamerModel!.currentChallenge, "challengeDone": myGamerModel!.challengeDone, "challengeFailed": myGamerModel!.challengeFailed, "hasChallenge": myGamerModel!.hasChallenge])
    }
    
    func getGamerModel() {
        ref.child("Gamers").child(authController.myUID).observe(DataEventType.value) { (snapshot) in
            self.myGamerModel = snapshot.value as! GamerModel
        }
    }
    

    static let sharedInstance = GameController()

    private init() {}
    
}
