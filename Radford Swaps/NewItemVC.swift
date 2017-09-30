//
//  newItemVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/23/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

///A view Controller that Manages the New Item View
class NewItemVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    let dataManager: DataManager = DataManager()
    //
    @IBOutlet var itemNameField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var descField: UITextView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    var imageAdded: Bool = false;
    
    
    /**
     opensCamera and specifies that imageSelected at element "n" is true n = to addImgBtn(num-1)
     
     - Parameter sender:
     
     */

    @IBAction func addImgBtn(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func uploadItemBtn(_ sender: Any) {
        createAndUpload()
    }
    
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
     */
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage

        itemImageView.image = image
        imageAdded = true;
        dismiss(animated:true, completion: nil)
                
    }
    private func checkAllFieldsCompleted() -> Bool{
        var isCompleted = false;
        if(itemNameField.text!.characters.count > 0){
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
     Description: Creates a SaleItem Object using the fields within the New Item View
     
     -returns a SaleItem representation of the users inputted values
     */
    private func createNewItemObj() -> SaleItem {
        let newItem: SaleItem = SaleItem.init()
        if(checkAllFieldsCompleted()){
            newItem.category = "All"
            newItem.description = descField.text
            newItem.image = itemImageView.image
            newItem.price = priceField.text
            newItem.name = itemNameField.text
        }
        return newItem
    }
    /**
     creates a sale item object and pploads it to the cloud storage
     */
    private func createAndUpload(){
        let newItem: SaleItem = createNewItemObj()
        dataManager.uploadSaleItemToAll(saleItem: newItem)
    }
    //MARK - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /*** Part OF Stopping Point ** let tapGesture = UITapGestureRecognizer(target: self, action : #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)

         */
    }
    /*** Stopping point *** setting up keyboard view offset
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func keyboardWillSwow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left:0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
}







