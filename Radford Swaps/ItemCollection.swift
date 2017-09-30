//
//  ItemCollection.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/27/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation

/// In ItemCollection Stores a List Of Items and provides functionality protaining to the data structure
class ItemCollection {
    private var listOfItems = [SaleItem]()
    
    var collectionCount: Int {
        return listOfItems.count
    }
    
    ///initializes an ItemCollection Object to placeholder values currently
    init(){
        let saleItemObj = SaleItem.init()
        listOfItems = [SaleItem](repeating: saleItemObj, count: 100)
    }
    /**
     Returns a SaleItem based on the location of the indexPath given
     - parameter indexPath: used to specify the element of a SaleItem within listOfItems
     
     - returns: The SaleItem corresponding to the IndexPath Given
     */
    func getSaleItemAtIndexPath(indexPath: IndexPath) -> SaleItem? {
        if((listOfItems.count) > 0 && (indexPath.item < listOfItems.count)){
            return listOfItems[indexPath.item]
        }
        else {
            return SaleItem.init()
        }
    }
}
