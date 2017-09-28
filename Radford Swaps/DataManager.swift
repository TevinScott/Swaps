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
import FirebaseAnalytics
import FirebaseDatabase
/// a Interace for accessing the FireBase Database
class DataManager {
    let rootRef = FIRDatabase.database().reference()
    
    /**
     Desc: returns the JSON Object of the current values of the database
     
     @param Completion: Creates a thread Lock that allows this method's Asynchronous task to complete
     
     @return none
     */
    func dataSync(completion: @escaping (String) -> ()) {
        let postRef = rootRef.child("Posts")
        postRef.observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
            if let output = ((snapshot.value as AnyObject).description) {
                completion(output)
                for childSnap in  snapshot.children.allObjects {
                    let snap = childSnap as! FIRDataSnapshot
                    //can be repurposed for populating a grid of items
                    if let snapshotValue = snapshot.value as? NSDictionary, let snapVal = snapshotValue[snap.key] as? AnyObject {
                        print("val" , snapVal)
                    }
                }
            }
            else {
                completion("")
            }
        }
    }
}
