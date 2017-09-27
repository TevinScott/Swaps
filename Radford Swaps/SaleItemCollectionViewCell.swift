//
//  SaleItemCollectionViewCell.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/26/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import UIKit

class SaleItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var saleItemImg: UIImageView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var priceLabel: UILabel!
    
    var saleItem: SaleItem? {
        didSet {
            updateUI()
        }
    }
    func updateUI(){
    saleItemImg.image = saleItem?.images?[0]
    }
}
