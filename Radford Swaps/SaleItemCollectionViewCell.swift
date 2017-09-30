//
//  SaleItemCollectionViewCell.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/26/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import UIKit

class SaleItemCollectionViewCell: UICollectionViewCell {
    
    //cell component references
    @IBOutlet var saleItemImg: UIImageView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var priceLabel: UILabel!
    
    /// a sale item that updates the ui when saleItem is set
    var saleItem: SaleItem? {
        didSet {
            updateUI()
        }
    }
    
    /**
     updates this cell to the current values of the SaleItem
    */
    func updateUI(){
        saleItemImg.image = saleItem?.image
        //places dollarsign infront of price
        priceLabel.text = "$\(String(describing: saleItem?.price!))"
        //***input should be stored as string in %.2f format***
    }
}
