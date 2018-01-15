//
//  FeedVC.swift
//  Swaps
//
//  Created by Tevin Scott on 12/17/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import Firebase
import GoogleMobileAds
import AlgoliaSearch

/// A Class that manages the Feed View and its sub views
class FeedVC : UIViewController, UISearchBarDelegate{
    
    // MARK: - Attributes
    let coredataManager = CoreDataManager()
    let firebaseDataManager = FirebaseManager()
    let algoliaSearchManager = AlgoliaSearchManager.init()
    //adMob variables
    var adsToLoad = [GADNativeExpressAdView]()
    let adInterval = 3
    // outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    //layout properties
    var collectionViewOriginalLocation: CGFloat!
    var extendedCollectionViewHeight: CGFloat!
    private let leftAndRightPadding: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 5.0
    let cellIdentifier = "SaleCell"
    var setOfItems: SaleItemCollection = SaleItemCollection.init(){ didSet { collectionView?.reloadData() } }
    var searchActive : Bool = false
    var refreshControl: UIRefreshControl!

    // MARK: - Button Actions
    /**
     Presents the newItemView to user, if they are currently signed into an account.
     */
    @IBAction func postItemBtnAction(_ sender: Any) {
        if(Auth.auth().currentUser?.uid != nil) {
            performSegue(withIdentifier: "postNewItemSegue", sender: self)
        }
    }
    
    /**
     this button action returns the user to the
     */
    @IBAction func profileBtnAction(_ sender: Any) {
        //if user is currently signed in the profile view is presented
        if (Auth.auth().currentUser?.uid != nil){
           performSegue(withIdentifier: "goToProfileSegue", sender: self)
        } else { // else the user is returned to the sign in view
            self.dismiss(animated: true, completion: {})
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    

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
        //search and database init
        searchBar.delegate = self
        algoliaSearchManager.getAllItems() { (escapingList) -> () in
            self.setOfItems = SaleItemCollection.init(inputList: escapingList)
        }
        //constrains the layout to the layout property attributes
        let width = ((collectionView.frame).width - leftAndRightPadding)/numberOfItemsPerRow
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
        collectionViewOriginalLocation = self.collectionView.frame.origin.y
        //addNativeExpressAds()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    /**
     
     */
    @objc func refresh(sender:AnyObject) {
        algoliaSearchManager.getAllItems() { (escapingList) -> () in
            self.setOfItems = SaleItemCollection.init(inputList: escapingList)
            self.refreshControl.endRefreshing()
        }
    }
    // MARK: - Search bar functionality
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        algoliaSearchManager.searchDatabase(searchString: searchText) {
            (escapingList) -> () in
            self.setOfItems = SaleItemCollection.init(inputList: escapingList)
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    // MARK: - Navigation Bar Hide and Show Functions
    
    /**
     A function used to hide and show the navigation bar when the user is scrolling the collectionView of this class
    */
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.setToolbarHidden(true, animated: true)

            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    /** for future commit, google add
     func addNativeExpressAds(){
     let index = 2
     let size = GADAdSizeFromCGSize(CGSize(width: 150, height: 150))
     while index < setOfItems.collectionCount {
     let adView = GADNativeExpressAdView(adSize: size)
     //Stopping Point
     //https://www.youtube.com/watch?v=chNb7-k6m4M 3:00 in
     }
     }
     */
}
