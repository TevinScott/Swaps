//
//  EditItemVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 10/5/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

///A View Controller that Manages the Edit Item View
class EditItemVC: UIViewController {
    
 // MARK: - Attributes
    var fbaseDataManager = FirebaseDataManager()
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameField: UITextField!
    @IBOutlet var itemPriceField: UITextField!
    @IBOutlet var itemDescField: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    var imageHasBeenChanged : Bool = false;
    var saleItem: SaleItem! = SaleItem()
    var keyboardHandler : KeyboardHandler!
    
    // MARK: - Button Actions
    /**
     Opens Camera on tap
     
     - parameters:
     - sender: the object reference of the Button that called this function
     
     */
    @IBAction func changeImageBtn(_ sender: Any) {
        openCamera()
        if(itemImageView.image != saleItem.image){
            print("image has been changed")
            imageHasBeenChanged = true
        }
    }
    
    /**
     delete's the sale item
     
     - parameters:
         - sender: the object reference of the Button that called this function
     
     */
    @IBAction func delBtnPressed(_ sender: Any) {
        fbaseDataManager.deleteSaleItem(saleItemToDelete: saleItem)
        _ = navigationController?.popViewController(animated: true) //needs test
    }
    
    /**
     updates the signed in user's saleItem and returns to the Feed Collection view
     
     - parameters:
         - sender: the object reference of the Button that called this function
     
     */
    @IBAction func updateBtnPressed(_ sender: Any) {
        self.updateSaleItem()
         _ = navigationController?.popViewController(animated: true) //needs test
    }
    
    // MARK: - Support Functions
    private func updateSaleItem(){
        saleItem.name = itemNameField.text
        saleItem.price = itemPriceField.text
        saleItem.description = itemDescField.text
        if(imageHasBeenChanged){
            saleItem.image = itemImageView.image
        }
        fbaseDataManager.updateDatabaseSaleItem(saleItem: saleItem, imageChanged: imageHasBeenChanged)
        //need condition for if the image has been changed
    }
    /**
     updateUI sets all outletted values within this view controller to this current values in
     the saleItem value
     */
    private func updateUI() {
        if(saleItem?.name! != nil){
            itemNameField.text = saleItem?.name!
        }
        if(saleItem?.price! != nil){
            itemPriceField.text = (saleItem?.price)!
        }
        if(saleItem?.description! != nil){
            itemDescField.text = saleItem?.description!
        }
        if (saleItem?.image != nil){
            itemImageView.image = saleItem?.image!
        }
    }
    
    /**
     opens a camera view over the current view
     */
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    /**
     assigns the Image taking within the UIImagePickerController to a ImageView
     
     - parameters:
         - picker:  The controller object managing the image picker interface.
         - info:    A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie,
                    if a movie was picked. The dictionary also contains any relevant editing information.
                    The keys for this dictionary are listed in Editing Information Keys.
     */
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        itemImageView.image = UIImage(data: (image .jpeg(.low))!)
        dismiss(animated:true, completion: nil)
        
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad(){
        updateUI()
        imageHasBeenChanged = false;
        let tapGesture = UITapGestureRecognizer(target: self, action : #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        keyboardHandler = KeyboardHandler.init(view: scrollView)
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
    
    
}
