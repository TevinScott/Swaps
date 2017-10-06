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


/// An Interace for accessing the FireBase Database
class DataManager {
    let rootRef = FIRDatabase.database().reference()
    var saleRef: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    var itemKeyDictionary = [String: Int]()
    var hashIndex = 0;
    var listOfItems = [SaleItem]()
    
    /**
     adds new items to the class variable listOfItems and removes sales items that are no longer in the database

     - parameters:
         -Completion: on completion the escaping value [SaleItem] is instatiated from the FireBase list of Sale Items
     
     */
    func getAllItems(completion: @escaping ([SaleItem]) -> ()){
        
        saleRef = rootRef.child("Sale Items")
        
        saleRef?.observe(FIRDataEventType.value, with: { (snapshot:FIRDataSnapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var tempItemKeyDictionary = [String: Int]()
                var tempHashIndex = 0
                for child in result {
                    tempItemKeyDictionary[child.key] = tempHashIndex
                    tempHashIndex += 1
                    if(self.itemKeyDictionary[child.key] == nil){
                        let aSaleItem = SaleItem.init(snapshot: child)
                        self.listOfItems.append(aSaleItem)
                        self.itemKeyDictionary[child.key] = self.hashIndex
                        self.hashIndex += 1
                    }
                }
                //remove any values that arent within firebase
                for (key,_) in self.itemKeyDictionary {
                    if(tempItemKeyDictionary[key] == nil){
                        self.listOfItems.remove(at: self.itemKeyDictionary[key]!)
                        self.itemKeyDictionary[key] = nil
                        
                    }
                }
                completion(self.listOfItems)
            }
        })
    }

    /**
     uploads a SaleItem Object's values to Firebase Cloud Storage.
     Firebase Storage for the item image.
     Firebase Database for item name, price, description, category and, a URL reference to the image in Firebase Storage.
     
     - Parameter saleItem: the saleItem Object for which will be Uploaded
     */
    func uploadSaleItemToAll(saleItem: SaleItem){
        var imageURL: String = "none"
        let fileStorage = FIRStorage.storage().reference().child("\(String(describing: saleItem.name!)).png")
        if let imageToUpload = UIImagePNGRepresentation(saleItem.image!) {
            fileStorage.put(imageToUpload, metadata: nil, completion: {
                (metadata, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                imageURL = (metadata?.downloadURL()?.absoluteString)!
                saleItem.imageURL = imageURL
                self.uploadSaleItemToDatabase(saleItem: saleItem)
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
                                                         "category" : saleItem.category as AnyObject,]
        rootRef.child("Sale Items").childByAutoId().setValue(saleItemDictionary)
    }
    
    /**
     removeSaleItem from the firebase database
     
     - Parameter saleItemID: the primary ID of the saleItem that will be removed from the FireBase Database
     */
    func removeSaleItem(saleItemID: String) {
        saleRef = rootRef.child("Sale Items")
        saleRef?.child(saleItemID).removeValue()
    }
    
}
