//
//  newItemVC.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/23/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

// A View Controller that manages user interactions performed on the New Item View
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
    
    // which image is selected and which image(s) added by user
    var imageSelected = [Bool](repeating: false, count: 6)
    var imagesAdded = [Bool](repeating: false, count: 6)
    
    
    /**
     opensCamera and specifies that imageSelected at element "n" is true n = to addImgBtn(num-1)
     
     - Parameter str:   The string to repeat.
     - Parameter times: The number of times to repeat `str`.
     
     - Throws: `MyError.InvalidTimes` if the `times` parameter
     is less than zero.
     
     - Returns: A new string with `str` repeated `times` times.
     */
    @IBAction func addImgBtn1(_ sender: Any) {
        openCamera()
        imageSelected[0] = true;
    }
    /**
     opensCamera and specifies that imageSelected at element "n" is true n = to addImgBtn(num-1)
     
     - Parameter str:   The string to repeat.
     - Parameter times: The number of times to repeat `str`.
     
     - Throws: `MyError.InvalidTimes` if the `times` parameter
     is less than zero.
     
     - Returns: A new string with `str` repeated `times` times.
     */
    @IBAction func addImgBtn2(_ sender: Any) {
        openCamera()
        imageSelected[1] = true;
    }
    /**
     opensCamera and specifies that imageSelected at element "n" is true n = to addImgBtn(num-1)
     
     - Parameter str:   The string to repeat.
     - Parameter times: The number of times to repeat `str`.
     
     - Throws: `MyError.InvalidTimes` if the `times` parameter
     is less than zero.
     
     - Returns: A new string with `str` repeated `times` times.
     */
    @IBAction func addImgBtn3(_ sender: Any) {
        openCamera()
        imageSelected[2] = true;
    }
    /**
     opensCamera and specifies that imageSelected at element "n" is true n = to addImgBtn(num-1)
     
     - Parameter str:   The string to repeat.
     - Parameter times: The number of times to repeat `str`.
     
     - Throws: `MyError.InvalidTimes` if the `times` parameter
     is less than zero.
     
     - Returns: A new string with `str` repeated `times` times.
     */
    @IBAction func addImgBtn4(_ sender: Any) {
        openCamera()
        imageSelected[3] = true;
    }
    /**
     opensCamera and specifies that imageSelected at element "n" is true n = to addImgBtn(num-1)
     
     - Parameter str:   The string to repeat.
     - Parameter times: The number of times to repeat `str`.
     
     - Throws: `MyError.InvalidTimes` if the `times` parameter
     is less than zero.
     
     - Returns: A new string with `str` repeated `times` times.
     */
    @IBAction func addImgBtn5(_ sender: Any) {
        openCamera()
        imageSelected[4] = true;
    }
    /**
     opensCamera and specifies that imageSelected at element "n" is true n = to addImgBtn(num-1)
     
     - Parameter str:   The string to repeat.
     - Parameter times: The number of times to repeat `str`.
     
     - Throws: `MyError.InvalidTimes` if the `times` parameter
     is less than zero.
     
     - Returns: A new string with `str` repeated `times` times.
     */
    @IBAction func addImgBtn6(_ sender: Any) {
        openCamera()
        imageSelected[5] = true;
    }
    //MARK - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /**
     opens a camera view over the current view
     
     */
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    /**
     Repeats a string `times` times.
     
     - Parameter str:   The string to repeat.
     - Parameter times: The number of times to repeat `str`.
     
     - Throws: `MyError.InvalidTimes` if the `times` parameter
     is less than zero.
     
     - Returns: A new string with `str` repeated `times` times.
     */
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageBeingChanged = specifyImageToSet(whichImage: imageSelected)
        imageBeingChanged.image = image
        dismiss(animated:true, completion: nil)
        imageSelected = [Bool](repeating: false, count: 6) //resets imageselection
    }

    /**
     returns the specific UIImageView that is in this class
     
     - Parameter whichImage: specifics which itemImage(num) to return based on which index is true itemImage(num: index + 1)
     
     - Returns: itemImage(num) corresponding to the true element in the whichImage[] array
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







