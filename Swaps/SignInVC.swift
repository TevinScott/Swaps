//
//  SignInVC.swift
//  Swaps
//
//  Created by Tevin Scott on 10/12/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

//NEEDS: before segue ask user for a Username
/// Manages the Sign In View and the Google Sign In Authentication that occurs within the view
class SignInVC : UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    
    // MARK: - Attributes
    @IBOutlet var noAccountBtn: UIButton!
    let coreDataManager: CoreDataManager = CoreDataManager()
    let firebaseDataManager: FirebaseManager = FirebaseManager()
    
    // MARK: - Button Action
    /**
     begins the sign in process to Google upon recieving the button Action
     
     - parameters:
        - sender: the object reference of the Button that called this function
     */
    @IBAction func googleBtnTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - Google Sign-In Functions
    /**
     Signs in the user to Google & Firebase
     */
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        /// ****INITIAL USER IS SIGNED HERE, IF THEY CANCEL THE ACCOUNT SET UP THEY ARE STILL SIGNED IN AFTER NEEEEED FIX!!!!****
        if (user != nil){
            if let authentication = user.authentication {
                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
                Auth.auth().signIn(with: credential, completion: { (user, error) -> Void in
                    if error == nil {
                        self.firebaseDataManager.isUserSetup(userID: (Auth.auth().currentUser?.uid)!){ (answer) -> () in
                            if(answer){
                                self.performSegue(withIdentifier: "skipSetupSegueToFeed", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "goToAccountCreation", sender: self)
                            }
                        }
                    }
                })
            }
        }
    } 
    /**
     Asks the delegate to open a resource specified by a URL, and provides a dictionary of launch options.
     
     - parameters:
         - application: Your singleton app object.
         - url:         The URL resource to open. This resource can be a network resource or a file. For information about
                         the Apple-registered URL schemes, see Apple URL Scheme Reference.
         - options:     A dictionary of URL handling options. For information about the possible keys in this dictionary and how to handle them,
                         see UIApplicationOpenURLOptionsKey. By default, the value of this parameter is an empty dictionary.
     */
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noAccountBtn.titleLabel?.textAlignment = NSTextAlignment.center
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        Auth.auth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance().uiDelegate = self
    }
}
