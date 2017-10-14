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

/// Manages the Sign In View and the Google Sign In Authentication that occurs within the view
class SignInVC : UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    
    let coreDataManager: CoreDataManager = CoreDataManager.init()

    @IBAction func googleBtnTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is GIDSignInButton {
            return false
        }
        return true
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        signOut()
        coreDataManager.deleteAll()
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        FIRAuth.auth()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    // MARK: Google Sign In Functions
    
    /**
     Asks the delegate to open a resource specified by a URL, and provides a dictionary of launch options.
     
     - parameters:
     - application: Your singleton app object.
     - url:         The URL resource to open. This resource can be a network resource or a file. For information about
                     the Apple-registered URL schemes, see Apple URL Scheme Reference.
     - options:     A dictionary of URL handling options. For information about the possible keys in this dictionary and how to handle them,
                     see UIApplicationOpenURLOptionsKey. By default, the value of this parameter is an empty dictionary.
     */
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (user != nil){
            if let authentication = user.authentication {
                let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
                print("authenticating!!!!!!!!!")
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) -> Void in
                    if error != nil {
                        print("Problem at signing in with google with error : \(String(describing: error))")
                    } else if error == nil {
                        print("user successfully signed in through GOOGLE! uid:\(FIRAuth.auth()!.currentUser!.uid)")
                        print("signed in")
                        self.performSegue(withIdentifier: "goToFeed", sender: self)
                    }
                })
            }
        }
    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    private func signOut(){
        try! FIRAuth.auth()!.signOut()
        GIDSignIn.sharedInstance().signOut()
    }
    
   
    
}
