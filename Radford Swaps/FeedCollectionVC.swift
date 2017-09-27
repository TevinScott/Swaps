//
//  FeedCollectionVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/26/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
class FeedCollectionVC: UICollectionViewController{
    var setOfItems: [SaleItem]?
    
    //layout properties
    private let leftAndRightPadding: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 5.0
    
    //MARK - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = ((collectionView?.frame)!.width - leftAndRightPadding)/numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
    }
    private struct Storyboard{
        static let CellIdentifier = "SaleCell"
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20 //based on size of list
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as! SaleItemCollectionViewCell
        /*STOPPING POINT
        *need to instantiate the cell usings an element from
        *setOfItems However...
        *a Class that manages setOfItems would be better for abstraction
        *it will also make it easier to minimize code repetition
        *and also handles the conversion from array indexes to IndexPath format**
        */
        return cell
    }

}
