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
class AccountSetupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - Class Attributes
    var userAccountInfo: UserAccountInfo!
    var firebaseDataManager: FirebaseDataManager!
    var imageAdded: Bool!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    
    // MARK: - Button Actions
    
    /**
     cancels the account creation process and returns user to the SignInView
     
     - parameters:
     - sender: the object reference of the Button that called this function
     */
    @IBAction func cancelCreationBtnPressed(_ sender: Any) {
        //signs user out of firebase and google
        signOut()
    }
    
    /**
     creates a user account and proceeds to the feed view controller
     
     - parameters:
     - sender: the object reference of the Button that called this function
     */
    @IBAction func createBtnPressed(_ sender: Any) {
        checkNameBeforeContinuing()
        
    }
    
    /**
     cancels the account creation process and returns user to the SignInView
     
     - parameters:
     - sender: the object reference of the Button that called this function
     */
    @IBAction func addImageBtnPressed(_ sender: Any) {
        if(!imageAdded){
            openCamera()
        }else{
            if(changeProfileImageDialogBox()){
                openCamera()
            }
        }
    }
    
    // MARK: - Support Functions
    /**
     checks the usernameField has a valid unique username
     
     - returns: true if the username is between 6 to 12 (inclusive) characters long AND is not already inuse by another user
     */
    private func checkFields() ->Bool {
        var answer = false;
        if((usernameField.text?.count)! >= 6 && (usernameField.text?.count)! <= 12){
            answer = true;
        }
        return answer
    }
    
    /**
     signs out user from firebase and google
     */
    private func signOut(){
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
    }
    
    /**
     shows a dialogbox prompting the user that they are about to replaces there currently set image. They have the choice to cancel the action or proceed.
     
     - Returns
     answer: true, if the user chooses to change their currently set image; false if they chose cancel
     */
    func changeProfileImageDialogBox() -> Bool {
        var answer = false
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Change Image?", message: "This will replace your current Image", preferredStyle: .alert)
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        let confirmAction = UIAlertAction(title: "Change", style: .default) { (_) in
            answer = true;
        }
        //adding textfields to our dialog box
        //adding the action to dialogbox
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
        
        return answer
    }
    
    /**
     Creates an UserAccountInfo Object using the fields within the Account Setup Item View
     
     - Returns
     SaleItem: representation of the users inputted values
     */
    private func createAccountInfoObj() -> UserAccountInfo {
        
        let newAccount: UserAccountInfo = UserAccountInfo.init(inputUserID: Auth.auth().currentUser!.uid,
                                                               inputChosenUsername: usernameField.text!,
                                                               inputNameChangeUsed: false,
                                                               inputProfileImage: profileImageView.image!)
        return newAccount
    }
    
    /**
     creates a sale item object and uploads it to Firebase database & storage
     */
    private func createAndUpload(){
        if(true/*checkAllFieldsCompleted()*/){
            let newAccount = createAccountInfoObj()
            firebaseDataManager.uploadUserInfo(userAccountInfo: newAccount)
        }else{
            // need to do a prompt overlay specifying that not all fields have been completed
        }
    }
    
    // MARK: - Camera Functions
    /**
     opens a camera view over the current view
     
     */
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    /**
     assigns the Image taking within the UIImagePickerController to a ImageView
     
     - parameters:
     -picker:   The controller object managing the image picker interface
     -info:     A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie,
     if a movie was picked.The dictionary also contains any relevant editing information.
     The keys for this dictionary are listed in Editing Information Keys.
     
     */
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImageView.image = UIImage(data: (image .jpeg(.low))!)
        imageAdded = true;
        dismiss(animated:true, completion: nil)
        
    }
    
    /**
     checks the inputted name is a valid length and has not been taken by another user in the database
     */
    private func checkNameBeforeContinuing() {
        firebaseDataManager.isNameAvailable(nameToCheckFor: usernameField.text!){ (answer) -> () in
            if(self.checkFields()){
                if(answer){
                    print("YOU MAY PROCEED")
                    self.userAccountInfo = self.createAccountInfoObj()
                    self.firebaseDataManager.uploadUserInfo(userAccountInfo: self.userAccountInfo)
                    //goToFeedFromSetup
                    
                }
                else {
                    print("USERNAME TAKEN")
                }
            }
        }
    }
    // MARK: - View controller life cycle
    override func viewDidLoad(){
        firebaseDataManager = FirebaseDataManager()
        
    }
}
