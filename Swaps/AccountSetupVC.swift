//
//  AccountSetupViewController.swift
//  Swaps
//
//  Created by Tevin Scott on 11/2/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

//NEEDS: image setup and upload
///A View Controller that manages the AccountSetupView when a user signs into Swaps for the first time
class AccountSetupVC: UIViewController, UITextFieldDelegate{
    
    // MARK: - Class Attributes
    var userAccountInfo: UserAccountInfo!
    var firebaseDataManager: FirebaseDataManager!
    var imageAdded: Bool = false
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var addProfileImgBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    var activeTextField: UITextField!
    var accountCreationCompleted: Bool = false;
    // MARK: - Button Actions
    
    /**
     cancels the account creation process and returns user to the SignInView
     
     - parameters:
     - sender: the object reference of the Button that called this function
     */
    @IBAction func cancelCreationBtnPressed(_ sender: Any) {
        skipAccountSetupDialog()
    }
    
    /**
     creates a user account and proceeds to the feed view controller
     
     - parameters:
     - sender: the object reference of the Button that called this function
     */
    @IBAction func createBtnPressed(_ sender: Any) {
        validateBeforeSegue()
        
    }
    
    /**
     cancels the account creation process and returns user to the SignInView
     
     - parameters:
     - sender: the object reference of the Button that called this function
     */
    @IBAction func addImageBtnPressed(_ sender: Any) {
        showCameraOrLibraryDialog()
    }
    
    // MARK: - Support Functions
    
    /**
     Displays  dialog box over the view asking the user if they would like to set their
     profile image using the camera, Photo library or just exit the dialog box entirely.
     
     */
    func errorDialogbox(creationError: String){
        //Creating UIAlertController and setting title and message for the alert dialogsho
        let alertController = UIAlertController(title: "Invalid Account Creation",
                                                message: creationError,
                                                preferredStyle: .alert)
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (_) in }
        //adding the action to dialogbox
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    /**
     Displays  dialog box over the view asking the user if they would like to set their
     profile image using the camera, Photo library or just exit the dialog box entirely.
     
     */
    func skipAccountSetupDialog(){
        //Creating UIAlertController and setting title and message for the alert dialogsho
        let alertController = UIAlertController(title: "Skip your Account Setup?",
                                                message: "Youre About to Skip your Account Setup. Some Feature Will not be available until you have finished your account creation.",
                                                preferredStyle: .alert)
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Continue Setup", style: .cancel) { (_) in }
        let proceedAction = UIAlertAction(title: "Skip Setup", style: .default) { (_) in
            self.performSegue(withIdentifier: "goToFeedFromSetup", sender: self)
            self.userAccountInfo = self.createBasicAccount()
            self.firebaseDataManager.uploadBasicUserInfoToDatabase(userAccountInfo: self.userAccountInfo)
        }
        //adding the action to dialogbox
        alertController.addAction(cancelAction)
        alertController.addAction(proceedAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Displays  dialog box over the view asking the user if they would like to set their
     profile image using the camera, Photo library or just exit the dialog box entirely.
    
     */
    func showCameraOrLibraryDialog(){
        
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Camera Or Libary",
                                                message: "Would you like to use an image from your Camera or Photo Libary to set your profile picture?",
                                                preferredStyle: .alert)
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        //adding the action to dialogbox
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    /**
     Creates an UserAccountInfo Object using the fields within the Account Setup Item View
     
     - Returns
     SaleItem: representation of the users inputted values
     */
    private func createCompletedAccount() -> UserAccountInfo {
        
        let newAccount: UserAccountInfo = UserAccountInfo.init(inputUserID: Auth.auth().currentUser!.uid,
                                                               inputChosenUsername: usernameField.text!,
                                                               inputNameChangeUsed: false,
                                                               inputProfileImage: profileImageView.image!,
                                                               accountSetupCompleted: true)
        return newAccount
    }
    /**
     Creates an UserAccountInfo Object using the fields within the Account Setup Item View
     
     - Returns
     SaleItem: representation of the users inputted values
     */
    private func createBasicAccount() -> UserAccountInfo {
        let newAccount = UserAccountInfo.init(inputUserID: Auth.auth().currentUser!.uid,
                                                               accountSetupCompleted: false)
        return newAccount
    }
    
    /**
     checks the inputted name is a valid length and has not been taken by another user in the database
     */
    private func validateBeforeSegue() {
        if((self.usernameField.text?.count)! >= 6 && (self.usernameField.text?.count)! <= 12){
            firebaseDataManager.isNameAvailable(nameToCheckFor: usernameField.text!){ (nameAvailable) -> () in
                if(self.imageAdded){
                    if(nameAvailable){
                        self.userAccountInfo = self.createCompletedAccount()
                        self.firebaseDataManager.uploadUserInfo(userAccountInfo: self.userAccountInfo)
                        self.accountCreationCompleted = true;
                        self.performSegue(withIdentifier: "goToFeedFromSetup", sender: self)
                        
                    }
                    else if(!nameAvailable){
                        self.errorDialogbox(creationError: "The current Username is unavailable :(")
                    }
                }
                else if (!self.imageAdded){
                    self.errorDialogbox(creationError: "Profile Image has not been added")
                }
                
            }
        } else if (!((self.usernameField.text?.count)! >= 6 && (self.usernameField.text?.count)! <= 12)) {
            self.errorDialogbox(creationError: "Your username is not within 6 to 12 characters long")
        }
    }
    //MARK: - Keyboard notification observer Methods
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(AccountSetupVC.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountSetupVC.keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc fileprivate func  deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        
        if let activeTextField = activeTextField { // this method will get called even if a system generated alert with keyboard appears over the current VC.
            let _: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height - 20
            let activeTextFieldRect: CGRect? = activeTextField.frame
            let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
            if (!aRect.contains(activeTextFieldOrigin!)) {
                scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addProfileImgBtn.isEnabled = false
        activeTextField = textField
        scrollView.isScrollEnabled = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        addProfileImgBtn.isEnabled = true
        activeTextField = nil
        scrollView.isScrollEnabled = false
    }

    // MARK: - View controller life cycle
    override func viewDidLoad(){
        firebaseDataManager = FirebaseDataManager()
        usernameField.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deRegisterKeyboardNotifications()
    }
    
    
}
