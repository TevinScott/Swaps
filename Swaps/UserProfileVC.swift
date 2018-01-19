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
    let firebaseHandle = FirebaseManager()
    
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

    // MARK: - View controller life cycle
    override func viewDidLoad(){

    }
    
    
}

