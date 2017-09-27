//
//  newItemVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/23/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit


class NewItemVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    
    //scrollview reference
    @IBOutlet weak var scrollView: UIScrollView!
    
    //image views for items
    
    @IBOutlet weak var itemImage1: UIImageView!
    @IBOutlet weak var itemImage2: UIImageView!
    @IBOutlet weak var itemImage3: UIImageView!
    @IBOutlet weak var itemImage4: UIImageView!
    @IBOutlet weak var itemImage5: UIImageView!
    @IBOutlet weak var itemImage6: UIImageView!
    var imageSelected = [Bool](repeating: false, count: 6)
    var imagesAdded = [Bool](repeating: false, count: 6)
    
    
    
    @IBAction func addImgBtn1(_ sender: Any) {
        openCamera()
        imageSelected[0] = true;
    }
    @IBAction func addImgBtn2(_ sender: Any) {
        openCamera()
        imageSelected[1] = true;
    }
    @IBAction func addImgBtn3(_ sender: Any) {
        openCamera()
        imageSelected[2] = true;
    }
    @IBAction func addImgBtn4(_ sender: Any) {
        openCamera()
        imageSelected[3] = true;
    }
    @IBAction func addImgBtn5(_ sender: Any) {
        openCamera()
        imageSelected[4] = true;
    }
    @IBAction func addImgBtn6(_ sender: Any) {
        openCamera()
        imageSelected[5] = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //gives access to the root known as condition in the JSON Tree
        
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageBeingChanged = specifyImageToSet(whichImage: imageSelected)
        imageBeingChanged.image = image
        dismiss(animated:true, completion: nil)
        imageSelected = [Bool](repeating: false, count: 6) //resets imageselection
    }
    
    /*
     private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
     let image = info[UIImagePickerControllerOriginalImage] as! UIImage
     //let imageBeingChanged = specifyImageToSet(whichImage: imageSelected)
     itemImage1.image = image
     print(image)
     
     }
     */
    private func specifyImageToSet(whichImage: [Bool]) -> UIImageView {
        var outputImageView : UIImageView?
        if(whichImage[0]){
            outputImageView = itemImage1
            imagesAdded[0] = true;
        }
        if(whichImage[1]){
            outputImageView = itemImage2
            imagesAdded[1] = true;
        }
        if(whichImage[2]){
            outputImageView = itemImage3
            imagesAdded[2] = true;
        }
        if(whichImage[3]){
            outputImageView = itemImage4
            imagesAdded[3] = true;
        }
        if(whichImage[4]){
            outputImageView = itemImage5
            imagesAdded[4] = true;
        }
        if(whichImage[5]){
            outputImageView = itemImage6
            imagesAdded[5] = true;
        }
        return outputImageView!
    }
    
}







