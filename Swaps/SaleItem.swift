//
//  SaleItem.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/25/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
import Firebase
/// SaleItem describes an item that a user would like to Sell
class SaleItem {
    
    var itemID: String?
    var name: String?
    var price: String?
    var description: String?
    var image: UIImage?
    var imageURL: String? // only instantiated after this saleItem is uploaded
    var category : String?
    let placeholderImage = UIImage(named: "default-placeholder")
    var userID: String? //if a new item is created the current Google User ID should be used
    
    /**
    intializes variables to default placeholder values for testing.
     
     - parameters:
         - snapshot: A snapshot of a saleItem currently in the FirebaseDatabase
     */
    init(snapshot: FIRDataSnapshot) {
        let saleAttribute = snapshot.value as! [String: Any]
        itemID = snapshot.key
        name = ((saleAttribute["name"]) as? String)!
        price = ((saleAttribute["price"]) as? String)!
        description = ((saleAttribute["desc"]) as? String)!
        imageURL = ((saleAttribute["imageURL"]) as? String)!
        
    }

    /*
     initializes SaleItems attributes to default values
    */
    init(){
        image = placeholderImage!
        name = "Currently Un-named"
        price = "00.00"
        description = "no description"
        category = "no category"
    }
}
