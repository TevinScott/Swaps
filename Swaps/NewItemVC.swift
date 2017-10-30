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
    @IBOutlet var scrollView: UIScrollView!
    
    
    
    // MARK: - Button Actions
    /**
     Opens Camera on tap

     - parameters:
         - sender: the object reference of the Button that called this function
 
     */
    @IBAction func addImgBtn(_ sender: Any) {
        if(imageAdded){
            //open prompt
            if(showInputDialog()){
                openCamera()
            }
        }else{
            openCamera()
        }
        
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
        if(nameField.text!.characters.count > 0){
            if(descField.text!.characters.count > 0){
                if(priceField.text!.characters.count > 0){
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
        
        let newItem: SaleItem = SaleItem()
        
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
     answer: true, if the user chooses to change their currently set image; false if they chose cancel
     */
     func showInputDialog() -> Bool {
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
    
    //MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action : #selector(didTapView(gesture:)))  
        view.addGestureRecognizer(tapGesture)
        keyboardHandler = KeyboardHandler.init(view: scrollView)
        setupPlaceHolderForDescField()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.addObservers()
     }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.removeObservers()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
   
    //MARK: - UITextView placeholder text functions
    private func setupPlaceHolderForDescField(){
        descField.delegate = self
        descField.text = "Insert Description"
        descField.textColor = UIColor.lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Insert Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
}







