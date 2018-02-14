//
//  SellerVC.swift
//  Swaps
//
//  Created by Tevin Scott on 2/12/18.
//  Copyright © 2018 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

///A View Controller that manages the Seller View
class SellerVC: UIViewController {
    
    // MARK: - Attributes
    var sellerID: String!
    var firebaseHandle: FirebaseManager!
    var alogoliaHandle: AlgoliaSearchManager!
    @IBOutlet weak var sellerProfileImage: UIImageView!
    @IBOutlet weak var sellerCollection: UICollectionView!
    @IBOutlet weak var sellerViewCountLabel: UILabel!
    @IBOutlet weak var sellerRatingLabel: UILabel!
    var sellerListedItems: SaleItemCollection! = SaleItemCollection(){ didSet {
                                                 sellerCollection.reloadData()}}
    internal let standardCellIdentifier = "SaleCell"
    
    // MARK: - View controller life cycle
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //search and database init.
        firebaseHandle = FirebaseManager()
        firebaseHandle.getUserDataWith(userID: sellerID){ (accountInfo) -> () in
            
        }
        /**
        algoliaSearchManager.getAllItems() { (escapingList) -> () in
            self.setOfItems = SaleItemCollection.init(inputList: escapingList)
        }
        */
    }
}
