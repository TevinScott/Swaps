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
    var firebaseHandle: FirebaseManager!
    var alogoliaHandle: AlgoliaSearchManager!
    @IBOutlet weak var sellerProfileImage: UIImageView!
    @IBOutlet weak var sellerCollection: UICollectionView!
    @IBOutlet weak var sellerViewCountLabel: UILabel!
    @IBOutlet weak var sellerRatingLabel: UILabel!
    
}
