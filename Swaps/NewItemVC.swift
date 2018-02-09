//
//  newItemVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/23/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import Firebase

///A View Controller that Manages the New Item View
class NewItemVC: UIViewController, UINavigationControllerDelegate{
    
    // MARK: - Attributes
    let cdataManager: CoreDataManager = CoreDataManager()
    let algoliaHandle = AlgoliaSearchManager()
    var imageAdded: Bool = false;
    @IBOutlet var nameField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet var addImgBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    var activeTextField: UITextField!
    var activeTextView: UITextView!
    
    // MARK: - Button Actions
    
    /**
     Opens Camera on tap

     - parameters:
         - sender: the object reference of the Button that called this function
     */
    @IBAction func addImgBtn(_ sender: Any) {
        showCameraOrLibraryDialog()
    }
    
    /**
     creates a object of the sale item and uploads it to Firebase Database & Firebase Storage for image
     
     - parameters:
         - sender: the object reference of the Button that called this function
     */
    @IBAction func uploadItemBtn(_ sender: Any) {
        createAndUpload()
    }
    
    // MARK: - Support Functions

    /**
     Checks all fields within the NewItemVC is fulfilled. this function assists the createAndUpload function
     
     - Returns
         isCompleted: true if all fields have information editted by user
     */
    private func checkAllFieldsCompleted() -> Bool{
        var isCompleted = false;
        if(nameField.text!.count > 0){
            if(descriptionTextView.text!.count > 0){
                if(priceField.text!.count > 0){
                    if(imageAdded){
                        isCompleted = true;
                    }
                }
            }
        }
        return isCompleted
    }
    
    /**
     Creates a SaleItem Object using the fields within the New Item View
     
     - Returns
         SaleItem: representation of the users inputted values
     */
    private func createNewItemObj() -> SaleItem {
        
        let newItem = SaleItem()
        
        newItem.category = "All"
        newItem.description = descriptionTextView.text
        newItem.image =  itemImageView.image
        newItem.price = priceField.text
        newItem.name = nameField.text
        newItem.creatorUserID = Auth.auth().currentUser!.uid
        //NEEDS: - intialize creation date here
        return newItem
    }
    
    /**
     shows a dialogbox prompting the user that they are about to replaces there currently set image.
     They have the choice to cancel the action or proceed.
     */
    func showCameraOrLibraryDialog(){

        //Creating UIAlertController and
        //Setting title and message for the alert dialogsho
        let alertController = UIAlertController(title: "Camera Or Libary",
                                                message: "Would you like to use an image from your Camera or Photo Libary?",
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
     creates a sale item object and uploads it to Firebase database & storage
     */
    private func createAndUpload(){
        if(true/*checkAllFieldsCompleted()*/){
            let newItem: SaleItem = createNewItemObj()
            algoliaHandle.uploadToIndex(saleItem: newItem)
            _ = navigationController?.popViewController(animated: true)
        }else{
            // need to do a prompt overlay specifying that not all fields have been completed
        }
    }
    
    //MARK: - Keyboard notification observer Methods
    
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupDescField()
        priceField.addDoneButtonToKeyboard(myAction:  #selector(priceField.resignFirstResponder))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerKeyboardNotifications()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    /**
     this deinit is used to remove the keyboard observers. removal was previously handled by the viewWillDisappear function, however the uiImagePickerController can trigger the removal prematurely.
     */
    deinit {
        deRegisterKeyboardNotifications()
    }
    //MARK: - UITextView placeholder text functions
    
    /**
     sets up the description field with a placeholder text and creating a light border around the UITextView.
     */
    private func setupDescField(){
        descriptionTextView.text = "Insert Description"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextView.layer.cornerRadius = 8;
    }
}







