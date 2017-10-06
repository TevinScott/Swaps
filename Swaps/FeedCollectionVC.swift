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
    var setOfItems: ItemCollection = ItemCollection.init() {
        
        didSet {
            self.collectionView?.reloadData()
            
        }
    }
    let dbManager = DataManager()
    //layout properties
    private let leftAndRightPadding: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 5.0
    private let cellIdentifier = "SaleCell"
    
    //MARK - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //constrains the layout to the layout property attributes
        let width = ((collectionView?.frame)!.width - leftAndRightPadding)/numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
        dbManager.getAllItems() { (completedList) -> () in
            self.setOfItems = ItemCollection.init(inputList: completedList)
            
        }
    }
    
    /**
     Returns the number of sections displayed by the collection view.
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    /**
     Returns the number of cells to be displayed by the collection view based on the dataset Size.
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  setOfItems.collectionCount //based on size of list
    }
    
    /**
     Retruns a new reusable cell that is associated with the element in setOfItems using the indexPath
     */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SaleItemCollectionViewCell
        cell.saleItem = setOfItems.getSaleItemAtIndexPath(indexPath: indexPath)
        return cell
    }
    /**
     called whenever a cell is tapped
     */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let cell = collectionView.cellForItem(at: indexPath) {
            //branch here, if user owns item go to (Edit)SaleItemSegue
            performSegue(withIdentifier: "ViewSaleItemSegue", sender: cell)
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewSaleItemSegue"{
            let selectedSaleItem = (sender as! SaleItemCollectionViewCell).saleItem!
            let textToPass = selectedSaleItem
            let saleItemVC = segue.destination as! SaleItemVC
                saleItemVC.saleItem = textToPass
        }
        if segue.identifier == "EditSaleItemSegue"{
            let selectedSaleItem = (sender as! SaleItemCollectionViewCell).saleItem!
            let textToPass = selectedSaleItem
            let saleItemVC = segue.destination as! EditItemVC
            saleItemVC.saleItem = textToPass
        }
    }


}
