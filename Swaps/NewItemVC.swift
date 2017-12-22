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
class NewItemVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate {
    
    // MARK: - Attributes
    let cdataManager: CoreDataManager = CoreDataManager()
    let fbaseDataManager: FirebaseDataManager = FirebaseDataManager()
    var keyboardHandler : KeyboardHandler!
    var imageAdded: Bool = false;
    @IBOutlet var nameField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var descField: UITextView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet var addImgBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    var activeTextField: UITextField!
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
     opens a camera view over the current view
     */
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    /**
     opens a photo library view over the current view
     */
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
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
        itemImageView.image = UIImage(data: (image .jpeg(.low))!)
        imageAdded = true;
        dismiss(animated:true, completion: nil)
                
    }
    
    /**
     Checks all fields within the NewItemVC is fulfilled. this function assists the createAndUpload function
     
     - Returns
         isCompleted: true if all fields have information editted by user
     */
    private func checkAllFieldsCompleted() -> Bool{
        var isCompleted = false;
        if(nameField.text!.count > 0){
            if(descField.text!.count > 0){
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
        newItem.description = descField.text
        newItem.image =  itemImageView.image
        newItem.price = priceField.text
        newItem.name = nameField.text
        newItem.userID = Auth.auth().currentUser!.uid
        
        return newItem
    }
    
    /**
     shows a dialogbox prompting the user that they are about to replaces there currently set image. They have the choice to cancel the action or proceed.
     
     - Returns
     answer: a string stating the answer either a camera, library, or none
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
            fbaseDataManager.uploadSaleItem(inputSaleItem: newItem)
            _ = navigationController?.popViewController(animated: true)
        }else{
            // need to do a prompt overlay specifying that not all fields have been completed
        }
    }
    
    //MARK: - Keyboard notification observer Methods
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(NewItemVC.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewItemVC.keyboardWillHide),
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
        if textField == nameField {
            priceField.becomeFirstResponder()
        }
        else if textField == priceField {
            descField.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addImgBtn.isEnabled = false
        activeTextField = textField
        if textField == descField { //descField & ActiveField interchangable inside this scope
            if descField.textColor == UIColor.lightGray {
                descField.text = nil
                descField.textColor = UIColor.black
            }
        }
        scrollView.isScrollEnabled = true

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addImgBtn.isEnabled = true
        activeTextField = nil
        if descField.text.isEmpty {
            descField.text = "Insert Description"
            descField.textColor = UIColor.lightGray
        }
        scrollView.isScrollEnabled = false
    }
    
    //MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceHolderForDescField()
        nameField.delegate = self
        priceField.delegate = self
        descField.delegate = self
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
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deRegisterKeyboardNotifications()
    }

    //MARK: - UITextView placeholder text functions
    private func setupPlaceHolderForDescField(){
        descField.delegate = self
        descField.text = "Insert Description"
        descField.textColor = UIColor.lightGray
    }


    
}







