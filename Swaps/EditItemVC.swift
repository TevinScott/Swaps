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
    
    var dbManager = FirebaseDataManager()
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameField: UILabel!
    @IBOutlet var itemPriceField: UITextField!
    @IBOutlet var itemDescField: UITextView!
    
    var saleItem: SaleItem? = SaleItem()
    
    /**
     Opens Camera on tap
     
     - parameters:
     - sender: the object reference of the Button that called this function
     
     */
    @IBAction func changeImageBtn(_ sender: Any) {
        //must open camera here like in NewItem VC
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
    }
}
