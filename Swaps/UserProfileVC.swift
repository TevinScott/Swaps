//
//  UserProfileVC.swift
//  Swaps
//
//  Created by Tevin Scott on 10/13/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

///A View Controller that manages the Edit Item View
class UserProfileVC: UIViewController {
    
    // MARK: - Attributes
    let coreDataManager = CoreDataManager()
    let algoliaSearchManager = AlgoliaSearchManager()
    let firebaseHandle = FirebaseManager()
    var myListedItems: SaleItemCollection! = SaleItemCollection(){ didSet { myListingsCollectionView?.reloadData() } }
    let userCellIdentifier = "UserSaleCell"
    
    private let leftAndRightPadding: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 5.0
    @IBOutlet weak var myListingsCollectionView: UICollectionView!
   
    
    
    /**
     Sign out the user upon recieving the button action
     
     */
    @IBAction func signOutBtnPressed(_ sender: Any) {
        print("signOutPressed")
        signOut()
    }

    // MARK: - Support Functions
    /**
     signs out the current Google User from google & Firebase
     and removes their data from core Data
     */
    private func signOut(){
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        //coreDataManager.deleteAll()
        self.performSegue(withIdentifier: "SegueToSignIn", sender: self)
    }

    // MARK: - View controller life cycle
    override func viewDidLoad(){
        //constrains the layout to the layout property attributes
        let width = ((myListingsCollectionView.frame).width - leftAndRightPadding)/numberOfItemsPerRow
        let layout = myListingsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        algoliaSearchManager.getUserItems() { (ListOfUsersItems) -> () in
            self.myListedItems = SaleItemCollection.init(inputList: ListOfUsersItems)
        }
    }
}

