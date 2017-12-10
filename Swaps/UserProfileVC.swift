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
    let coreDataManager: CoreDataManager = CoreDataManager.init()
    @IBOutlet var signOutBtn: UIButton!
    
    /**
     Sign out the user upon recieving the button action
     
     */
    @IBAction func signOutBtnPressed(_ sender: Any) {
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
        coreDataManager.deleteAll()
    }
    
    /**
     rounds the signOutBtn's corners
     */
    private func roundSignOutBtnCorners(){
        signOutBtn.layer.cornerRadius = 8
        signOutBtn.layer.borderWidth = 1
        signOutBtn.layer.borderColor = UIColor(displayP3Red: 215, green: 90, blue: 74, alpha: 1).cgColor
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad(){
        roundSignOutBtnCorners()
    }
    
    
}

