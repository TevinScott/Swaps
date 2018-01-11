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
    

    // MARK: - Attributes
    //cell component references
    @IBOutlet var saleItemImg: UIImageView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var priceLabel: UILabel!
    var saleItem: SaleItem? { didSet { updateUIFromJson()} }

    // MARK: - Support Functions
    /**
     updates this cell to the current values of the SaleItem.
    */
    func updateUI(){
        //places dollarsign in front of sale item price
        if let priceVal: String = saleItem?.price! {
            priceLabel.text = "$\(priceVal)"
        }

        if (saleItem?.imageURL != nil){
            setImageFromURLString(imgURL: (saleItem?.imageURL)!)
        }
        else {
            saleItemImg.image = (saleItem?.placeholderImage)!
        }
    }
    /**
     updates this cell to the current SaleItem's JSON attributes.
     */
    func updateUIFromJson(){
        //places dollarsign in front of sale item price
        if let priceVal: String = saleItem?.jsonPrice! {
            priceLabel.text = "$\(priceVal)"
        }
        // if the sale image is equal to the currently set cell image do nothing
        if(saleItemImg?.image?.isEqualToImage(image: (saleItem?.image)!))!{
            
        }
        // else if the images dont match, try to parse from the non-nil imageURL of the sale item
        else if (saleItem?.jsonImageURL != nil){
            setImageFromURL(imgURL: (saleItem?.jsonImageURL)!)
        }
        // final case senario the cell is set to a default placeholder image
        else {
            saleItemImg.image = (saleItem?.placeholderImage)!
        }
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
    /**
     sets this Cells saleItemImg to an image downloaded via URL link. this  function is done asynchronously.
     
     - Parameter imgURL: URL of the image to be downloaded
     */
    private func setImageFromURL(imgURL: NSURL){
        URLSession.shared.dataTask(with: imgURL as URL, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.saleItem?.image = image
                self.saleItemImg.image = image
            })
            
        }).resume()
    }
    /**
     sets this Cells saleItemImg to an image downloaded via URL link. this  function is done asynchronously.
     
     - Parameter imgURL: URL of the image to be downloaded
     */
    private func setImageFromURLString(imgURL: String){
        URLSession.shared.dataTask(with: NSURL(string: imgURL)! as URL, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.saleItem?.image = image
                self.saleItemImg.image = image
            })
            
        }).resume()
    }
}
