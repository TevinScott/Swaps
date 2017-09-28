//
//  ItemCollection.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/27/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation

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
    func getSaleItemAtIndexPath(indexPath: IndexPath) -> SaleItem? {
        return listOfItems[indexPath.item]
    }
}
