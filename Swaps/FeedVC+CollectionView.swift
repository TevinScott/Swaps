//
//  FeedVC+CollectionView.swift
//  Swaps
//
//  Created by Tevin Scott on 1/1/18.
//  Copyright © 2018 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection View function Overrides
    
    /**
     Asks the data source object for the number of sections in the collection view.
     
     - parameter:
     -collectionView:   The collection view requesting this information
     
     - returns:             The number of sections in collectionView.
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     Asks the data source object for the number of items in the specified section.
     
     - parameters:
     -collectionView:   The collection view requesting this information.
     -section:          An index number identifying a section in collectionView. This index value is 0-based.
     
     - returns:             The number of sections in collectionView.
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  setOfItems.collectionCount //based on size of list
    }
    
    /**
     Asks your data source object for the cell that corresponds to the specified item in the collection view.
     This method must always return a valid view object.
     
     - parameters:
     -collectionView:   The collection view requesting this information.
     -indexPath:        The index path that specifies the location of the item.
     
     - returns:             A configured cell object. You must not return nil from this method.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SaleItemCollectionViewCell
        cell.saleItem = setOfItems.getSaleItemAtIndexPath(indexPath: indexPath)
        return cell
    }
    
    /**
     Tells the delegate that the item at the specified index path was selected.
     The collection view calls this method when the user successfully selects an item in the collection view.
     It does not call this method when you programmatically set the selection.
     
     - parameters:
     -collectionView:   The collection view requesting this information.
     -indexPath:        The index path of the cell that was selected.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let cell = collectionView.cellForItem(at: indexPath) as? SaleItemCollectionViewCell {
            //branch here, if user owns item go to (Edit)SaleItemSegue
            if let userID = Auth.auth().currentUser?.uid {
                if(cell.saleItem?.jsonUserID == userID){
                    performSegue(withIdentifier: "EditSaleItemSegue", sender: cell)
                }else{
                    performSegue(withIdentifier: "ViewSaleItemSegue", sender: cell)
                    print("Failed the current Users ID is: ", userID)
                    print("Failed the item userID is: ", cell.saleItem?.jsonUserID as Any)
                }
            }else{
                //user is currently not signed in.
                performSegue(withIdentifier: "ViewSaleItemSegue", sender: cell)
                print("this condition is being executed as the user is assumed to not be signed in currently")
            }
        }
    }

}
