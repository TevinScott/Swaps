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
    
    /**
     Executes the function body upon pickupBtn being pressed.
     This function should trigger a segue to the PickupVC
     */
    @IBAction func pickupBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "PickupViewSegue", sender: self)
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
        if(saleItem?.name != nil)       { itemNameLabel.text = saleItem?.name!              }
        if(saleItem?.price != nil)      { itemPriceLabel.text =  "$\((saleItem?.price)!)"   }
        if(saleItem?.description != nil){ itemDescLabel.text = saleItem?.description!       }
        if(saleItem?.image != nil)     { itemImageView.image = saleItem?.image!             }
        if(saleItem?.creatorUserID != nil){
            dbManager.getUsernameFromUserID(userID: (saleItem?.creatorUserID)!) {
                (username) -> () in self.usernameLabel.text = username}
        }
        itemImageView.layer.cornerRadius = 8.0
        itemImageView.clipsToBounds = true
    }
    
    // MARK: - Segue Override
    /**
     Notifies the view controller that a segue is about to be performed.
     
     - parameters:
     - segue:    The segue object containing information about the view controllers involved in the segue.
     - sender:   The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickupViewSegue"{
            let pickupView = segue.destination as! PickupVC
            pickupView.saleItem = self.saleItem
        }
    }
    
}
