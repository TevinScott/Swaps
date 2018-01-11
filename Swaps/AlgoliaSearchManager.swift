//
//  AlgoliaSearchManager.swift
//  Swaps
//
//  Created by Tevin Scott on 12/24/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import AlgoliaSearch

/// A Class Manager for Algolia Search API Functionality
class AlgoliaSearchManager {
    

    // MARK: - Attributes
    let query = Query()
    var saleItemIndex: Index!
    var adminSaleIndex: Index!
    var searchId = 0
    var displayedSearchId = -1
    var loadedPage: UInt = 0
    var nbPages: UInt = 0
    var searchActive : Bool = false
    let firebaseHandle = FirebaseManager()
    var refreshControl: UIRefreshControl!
    
    // MARK: - Intializer
    /**
     initializes the Algolia Search Manager to point to the Skill-Trader Index and sets the attributes that will be searched
    */
    init(){
        let client = Client(appID: "KJBTLKM9VP", apiKey: "336ec5d2a6f528a23c73482a3d657643")
        saleItemIndex = client.index(withName: "Skill-Trader")
        let initialClient = Client(appID: "KJBTLKM9VP", apiKey: "5309d1fc99008e074cf9af0cbcfbe87e")
        adminSaleIndex = initialClient.index(withName: "Skill-Trader")
        query.hitsPerPage = 15
        query.attributesToRetrieve = ["name", "desc", "category"]

    }
    
    // MARK: - Database Query Functions
    /**
     gets the first 15 values within the Algolia JSON Database
     
     - parameter escapingList: returns 15 of the most recent entries in the Algolia database
    */
    func getAllItems(escapingList: @escaping ([SaleItem]) -> ()){
        adminSaleIndex.browse(from: "", completionHandler: { (content, error) -> Void in
            if error == nil {
                guard let hits = content!["hits"] as? [[String: AnyObject]] else { return }
                var tmp = [SaleItem]()
                for hit in hits {
                    tmp.append(SaleItem(json: hit))
                }
                escapingList(tmp)
            } else if error != nil{ print(error as Any) }
        })

    }
    
    /**
     gets the first 15 values matching the search parameter within the Algolia JSON Database
     
     - parameters:
        - searchString: the string for which the search will be queried by
        - escapingList: returns 15 of the best matching indices in the Algolia database
     */
    func searchDatabase(searchString: String, escapingList: @escaping ([SaleItem]) -> ()){
        query.query = searchString
        saleItemIndex.search(Query(query: query.query), completionHandler: { (content, error) -> Void in
            if error == nil {
                guard let hits = content!["hits"] as? [[String: AnyObject]] else { return }
                var tmp = [SaleItem]()
                for hit in hits {
                    tmp.append(SaleItem(json: hit))
                }
                escapingList(tmp)
            } else if error != nil{ print(error as Any) }
        })
    }
    
    func uploadToIndex(saleItem: SaleItem){
        firebaseHandle.uploadImageToFirebaseStorage(name: saleItem.name!, image: saleItem.image!){ (completedURL) -> () in //image upload
            saleItem.imageURL = completedURL
            let saleItemDictionary : [String : AnyObject] = ["name" : saleItem.name as AnyObject,
                                                             "price" : saleItem.price as AnyObject,
                                                             "desc" : saleItem.description as AnyObject,
                                                             "imageURL" : saleItem.imageURL as AnyObject,
                                                             "category" : saleItem.category as AnyObject,
                                                             "userID" : saleItem.userID as AnyObject]
            self.adminSaleIndex.addObject(saleItemDictionary, withID: "myID", completionHandler: { (content, error) -> Void in
                if error != nil {
                    print(error!)
                }
                if error == nil {
                    if let objectID = content!["objectID"] as? String {
                        print("Object ID: \(objectID)")
                    }
                    print("Object IDs: \(content!)")
                }
            })
        }
    }
}
