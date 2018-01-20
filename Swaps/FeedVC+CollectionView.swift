//
//  FeedVC+CollectionView.swift
//  Swaps
//
//  Created by Tevin Scott on 1/1/18.
//  Copyright © 2018 Tevin Scott. All rights reserved.
//

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
        let cellSaleItem = setOfItems.getSaleItemAtIndexPath(indexPath: indexPath)
        cell.saleItem = cellSaleItem
        return cell
    }
    
    /**
     Tells the delegate that the item at the specified index path was selected.
     The collection view calls this method when the user successfully selects an item in the collection view.
     
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
                }
                else{
                    //user is currently signed in but their userID does not match that of the sale item's userID.
                    performSegue(withIdentifier: "ViewSaleItemSegue", sender: cell)
                }
            } else {
                //user is not currently signed in.
                performSegue(withIdentifier: "ViewSaleItemSegue", sender: cell)
            }
        }
    }
    
    // MARK: - Segue Override
    /**
     Notifies the view controller that a segue is about to be performed.
     
     - parameters:
        - segue:    The segue object containing information about the view controllers involved in the segue.
        - sender:   The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewSaleItemSegue"{
            let selectedSaleItem = (sender as! SaleItemCollectionViewCell).saleItem!
            let textToPass = selectedSaleItem
            let saleItemVC = segue.destination as! SaleItemVC
            saleItemVC.saleItem = textToPass
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.searchBar.frame.origin.y = 0
            self.collectionView.frame.origin.y = self.collectionViewOriginalLocation
        }
        if segue.identifier == "EditSaleItemSegue"{
            let selectedSaleItem = (sender as! SaleItemCollectionViewCell).saleItem!
            let textToPass = selectedSaleItem
            let saleItemVC = segue.destination as! EditItemVC
            saleItemVC.saleItem = textToPass
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.searchBar.frame.origin.y = 0
            self.collectionView.frame.origin.y = self.collectionViewOriginalLocation
        }
    }

}
