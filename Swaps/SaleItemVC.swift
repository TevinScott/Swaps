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
    @IBOutlet var favoriteItemBtn: UIBarButtonItem!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var pickupBtn: UIButton!
    
    var saleItem: SaleItem? = SaleItem()
    var favorited: Bool = false
    
    // MARK: - View controller life cycle
    override func viewDidLoad(){
        updateUIFromJson()
        setupPickupBtnStyling()
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
    sets up the pickup button's border styling
    */
    private func setupPickupBtnStyling(){
        pickupBtn.backgroundColor = .clear
        pickupBtn.layer.cornerRadius = 5
        pickupBtn.layer.borderWidth = 1
        pickupBtn.layer.borderColor = UIColor(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
    }
    
    /**
     updateUIFrom sets all outletted values within this view controller to this current json values in
     the saleItem value
     */
    func updateUIFromJson() {
        if(saleItem?.jsonName != nil){  itemNameLabel.text = saleItem?.jsonName!            }
        if(saleItem?.jsonPrice != nil){ itemPriceLabel.text =  "$\((saleItem?.jsonPrice)!)" }
        if(saleItem?.jsonDesc != nil){  itemDescLabel.text = saleItem?.jsonDesc!            }
        if(saleItem?.image != nil){     itemImageView.image = saleItem?.image!              }
        if(saleItem?.jsonUserID != nil){
            dbManager.getUsernameFromUserID(userID: (saleItem?.jsonUserID)!) {
                (username) -> () in self.usernameLabel.text = username}
        }
    }
    
}
