//
//  EditItemVC+ImagePicker.swift
//  Swaps
//
//  Created by Tevin Scott on 12/29/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

/// An Extension of the EditItemVC that allows the usage of the system camera & Photo Library
extension EditItemVC: UIImagePickerControllerDelegate {
    /**
     opens the Camera View Finder view over the current view
     */
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    /**
     opens the Photo library view over the current view
     */
    func openPhotoLibrary() {
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
        imageHasBeenChanged = true;
        dismiss(animated:true, completion: nil)
        
    }
    
}
