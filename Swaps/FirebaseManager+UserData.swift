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
     - answer: on completion the escaping (Bool) value returns true or false based on wether the user has already created an account in Swaps
     */
    func isUserSetup(answer: @escaping (Bool) -> ()){
        userRef.queryOrdered(byChild: "userID").queryEqual(toValue: Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let currentUserDataLocation = snapshot.childSnapshot(forPath: Auth.auth().currentUser!.uid)
            if(currentUserDataLocation.exists()){
                //user exists in firebase database and the value of "isAccountCreationCompleted?" can be de parsed to and returned as the answer parameter
                answer(((currentUserDataLocation.childSnapshot(forPath: "isAccountCreationCompleted?").value) as! String).toBool()!)
            }else {
                //the current user has never signed into the firebase database and so "isAccountCreationCompleted?" can be inferred to be false
                answer(false)
                
            }
        })
    }
    
    // MARK: - Username Functions
    /**
     gets the Username from a given userID in the firebase database
     
     - parameters:
     - userInfo: the account for which will be checked.
     - answer:  returns true if the user already exists in firebase database
     */
    func getUsernameFromUserID(userID: String, username: @escaping(String) ->()){
        let query = userRef.queryOrderedByKey().queryEqual(toValue: userID)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            username(snapshot.childSnapshot(forPath: userID).childSnapshot(forPath: "username").value as! String)
        })
    }
    
    /**
     checks wether the given username is possesed by another user within the firebase database
     
     - parameters:
     - nameToCheckFor: the user name that will be searched for in the Firebase Datebase
     - userNameAvailable: returns a escaping (Bool) value, returning true or false based on wether the parameter nameToCheckFor is within the firebase Database
     */
    func isNameAvailable(nameToCheckFor: String, userNameAvailable: @escaping (Bool) -> ()){
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if ( !(snapshot.hasChild(nameToCheckFor)) ){
                userNameAvailable(true)
            }
            else {
                userNameAvailable(false)
            }
        })
    }
    
    // MARK: - Upload Functions
    /**
     Uploads a User's Account Info Object to Firebase's Webservice.
     Firebase Storage for the user's profile image.
     Firebase Database for the userID, chosenUsername, oneTimeNameChangeUsed, and the URL reference to the image in Firebase Storage.
     
     - Parameter userAccountInfo: the UserAccountInfo Object for which will be Uploaded to the Firebase Webservice
     */
    func uploadUserInfo(userAccountInfo: UserAccountInfo){
        
        uploadImageToFirebaseStorage(name: userAccountInfo.userID!, image: userAccountInfo.profileImage!){ (completedURL) -> () in //image upload
            userAccountInfo.profileImageURL = completedURL
            self.uploadFullUserInfoToDatabase(userAccountInfo: userAccountInfo) //saleItem upload
        }
    }
    
    func changeUsername(newUsername: String){
        userRef.child((Auth.auth().currentUser?.uid)!).updateChildValues(["chosenUsername" : newUsername])
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
