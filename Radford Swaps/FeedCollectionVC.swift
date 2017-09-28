//
//  FeedCollectionVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/26/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

/// A Collection View Controller that manages Sale Item Cells
class FeedCollectionVC: UICollectionViewController{
    var setOfItems: ItemCollection = ItemCollection.init()
    
    //layout properties
    private let leftAndRightPadding: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 5.0
    private let cellIdentifier = "SaleCell"
    
    //MARK - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = ((collectionView?.frame)!.width - leftAndRightPadding)/numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  setOfItems.collectionCount //based on size of list
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SaleItemCollectionViewCell
        cell.saleItem = setOfItems.getSaleItemAtIndexPath(indexPath: indexPath)
        return cell
    }

}
