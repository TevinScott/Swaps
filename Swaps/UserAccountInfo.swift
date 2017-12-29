//
//  UserAccountInfo.swift
//  Swaps
//
//  Created by Tevin Scott on 10/21/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import Firebase

/// A Data Structure to manage The user's account information
class UserAccountInfo {
    
    // MARK: - Attributes
    var userID : String!
    var chosenUsername: String!
    var oneTimeNameChangeUsed: Bool!
    var profileImageURL : String!
    var profileImage = UIImage(named: "default-placeholder")
    var accountSetupCompleted: Bool!
    var totalStars = 0 // 1-5 added each time this user is rated
    var averageRating: Int = 0 //total /
    var amountOfRatings: Int = 0 { didSet { averageRating = totalStars/amountOfRatings } }
    func updateRating(newRating: Int){
        totalStars += newRating
        amountOfRatings += 1
    }
    
    // MARK: - Initializers
    /**
     initializes the UserAccountInfo attributes to the given parameters
     
     - Parameters:
     - inputUserID: the userID of the user currrently signed in to the app
     - inputChosenUername: the chosen display name of the user currrently signed in to the app
     - inputNameChangeUsed: will always return true should the user decide to change their username
     - inputProfileImage: UIImage for this userAccount
     - accountSetupCompleted: A boolean answer to the question, is this userAccountSetup Completed?
     */
    init(inputUserID: String, inputChosenUsername: String, inputNameChangeUsed: Bool, inputProfileImage: UIImage, accountSetupCompleted: Bool){
        userID = inputUserID
        chosenUsername = inputChosenUsername
        oneTimeNameChangeUsed = inputNameChangeUsed
        profileImage = inputProfileImage
        self.accountSetupCompleted = accountSetupCompleted
    }
    /**
     initializes the UserAccountInfo attributes to the given parameters
     
     - Parameters:
     - inputUserID: the userID of the user currrently signed in to the app
     - inputChosenUername: the chosen display name of the user currrently signed in to the app
     - inputNameChangeUsed: will always return true should the user decide to change their username
     - inputProfileURL: a url Reference to the user's profile image
     */
    init(inputUserID: String, inputChosenUsername: String, inputNameChangeUsed: Bool, inputProfileImageURL: String){
        userID = inputUserID
        chosenUsername = inputChosenUsername
        oneTimeNameChangeUsed = inputNameChangeUsed
        profileImageURL = inputProfileImageURL
    }
    /**
     initializes the UserAccountInfo attributes to the given parameters
     
     - Parameters:
     - inputUserID: the userID of the user currrently signed in to the app
     - accountSetupCompleted: A boolean answer to the question, is this userAccountSetup Completed?
     */
    init(inputUserID: String, accountSetupCompleted: Bool){
        userID = inputUserID
        self.accountSetupCompleted = accountSetupCompleted
    }
    /**
     initializes the UserAccountInfo attributes to the given Firebase snapshot
     */
    init(snapshot: DataSnapshot) {
        let userProfileDictionary = snapshot.value as! [String: Any]
        userID = ((userProfileDictionary["userID"]) as? String)!
        chosenUsername = ((userProfileDictionary["chosenUsername"]) as? String)!
        oneTimeNameChangeUsed = ((userProfileDictionary["nameChanged?"]) as? String)?.toBool()!
        profileImageURL = ((userProfileDictionary["profileImageURL"]) as? String)!
        accountSetupCompleted = ((userProfileDictionary["accountSetupCompleted"]) as? String)?.toBool()!
    }
    init(){
        
    }
}
