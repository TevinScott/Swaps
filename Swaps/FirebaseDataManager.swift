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
    let rootRef = FIRDatabase.database().reference()
    var saleRef: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    var itemKeyDictionary = [String: Int]()
    var hashIndex = 0;
    var listOfItems = [SaleItem]()
    
    // MARK: - Initializer
    init(){
        saleRef = rootRef.child("Sale Items")
    }
    
    // MARK: - Get Data
    /**
     adds new items to the class variable listOfItems and removes sales items that are no longer in the database
     
     - parameters:
         - completion: on completion the escaping value [SaleItem] is instatiated from the FireBase list of Sale Items
     
     */
    func getAllItems(completion: @escaping ([SaleItem]) -> ()){
        
        saleRef?.observe(FIRDataEventType.value, with: { (snapshot:FIRDataSnapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
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
     Returns the index of the saleItem that has been deleted from the firebase database
     
     - Parameter snapshot: a snapshot of the data that has been removed from the firebase database
     
     - returns: the index location in listOfItems of the saleItem that has been deleted from the database
     */
    private func indexOfMessage(snapshot: FIRDataSnapshot) -> Int {
        var index = 0
        for  saleItem in self.listOfItems {
            if (snapshot.key == saleItem.itemID) {
                return index
            }
            index += 1
        }
        return -1
    }

    /**
     uploads a SaleItem Object's values to Firebase Cloud Storage.
     Firebase Storage for the item image.
     Firebase Database for item name, price, description, category and, a URL reference to the image in Firebase Storage.
     
     - Parameter saleItem: the saleItem Object for which will be Uploaded
     */
    func uploadSaleItem(inputSaleItem: SaleItem){

        uploadItemImage(saleItem: inputSaleItem){ (completedURL) -> () in //image upload
            inputSaleItem.imageURL = completedURL
            self.uploadSaleItemToDatabase(saleItem: inputSaleItem) //saleItem upload
        }
    }
    
    // MARK: - Update & Upload Data
    /**
     updates the current user's saleitem and stores it within the firebase database
     */
    func updateDatabaseSaleItem(saleItem: SaleItem, imageChanged: Bool){
        
        if(GIDSignIn.sharedInstance().clientID == saleItem.userID){
            let query = saleRef?.queryOrderedByKey().queryEqual(toValue: saleItem.itemID)
            
            query?.observe(.childAdded, with: { (snapshot) in
                snapshot.ref.updateChildValues(["name": saleItem.name!,
                                                "price" : saleItem.price!,
                                                "desc" : saleItem.description!])
                if(imageChanged){
                    self.uploadItemImage(saleItem: saleItem){ (completedURL) -> () in
                        self.deleteImageInFireStorage(imageURL: saleItem.imageURL!)
                        saleItem.imageURL = completedURL
                        snapshot.ref.updateChildValues(["imageURL" : completedURL])
                    }
                }
            })
        }
    }
    
    /**
     Uploads The current image stored in the given saleItem object to Firebase Storage and returns the URL reference.
     
     - Parameter saleItem: a reference to the saleItem for which the containing image will be uploaded
     - parameter completionURL: URL that references the image in firebase storage
     
     */
    private func uploadItemImage(saleItem: SaleItem, completionURL: @escaping (String) -> ()){
        let fileStorage = FIRStorage.storage().reference().child("\(String(describing: saleItem.name!)).png")
        if let imageToUpload = UIImagePNGRepresentation(saleItem.image!) {
            fileStorage.put(imageToUpload, metadata: nil, completion: {
                (metadata, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                completionURL((metadata?.downloadURL()?.absoluteString)!)
            })
        }
        
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
        rootRef.child("Sale Items").childByAutoId().setValue(saleItemDictionary)
    }
    
    // MARK: - Delete Data
    /**
     removes the given Sale Item from the firebase database
     
     - Parameter saleItemID: the primary ID of the saleItem that will be removed from the FireBase Database
     
     */
    func deleteSaleItem(saleItemToDelete: SaleItem) {
        saleRef = rootRef.child("Sale Items")
        saleRef?.child(saleItemToDelete.itemID!).removeValue()
        deleteImageInFireStorage(imageURL: saleItemToDelete.imageURL!)
    }
    
    /**
     removes the image from Firebase Storage from the given imageURL
     
     - Parameter imageURL: URL of the image that will be deleted from Firebase Storage
     
     */
    private func deleteImageInFireStorage (imageURL: String) {
        let imageRef = FIRStorage.storage().reference(forURL: imageURL)
        imageRef.delete { (error) in
            if let err = error {
                print(err)
            } else {
                print("successfully deleted image from Fire-Storage")
            }
        }
    }
    
}
