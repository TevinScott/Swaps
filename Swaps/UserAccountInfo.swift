//
//  UserAccountInfo.swift
//  Swaps
//
//  Created by Tevin Scott on 10/21/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import Firebase

class UserAccountInfo {
    var userID : String!
    var chosenUsername: String!
    var oneTimeNameChangeUsed: Bool!
    
    /**
     initializes the UserAccountInfo attributes to the given parameters
     
     - Parameters:
         - inputUserID: the userID of the user currrently signed in to the app
     - inputChosenUername: the chosen display name of the user currrently signed in to the app
     - inputNameChangeUsed: will always return true should the user decide to change their username
     */
    init(inputUserID: String, inputChosenUsername: String, inputNameChangeUsed: Bool){
        userID = inputUserID
        chosenUsername = inputChosenUsername
        oneTimeNameChangeUsed = inputNameChangeUsed
    }
    /**
     initializes the UserAccountInfo attributes to the given Firebase snapshot
     */
    init(snapshot: DataSnapshot) {
        let userProfileDictionary = snapshot.value as! [String: Any]
        userID = ((userProfileDictionary["userID"]) as? String)!
        chosenUsername = ((userProfileDictionary["chosenUsername"]) as? String)!
        oneTimeNameChangeUsed = ((userProfileDictionary["nameChanged?"]) as? String)?.toBool()!
    }
}
