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
    var sellerAccount: UserAccountInfo!
    var firebaseHandle: FirebaseManager!
    var alogoliaHandle: AlgoliaSearchManager!
    @IBOutlet weak var sellerProfileImage: UIImageView!
    @IBOutlet weak var sellerCollection: UICollectionView!
    @IBOutlet weak var sellerViewCountLabel: UILabel!
    @IBOutlet weak var sellerRatingLabel: UILabel!
    private var imageDownloadSession: URLSessionDataTask!
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
            self.sellerAccount = accountInfo
            self.setImageFromURL(imgURL: NSURL(string: self.sellerAccount.profileImageURL)!)
            //need to round the corners 
        }
        //creates round images
        sellerProfileImage.layer.borderWidth = 1.0
        sellerProfileImage.layer.masksToBounds = false
        sellerProfileImage.layer.borderColor = UIColor.white.cgColor
        sellerProfileImage.layer.cornerRadius = sellerProfileImage.frame.size.width / 2
        sellerProfileImage.clipsToBounds = true
        /**
        algoliaSearchManager.getAllItems() { (escapingList) -> () in
            self.setOfItems = SaleItemCollection.init(inputList: escapingList)
        }
        */
    }
    /**
     sets this Cells saleItemImg to an image downloaded via URL link. this  function is done asynchronously.
     
     - Parameter imgURL: URL of the image to be downloaded
     */
    private func setImageFromURL(imgURL: NSURL){
        //NEEDS: Try Catch here , if this fails just set the image to the default-placeholder and display a network error message
        if(self.imageDownloadSession != nil){
            self.imageDownloadSession.cancel()
        }
        let task = URLSession.shared.dataTask(with: imgURL as URL, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if(data != nil){
                    let image = UIImage(data: data!)
                    self.sellerProfileImage.image = image
                }
            })
            
        })
        task.resume()
        imageDownloadSession = task
    }
}
