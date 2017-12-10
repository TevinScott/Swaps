//
//  SaleItemVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 10/2/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

/// Manages the a SaleItem View
class SaleItemVC: UIViewController {
    
    // MARK: - Attributes
    var dbManager = FirebaseDataManager()
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var itemDescLabel: UITextView!
    
    var saleItem: SaleItem? = SaleItem()
    
    // MARK: - View controller life cycle
    override func viewDidLoad(){
        updateUI()
    }
    
    // MARK: - Button Actions
    /**
     favoriteItmBtn favorites this current sale item and stores a reference to it
     in the current user's account
     
     - parameters:
         - sender: the object reference of the Button that called this function
     
     */
    @IBAction func favoriteItemBtn(_ sender: Any) {
       //store user's favorited items by itemID into user's favorites list
    }
    
    // MARK: - Support Functions
    /**
     updateUI sets all outletted values within this view controller to this current values in
     the saleItem value
     */
    func updateUI() {
        if(saleItem?.name! != nil){
            itemNameLabel.text = saleItem?.name!
        }
        if(saleItem?.price! != nil){
            itemPriceLabel.text =  "$\((saleItem?.price)!)"
        }
        if(saleItem?.description! != nil){
            itemDescLabel.text = saleItem?.description!
        }
        if (saleItem?.image != nil){
            itemImageView.image = saleItem?.image!
        }
    }
    
}
