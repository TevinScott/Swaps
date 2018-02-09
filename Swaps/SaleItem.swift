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
    var imageURL: NSURL! 
    var category : String!
    let placeholderImage = UIImage(named: "default-placeholder")
    var timecreated: Double! //days
    var requestedPickupDate: Double!
    var saleDuration: Int!
    var creatorUserID: String!
    var itemStatus: String!
    var creationLocation: (longitude :Double, latitude: Double)!
    var meetup: (longitude :Double?, latitude: Double?)!
    
    // MARK: - Initializers
    
    /**
     initializes the JSON object in this class, causing all json-named varaibles to self intialize.
     
     - parameter json: input json object representation of a sale item.
    */
    init(json: [String: AnyObject]) {
        var jsonPickupLoc = json["pickupLocation"] as? [String: AnyObject]
        itemStatus = json["status"] as? String
        itemID = json["objectID"] as? String
        name = json["name"] as? String
        description = json["desc"] as? String
        price = json["price"] as? String
        creatorUserID = json["userID"] as? String
        imageURL = NSURL(string: (json["imageURL"] as? String)!)
        category = json["category"] as? String
        if(itemStatus == "Buyer Requested Meet Up" || itemStatus == "Seller Requested Meet Up" || itemStatus == "Confirmed") {
            meetup = (latitude: Double(String(describing: jsonPickupLoc!["lat"]!))!,
                      longitude: Double(String(describing: jsonPickupLoc!["long"]!))!)
            requestedPickupDate = Double(String(describing: json["BuyerRequestedTime"]!))!
        }
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
        imageURL = NSURL(string: ((saleAttribute["imageURL"]) as? String)!)!
        creatorUserID = ((saleAttribute["userID"]) as? String)!
    }
   
    /*
     Initializes SaleItems attributes to default values.
    */
    init() {
        image = placeholderImage!
        name = "Currently Un-named"
        price = "00.00"
        description = "no description"
        category = "no category"
    }
}
