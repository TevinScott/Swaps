//
//  DataManager.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/22/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import GoogleSignIn

/// An Interace for accessing the FireBase Database
class FirebaseDataManager {
    
    // MARK: - Attributes
    private let rootRef = Database.database().reference()
    private var saleRef: DatabaseReference!
    private var userRef: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    private var itemKeyDictionary = [String: Int]()
    private var hashIndex = 0;
    var listOfItems = [SaleItem]()
    
    // MARK: - Initializer
    init(){
        saleRef = rootRef.child("Sale Items")
        userRef = rootRef.child("UserAccounts")
    }
    
    // MARK: - Sale Item Functionality
    
    /**
     Adds new items to the class variable listOfItems and removes sales items that are no longer in the database
     
    - parameters:
        - completion: On completion the escaping value [SaleItem] is instatiated from the FireBase list of Sale Items.
     */
    func getAllItems(completion: @escaping ([SaleItem]) -> ()){
        saleRef?.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    if(self.itemKeyDictionary[child.key] == nil){
                        let aSaleItem = SaleItem.init(snapshot: child)
                        
                        self.listOfItems.append(aSaleItem)
                        self.itemKeyDictionary[child.key] = self.hashIndex
                        self.hashIndex += 1
                    }
                }
                completion(self.listOfItems)
            }
        })
        saleRef?.observe(.childRemoved, with: { (snapshot) -> Void in
            let index = self.indexOfMessage(snapshot: snapshot)
            self.listOfItems.remove(at: index)
            completion(self.listOfItems)
        })
        
    }

    /**
     Uploads a SaleItem Object's values to Firebase's Webservice..
     Firebase Storage for the item image.
     Firebase Database for item name, price, description, category and, a URL reference to the image in Firebase Storage.
     
     - parameters:
        - saleItem: the SaleItem Object for which will be Uploaded to the Firebase Webservice
     */
    func uploadSaleItem(inputSaleItem: SaleItem){

        uploadItemImage(name: inputSaleItem.name!, image: inputSaleItem.image!){ (completedURL) -> () in //image upload
            inputSaleItem.imageURL = completedURL
            self.uploadSaleItemToDatabase(saleItem: inputSaleItem) //saleItem upload
        }
    }

    /**
     Updates the current user's saleitem and stores it within the firebase database
     
     - Parameters:
        - saleItem:        a reference to the saleItem that is to be updated within the database
        - imageChanged:    specifies if the saleItem image needs to also be updated in firebase storage should this value be true
        - previousURL:      the saleItems old image URL will be used to delete the old image from firebase storage
     */
    func updateDatabaseSaleItem(saleItem: SaleItem, imageChanged: Bool, previousURL: String){
        if( Auth.auth().currentUser!.uid == saleItem.userID){
            saleRef.child(saleItem.itemID!).updateChildValues(["name": saleItem.name!,
                                                               "price" : saleItem.price!,
                                                               "desc" : saleItem.description!])
                if(imageChanged){
                    self.uploadItemImage(name: saleItem.name!, image: saleItem.image!){ (completedURL) -> () in
                        self.deleteImageInFireStorage(imageURL: saleItem.imageURL!)
                        saleItem.imageURL = completedURL
                        self.deleteImageInFireStorage(imageURL: previousURL)
                        self.saleRef.child(saleItem.itemID!).updateChildValues(["imageURL" : completedURL])
                    }
                }
        }
    }
    
    /**
     Updates a current user account should the user decide to user their One time username Change
     
     - parameter userAccountInfo: a reference to the userAccountInfo that represents the modified information of a users account info
     */
    func updateUserAccountInfo(userAccountInfo: UserAccountInfo){
        let query = userRef.queryOrderedByKey().queryEqual(toValue: userAccountInfo.userID)
        query.observe(.childAdded, with: { (snapshot) in
            snapshot.ref.updateChildValues(["chosenUsername" : userAccountInfo.chosenUsername,
                                            "nameChangeUsed" : String(userAccountInfo.oneTimeNameChangeUsed)])
        })
    }

    // MARK: - Delete Data
    
    /**
     Removes the given Sale Item from the firebase database
     
     - parameter saleItemToDelete: the primary ID of the saleItem that will be removed from the FireBase Database
     */
    func deleteSaleItem(saleItemToDelete: SaleItem) {
        saleRef = rootRef.child("Sale Items")
        saleRef?.child(saleItemToDelete.itemID!).removeValue()
        deleteImageInFireStorage(imageURL: saleItemToDelete.imageURL!)
    }
    
    // MARK: - User Account Functionality
    /**
     Uploads a User's Account Info Object to Firebase's Webservice.
     Firebase Storage for the user's profile image.
     Firebase Database for the userID, chosenUsername, oneTimeNameChangeUsed, and the URL reference to the image in Firebase Storage.
     
     - Parameter userAccountInfo: the UserAccountInfo Object for which will be Uploaded to the Firebase Webservice
     */
    func uploadUserInfo(userAccountInfo: UserAccountInfo){
        
        uploadItemImage(name: userAccountInfo.userID!, image: userAccountInfo.profileImage!){ (completedURL) -> () in //image upload
            userAccountInfo.profileImageURL = completedURL
            self.uploadUserInfoToDatabase(userAccountInfo: userAccountInfo) //saleItem upload
        }
    }
    
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
    
    // MARK: - Firebase Helper Functions
    /**
     removes the image from Firebase Storage from the given imageURL
     
     - Parameter imageURL: URL of the image that will be deleted from Firebase Storage
     */
    private func deleteImageInFireStorage (imageURL: String) {
        let imageRef = Storage.storage().reference(forURL: imageURL)
        imageRef.delete{(error)in}
    }
    
    /**
     Uploads a UserAccountInfo object to firebase database under the key value of UserAccounts
     
     - parameter userAccountInfo: the reference to the UserAccountInfo object that will be added to firebase
     */
    private func uploadUserInfoToDatabase(userAccountInfo: UserAccountInfo){
        let userAccountDictionary : [String : String] = ["userID" : userAccountInfo.userID,
                                                         "chosenUsername" : userAccountInfo.chosenUsername,
                                                         "profileImageURL" : userAccountInfo.profileImageURL,
                                                         "oneTimeNameChangeUsed?" : String(userAccountInfo.oneTimeNameChangeUsed),
                                                         "isAccountCreationCompleted?" : String(userAccountInfo.accountSetupCompleted)]
        rootRef.child("UserAccounts").child(userAccountInfo.userID).setValue(userAccountDictionary)
    }
    
    /**
     Uploads a Basic UserAccountInfo object to firebase database under the key value of UserAccounts
     
     - parameter userAccountInfo: the reference to the UserAccountInfo object that will be added to firebase
     */
    func uploadBasicUserInfoToDatabase(userAccountInfo: UserAccountInfo){
        let userAccountDictionary : [String : String] = ["userID" : userAccountInfo.userID,
                                                         "isAccountCreationCompleted?" : String(userAccountInfo.accountSetupCompleted)]
        rootRef.child("UserAccounts").child(userAccountInfo.userID).setValue(userAccountDictionary)
    }
    /**
     this function is to ONLY assist uploadSaleItemToAll
     uploads a SaleItems Object's values ONLY to Firebase Database.
     
     - Parameter saleItem: the item for which the value of will be uploaded
     */
    private func uploadSaleItemToDatabase(saleItem: SaleItem){
        
        let saleItemDictionary : [String : AnyObject] = ["name" : saleItem.name as AnyObject,
                                                         "price" : saleItem.price as AnyObject,
                                                         "desc" : saleItem.description as AnyObject,
                                                         "imageURL" : saleItem.imageURL as AnyObject,
                                                         "category" : saleItem.category as AnyObject,
                                                         "userID" : saleItem.userID as AnyObject,]
        saleRef.childByAutoId().setValue(saleItemDictionary)
    }
    
    /**
     Uploads The current image stored in the given saleItem object to Firebase Storage and returns the URL reference.
     
     - parameters:
        - name: the name of the saleItem for which the image will be saved as
        - image: a reference to the saleItem for which the containing image will be uploaded
        - completionURL: URL that references the image in firebase storage
     
     */
    private func uploadItemImage(name: String,image: UIImage, completionURL: @escaping (String) -> ()){
        let fileStorage = Storage.storage().reference().child("\(String(describing: name)).png")
        // NEEDS: TEST - may cause insertion conflicts if two items have the same name
        if let imageToUpload = UIImagePNGRepresentation(image) {
            fileStorage.putData(imageToUpload, metadata: nil, completion: {
                (metadata, error) in
                if(error != nil){
                    return
                }
                completionURL((metadata?.downloadURL()?.absoluteString)!)
            })
        }
    }
    
    /**
     Returns the index of the saleItem that has been deleted from the firebase database
     
     - Parameter snapshot: a snapshot of the data that has been removed from the firebase database
     
     - returns: the index location in listOfItems of the saleItem that has been deleted from the database
     */
    private func indexOfMessage(snapshot: DataSnapshot) -> Int {
        var index = 0
        for  saleItem in self.listOfItems {
            if (snapshot.key == saleItem.itemID) {
                return index
            }
            index += 1
        }
        return -1
    }

}
