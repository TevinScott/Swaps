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
    
    var dbManager = DataManager()
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var itemDescLabel: UILabel!
    
    var saleItem: SaleItem? = SaleItem(){
        didSet {
            updateUI()
        }
    }
    /**
     updateUI sets all outletted values within this view controller to this current values in
     the saleItem value
     */
    func updateUI() {
        itemNameLabel.text = saleItem?.name
        itemPriceLabel.text =  "$\((saleItem?.price)!)"
        itemDescLabel.text = saleItem?.description
        if (saleItem?.image != nil){
            itemImageView.image = saleItem?.image
        }
    }
    /**
     removeItemBtn removes the current saleItem from public listings
     */
    @IBAction func removeItemBtn(_ sender: Any) {
        //dbManager.removeSaleItem(saleItemID: (saleItem?.itemID)!)
    }
    
}
