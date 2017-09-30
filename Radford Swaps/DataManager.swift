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
    
    /**
     Returns the JSON Object of the current values of the database
     
     - parameter Completion: Creates a thread Lock that allows this method's Asynchronous task to complete
     
     */
    func dataSync(completion: @escaping (String) -> ()) {
        let postRef = rootRef.child("Posts")
        postRef.observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
            if let output = ((snapshot.value as AnyObject).description) {
                completion(output)
                for childSnap in  snapshot.children.allObjects {
                    let snap = childSnap as! FIRDataSnapshot
                    //can be repurposed for populating a grid of items
                    if let snapshotValue = snapshot.value as? NSDictionary, let snapVal = snapshotValue[snap.key] {
                        print("val" , snapVal)
                    }
                }
            } else {
                completion("")
            }
        }
    }
    
    /**
     this function is to ONLY assist uploadSaleItemToAll
     Uploads an image to the Radford swaps Firebase mass Cloud Storage
     
     - parameter imageParam: The image that will be uploaded to the database
     - parameter name: The Name that the image will be stored under
     - returns the Firebase Image URL or  "none" if the upload failed
     */
    private func uploadImage(imageParam: UIImage, name: String) -> String {
        var imageURL: String = "none"
        let fileStorage = FIRStorage.storage().reference().child("\(name).png")
        if let imageToUpload = UIImagePNGRepresentation(imageParam) {
            fileStorage.put(imageToUpload, metadata: nil, completion: {
                (metadata, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                imageURL = (metadata?.downloadURL()?.absoluteString)!
                
                print(imageURL)
            })
        }
        return imageURL
        
    }
    /**
     this function is to ONLY assist uploadSaleItemToAll
     uploads a SaleItems Object's values ONLY to Firebase Database
     
     -parameter saleItem: the item for which the value of will be uploaded
 
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
     uploads a SaleItem Object's values to Firebase Cloud Storage
     Firebase Storage for the item image.
     Firebase Database for item name, price, description, category and, a URL reference to the image in Firebase Storage
     -parameter saleItem: the saleItem Object for which will be Uploaded
     */
    func uploadSaleItemToAll(saleItem: SaleItem){
        saleItem.imageURL = uploadImage(imageParam: saleItem.image!, name: saleItem.name!)
        uploadSaleItemToDatabase(saleItem: saleItem)
    }
}
