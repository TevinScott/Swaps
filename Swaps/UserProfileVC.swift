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

///A View Controller that Manages the Edit Item View
class UserProfileVC: UIViewController {
    
    let coreDataManager: CoreDataManager = CoreDataManager.init()
    @IBOutlet var signOutBtn: UIButton!
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        
    }
    
    private func signOut(){
        try! FIRAuth.auth()!.signOut()
        GIDSignIn.sharedInstance().signOut()
        coreDataManager.deleteAll()
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad(){
        roundSignOutBtnCorners()
    }
    private func roundSignOutBtnCorners(){
        signOutBtn.layer.cornerRadius = 8
        signOutBtn.layer.borderWidth = 1
        signOutBtn.layer.borderColor = UIColor(displayP3Red: 215, green: 90, blue: 74, alpha: 1).cgColor
    }
}

