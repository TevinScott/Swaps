//
//  SaleItem.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/25/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

///SaleItem describes an item that a user would like to Sell
class SaleItem {
    var name: String?
    var price: Double?
    var description: String?
    var images: [UIImage]?
    var category : String?
    
    /*
    intializes variables to default placeholder values for testing
     */
    private func placeHolderInit() {
        let placeholderImage = UIImage(named: "ps4")
        images = [placeholderImage!]
        name = "Item Name Here"
        price = 99.99
        description = "Item Description used here"
        category = "placeholder category"
    }
    /*
     initializes SaleItems attributes
    */
    init(){
        placeHolderInit()
    }
}
