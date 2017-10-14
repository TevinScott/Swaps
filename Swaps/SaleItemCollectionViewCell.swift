//
//  SaleItemCollectionViewCell.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/26/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import UIKit
///Managers the SaleItemViewCell and its attributes
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
     updates this cell to the current values of the SaleItem.
    */
    func updateUI(){
        //places dollarsign in front of sale item price
        if let priceVal: String = saleItem?.price! {
            priceLabel.text = "$\(priceVal)"
        }

        if (saleItem?.imageURL != nil){
            setImageFromURL(imgURL: (saleItem?.imageURL)!)
        }
        else {
            saleItemImg.image = (saleItem?.placeholderImage)!
        }
    }
    
    /**
     sets this Cells saleItemImg to an image downloaded via URL link. this  function is done asynchronously.
     
     - Parameter imgURL: URL of the image to be downloaded
     */
    private func setImageFromURL(imgURL: String){
        URLSession.shared.dataTask(with: NSURL(string: imgURL)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.saleItem?.image = image
                self.saleItemImg.image = image
            })
            
        }).resume()
    }
}
