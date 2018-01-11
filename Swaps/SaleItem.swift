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
    
     // MARK: - Attributes
    var itemID: String!
    var name: String!
    var price: String!
    var description: String!
    var image: UIImage!
    var imageURL: String! // only instantiated after this saleItem is uploaded
    var category : String!
    let placeholderImage = UIImage(named: "default-placeholder")
    var Timecreated: Date! //days
    var saleDuration: Int!
    var userID: String!
    var creationLocation: (longitude :Double, latitude: Double)!
    var pickupLocation: (longitude :Double, latitude: Double)!
    private var json: [String: AnyObject]!
    
    // MARK: - JSON Attributes
    var jsonCategory: String! { return json["category"] as? String }
    var jsonDesc: String! { return json["desc"] as? String }
    var jsonImageURL: NSURL! {
        guard let jsonUrlString = json["imageURL"] as? String else { return nil }
        imageURL = jsonUrlString
        return NSURL(string: jsonUrlString)
    }
    var jsonName: String! { return json["name"] as? String }
    var jsonPrice: String! { return json["price"] as? String }
    var jsonUserID: String! { return json["userID"] as? String }
    var jsonObjectID: String!{ return json["objectID"] as? String }
    
    // MARK: - Initializers
    
    /**
     initializes the JSON object in this class, causing all json-named varaibles to self intialize.
     
     - parameter json: input json object representation of a sale item.
    */
    init(json: [String: AnyObject]) {
        self.json = json
    }
    /**
    intializes variables to default placeholder values for testing.
     
     - parameters:
         - snapshot: A snapshot of a saleItem currently in the FirebaseDatabase.
     */
    init(snapshot: DataSnapshot) {
        let saleAttribute = snapshot.value as! [String: Any]
        itemID = snapshot.key
        name = ((saleAttribute["name"]) as? String)!
        price = ((saleAttribute["price"]) as? String)!
        description = ((saleAttribute["desc"]) as? String)!
        imageURL = ((saleAttribute["imageURL"]) as? String)!
        userID = ((saleAttribute["userID"]) as? String)!
    }
   

    /*
     Initializes SaleItems attributes to default values.
    */
    init(){
        image = placeholderImage!
        name = "Currently Un-named"
        price = "00.00"
        description = "no description"
        category = "no category"
    }
}
