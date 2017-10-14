//
//  FeedCollectionVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/26/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

/// A Collection View Controller that manages the Feed Collection and its Sale Item Cells
class FeedCollectionVC: UICollectionViewController{
    
    
    var setOfItems: ItemCollection = ItemCollection.init() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    let dbManager = FirebaseDataManager()
    var keyboardHandler : KeyboardHandler!
    
    //layout properties
    private let leftAndRightPadding: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 5.0
    private let cellIdentifier = "SaleCell"
    

    // MARK: - Collection View function Overrides
    
    /**
     Asks the data source object for the number of sections in the collection view.
     
     - parameter:
         -collectionView:   The collection view requesting this information
     
     - returns:             The number of sections in collectionView.
     
     
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     Asks the data source object for the number of items in the specified section.
     
     - parameters:
         -collectionView:   The collection view requesting this information.
         -section:          An index number identifying a section in collectionView. This index value is 0-based.
     
     - returns:             The number of sections in collectionView.
     
     
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let cell = collectionView.cellForItem(at: indexPath) {
            //branch here, if user owns item go to (Edit)SaleItemSegue
            performSegue(withIdentifier: "ViewSaleItemSegue", sender: cell)
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
    }
    
    // MARK: Segue Override
    
    /**
     Notifies the view controller that a segue is about to be performed.
     
     - parameters:
         -segue:    The segue object containing information about the view controllers involved in the segue.
         -sender:   The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
     
     */
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
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //constrains the layout to the layout property attributes
        let width = ((collectionView?.frame)!.width - leftAndRightPadding)/numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
        keyboardHandler = KeyboardHandler.init(view: self)
        dbManager.getAllItems() { (completedList) -> () in
            self.setOfItems = ItemCollection.init(inputList: completedList)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.addObservers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyboardHandler.removeObservers()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.removeObservers()
    }
    
}
