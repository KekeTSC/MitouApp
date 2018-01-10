//
//  AuthController.swift
//  Mitou
//
//  Created by Kelian Daste on 04/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthController {
    
    static let sharedInstance = AuthController()
    var myUser: User? = nil
    var myUID: String = ""
    
    
    func isThereCurrentUser() -> Bool {
        if Auth.auth().currentUser != nil {
            myUser = Auth.auth().currentUser
            myUID = (myUser?.uid)!
            return true
        } else {
            return false
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        myUser = nil
    }
    
    private init() {}
}
