//
//  ChallengeModel.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import Foundation

class ChallengeModel {
    var challenge = ""
    var location = ""
    var categorie = ""
    var id = ""
    
    init(challenge: String, location: String, categorie: String, id: String) {
        self.challenge = challenge
        self.location = location
        self.categorie = categorie
        self.id = id
    }
}
