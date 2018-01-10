//
//  RelationModel.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import Foundation

class RelationModel {
    var p1UID = ""
    var p2UID = ""
    var sexCounter = 0
    var bestPlayer = ""
    
    init(p1UID: String, p2UID: String, sexCounter: Int, bestPlayer: String) {
        self.p1UID = p1UID
        self.p2UID = p2UID
        self.sexCounter = sexCounter
        self.bestPlayer = bestPlayer
    }

}
