//
//  FirebaseManager+UserData.swift
//  Swaps
//
//  Created by Tevin Scott on 1/10/18.
//  Copyright © 2018 Tevin Scott. All rights reserved.
//

import Foundation
import FirebaseAuth

/// An extension of the Firebase Manager Class that primarily handles the accessing of user data from the Firebase Database.
extension FirebaseManager {
    
    /**
     Checks wether the currently signed in user has already been setup within the firebase database
     
     - parameters:
        - answer: on completion the escaping (Bool) value returns true or false based on wether the user has completed their account creation in the Swaps Database.
     */
    func isUserSetup(userID: String, answer: @escaping (Bool) -> ()){
        userRef.queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let currentUserDataLocation = snapshot.childSnapshot(forPath: userID)
            if(currentUserDataLocation.exists()){
                //user exists in firebase database and the value of "isAccountCreationCompleted?" can be de parsed to and returned as the answer parameter
                answer(((currentUserDataLocation.childSnapshot(forPath: "isAccountCreationCompleted?").value) as! String).toBool()!)
            }else {
                //the current user has never signed into the firebase database and so "isAccountCreationCompleted?" can be inferred to be false
                answer(false)
                
            }
        })
    }
    
    /**
     Checks wether the currently signed in, has been added to the firebase database
     
     - parameters:
        - answer: on completion the escaping (Bool) value returns true or false based on wether the user has already created an account in the Swaps Database.
     */
    func isUserInDatabase(answer: @escaping (Bool) ->()) {
        userRef.queryOrdered(byChild: "userID").queryEqual(toValue: Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let currentUserDataLocation = snapshot.childSnapshot(forPath: Auth.auth().currentUser!.uid)
            if(currentUserDataLocation.exists()){
                answer(true)
            } else {
                answer(false)
            }
        })
    }
    
    // MARK: - Username Functions
    /**
     gets the Username from a given userID in the firebase database
     
     - parameters:
        - userID: the account for which will be checked.
        - username:  returns true if the user already exists in firebase database
     */
    func getUsernameFromUserID(userID: String, username: @escaping(String) ->()){
        let query = userRef.queryOrderedByKey().queryEqual(toValue: userID)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            self.isUserSetup(userID: userID){ (answer) -> () in
                if(answer) {
                    username(snapshot.childSnapshot(forPath: userID).childSnapshot(forPath: "username").value as! String)
                } else {
                    username("Username not yet chosen")
                }
            }
        })
    }
    
    /**
     checks wether the given username is possesed by another user within the firebase database
     
     - parameters:
        - nameToCheckFor: the user name that will be searched for in the Firebase Datebase
        - userNameAvailable: returns a escaping (Bool) value, returning true or false based on wether the parameter nameToCheckFor is within the firebase Database
     */
    func isNameAvailable(nameToCheckFor: String, userNameAvailable: @escaping (Bool) -> ()){
        let nameQuery = userRef.queryOrdered(byChild: "username").queryEqual(toValue: nameToCheckFor.lowercased())
            nameQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    userNameAvailable(true)
                } else {
                    userNameAvailable(false)
                }
            })
    }
    
    // MARK: - Upload Functions
    /**
     Uploads a User's Account Info Object to Firebase's Webservice.
     Firebase Storage for the user's profile image.
     Firebase Database for the userID, chosenUsername, oneTimeNameChangeUsed, and the URL reference to the image in Firebase Storage.
     
     - parameters:
        - userAccountInfo: the UserAccountInfo Object for which will be Uploaded to the Firebase Webservice
     */
    func uploadUserInfo(userAccountInfo: UserAccountInfo){
        
        uploadImageToFirebaseStorage(name: userAccountInfo.userID!, image: userAccountInfo.profileImage!){ (completedURL) -> () in //image upload
            userAccountInfo.profileImageURL = completedURL
            self.uploadFullUserInfoToDatabase(userAccountInfo: userAccountInfo) //saleItem upload
        }
    }
    
    /**
     Changes the username of the currently signed in user to the passed in value, and sets the oneTimeNameChangeUsed? to used
     
     - parameters:
        - newUsername: the new username for which the user's username will be set to
     */
    func changeUsername(newUsername: String){
        userRef.child((Auth.auth().currentUser?.uid)!).updateChildValues(["chosenUsername" : newUsername, "oneTimeNameChangeUsed?" : "true"])
    }
    /**
     Uploads a UserAccountInfo object to firebase database under the key value of UserAccounts
     
     - parameter userAccountInfo: the reference to the UserAccountInfo object that will be added to firebase
     */
    private func uploadFullUserInfoToDatabase(userAccountInfo: UserAccountInfo){
        let userAccountDictionary : [String : String] = ["userID" : userAccountInfo.userID,
                                                         "username" : userAccountInfo.chosenUsername,
                                                         "profileImageURL" : userAccountInfo.profileImageURL,
                                                         "oneTimeNameChangeUsed?" : String(userAccountInfo.oneTimeNameChangeUsed),
                                                         "isAccountCreationCompleted?" : String(userAccountInfo.accountSetupCompleted)]
        rootRef.child("UserAccounts").child(userAccountInfo.userID).setValue(userAccountDictionary)
    }
    
    /**
     Uploads a Basic UserAccountInfo object to firebase database under the key value of UserAccounts
     
     - parameter userAccountInfo: the reference to the UserAccountInfo object that will be added to firebase
     */
    func uploadBasicUserInfo(userAccountInfo: UserAccountInfo){
        let userAccountDictionary : [String : String] = ["userID" : userAccountInfo.userID,
                                                         "isAccountCreationCompleted?" : String(userAccountInfo.accountSetupCompleted)]
        rootRef.child("UserAccounts").child(userAccountInfo.userID).setValue(userAccountDictionary)
    }
    
    
}
