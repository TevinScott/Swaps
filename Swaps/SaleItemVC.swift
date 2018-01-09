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
    var dbManager = FirebaseManager()
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var itemDescLabel: UITextView!
    @IBOutlet var favoriteItemBtn: UIBarButtonItem!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var pickupBtn: UIButton!
    
    var saleItem: SaleItem? = SaleItem()
    var favorited: Bool = false
    
    // MARK: - View controller life cycle
    override func viewDidLoad(){
        updateUIFromJson()
    }
    
    // MARK: - Button Actions
    /**
     favoriteItmBtn favorites this current sale item and stores a reference to it
     in the current user's account
     
     - parameters:
         - sender: the object reference of the Button that called this function
     
     */
    @IBAction func favoriteItemBtnTapped(_ sender: Any) {
        if(!favorited) {
            favoriteItemBtn.image = UIImage(named: "faved")
            favorited = true
        } else if(favorited){
            favoriteItemBtn.image = UIImage(named: "notfaved")
            favorited = false
        }
    }
    
    // MARK: - Support Functions
    
    /**
     updateUI sets all outletted values within this view controller to this current values in
     updateUIFrom sets all outletted values within this view controller to this current json values in
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
    /**
     updateUIFrom sets all outletted values within this view controller to this current json values in
     the saleItem value
     */
    func updateUIFromJson() {
        if(saleItem?.jsonName != nil)  { itemNameLabel.text = saleItem?.jsonName!            }
        if(saleItem?.jsonPrice != nil) { itemPriceLabel.text =  "$\((saleItem?.jsonPrice)!)" }
        if(saleItem?.jsonDesc != nil)  { itemDescLabel.text = saleItem?.jsonDesc!            }
        if(saleItem?.image != nil)     { itemImageView.image = saleItem?.image!              }
        if(saleItem?.jsonUserID != nil){
            dbManager.getUsernameFromUserID(userID: (saleItem?.jsonUserID)!) {
                (username) -> () in self.usernameLabel.text = username}
        }
        itemImageView.layer.cornerRadius = 8.0
        itemImageView.clipsToBounds = true
    }
    
}
