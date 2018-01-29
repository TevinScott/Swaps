//
//  EditItemVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 10/5/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
//NEEDS: revert changes button

///A View Controller that Manages the Edit Item View
class EditItemVC: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Attributes
    var fbaseDataManager = FirebaseManager()
    var algoliaHandle = AlgoliaSearchManager()
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameField: UITextField!
    @IBOutlet var itemPriceField: UITextField!
    @IBOutlet var itemDescTextView: UITextView!
    @IBOutlet var changeImgBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    var imageHasBeenChanged : Bool = false;
    var saleItem: SaleItem! = SaleItem()
    var activeTextField: UITextField!
    var activeTextView: UITextView!
    
    // MARK: - Button Actions
    /**
     Opens Camera on tap
     
     - parameters:
     - sender: the object reference of the Button that called this function
     
     */
    @IBAction func changeImageBtn(_ sender: Any) {

        //open prompt as if user would like to change current image
        //if prompt true execute below
        showCameraOrLibraryDialog()

    }
    
    /**
     delete's the sale item
     
     - parameters:
         - sender: the object reference of the Button that called this function
     */
    @IBAction func delBtnPressed(_ sender: Any) {
        algoliaHandle.deleteAlgoliaSaleItem(saleItemToDelete: saleItem)
        navigationController?.popViewController(animated: true)
    }
    
    /**
     updates the signed in user's saleItem and returns to the Feed Collection view
     
     - parameters:
         - sender: the object reference of the Button that called this function
     
     */
    @IBAction func updateBtnPressed(_ sender: Any) {
        self.updateSaleItem()
        navigationController?.popViewController(animated: true)
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
                                                message: "Would you like to replace your current Item image using your Camera or, Photo Libary?",
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
    
    // MARK: - Support Functions
    
    /**
     updates this classes saleItem attributes based on the users new input
     */
    private func updateSaleItem(){
        saleItem.name = itemNameField.text
        saleItem.price = itemPriceField.text
        saleItem.description = itemDescTextView.text
        if(imageHasBeenChanged){
            saleItem.image = itemImageView.image
        }
        algoliaHandle.updateItemIndexValues(modifiedSaleItem: saleItem, imageChanged: imageHasBeenChanged)
    }
    
    /**
     updateUI sets all outletted values within this view controller to this current values in
     the saleItem value
     */
    private func updateUI() {
        if(saleItem?.name! != nil)       { itemNameField.text = saleItem?.name!           }
        if(saleItem?.price! != nil)      { itemPriceField.text = (saleItem?.price)!       }
        if(saleItem?.description! != nil){ itemDescTextView.text = saleItem?.description! }
        if (saleItem?.image != nil)      { itemImageView.image = saleItem?.image!         }
    }
    
    /**
     updateUIFrom sets all outletted values within this view controller to this current json values in
     the saleItem value
     */
    func updateUIFromJson() {
        if(saleItem?.name != nil)       { itemNameField.text = saleItem?.name!          }
        if(saleItem?.price != nil)      { itemPriceField.text = saleItem?.price!        }
        if(saleItem?.description != nil){ itemDescTextView.text = saleItem?.description!}
        if(saleItem?.image != nil)      { itemImageView.image = saleItem?.image!        }
        itemImageView.layer.cornerRadius = 8.0
        itemImageView.clipsToBounds = true
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad(){
        updateUIFromJson()
        imageHasBeenChanged = false;
        let tapGesture = UITapGestureRecognizer(target: self, action : #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
