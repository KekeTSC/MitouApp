//
//  GamerModel.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import Foundation

class GamerModel {
    var firstName = ""
    var lastName = ""
    var myUID = ""
    var partnerUID = ""
    var currentChallenge = ""
    var challengeDone = [String]()
    var challengeFailed = [String]()
    var hasChallenge = false
    
    init(firstName: String, lastName: String, myUID: String, partnerUID: String, currentChallenge: String, challengeDone: [String], challengeFailed: [String], hasChallenge: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.myUID = myUID
        self.partnerUID = partnerUID
        self.currentChallenge = currentChallenge
        self.challengeDone = challengeDone
        self.challengeFailed = challengeFailed
        self.hasChallenge = hasChallenge
    }
    
}
