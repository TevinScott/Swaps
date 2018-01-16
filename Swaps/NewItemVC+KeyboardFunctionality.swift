//
//  NewItemVC+KeyboardFunctionality.swift
//  Swaps
//
//  Created by Tevin Scott on 12/23/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
/// Extends the NewItemVC Class to better handle shifting the scrollview to fit the keyboard without obstructing any text fields or text Views
extension NewItemVC: UITextFieldDelegate , UITextViewDelegate {
    
    /**
     sets the textfields & textView delegates to this class
    */
    func setDelegates(){
        nameField.delegate = self
        priceField.delegate = self
        descriptionTextView.delegate = self
        
    }
    // MARK: - Add & Remove Keyboard Observer Functions
    /**
     registers the keyboard Notifications to this view controller.
    */
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    /**
     deregisters the keyboard Notifications from this view controller.
     */
    func  deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    // MARK: - Keyboard Show & Hide Behaviors
    /**
     this function is called when the NSNotification UIKeyboardDidShow is sent, upon which this function offsets the scrollview to
     accomodate this keyboard within the view.
     
     - parameters:
        - notification: the object that is sent when the keyboard appears within the New Item View. the notification object contains the size of the keyboard that is currently present within this view.
    */
    @objc fileprivate func keyboardDidShow(notification: NSNotification) {
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
        if let activeTextView = activeTextView { // this method will get called even if a system generated alert with keyboard appears over the current VC.
            let _: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height - 20
            let activeTextViewRect: CGRect? = activeTextView.frame
            let activeTextViewOrigin: CGPoint? = activeTextViewRect?.origin
            if (!aRect.contains(activeTextViewOrigin!)) {
                scrollView.scrollRectToVisible(activeTextViewRect!, animated:true)
            }
        }
    }
    
    /**
     this function is called when the NSNotification UIKeyboardDidHide is sent, upon which this function resets the scrollview to the original y-origin.
     
     - parameters:
     - notification: the object that is sent when the keyboard appears within the New Item View. the notification object contains the size of the keyboard that has just been hidden within this view.
    */
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - TextField & TextView Return Key Function

    /**
     this function modifies the return key behavior to cause it to step to the next textfield
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            priceField.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
        }
        
        return true
    }
    /**
     this function modifies the return key behavior when editing a UITextView, causing the keyboard to close.
     */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    // MARK: - Fields & Views Begin Editing
    
    /**
     when any UITextfield in this view is selected this function is called. This function disables the addImgBtn, sets the activeTextfield to whatever textfield is currently selected by the user, and enables scrolling for this View's scrollView
    */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addImgBtn.isEnabled = false
        activeTextField = textField
        scrollView.isScrollEnabled = true
        
    }
    /**
     when any UITextView in this view is selected this function is called. This function disables the addImgBtn, sets the activeTextView to whatever textView is currently selected by the user, and enables scrolling for this View's scrollView
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        addImgBtn.isEnabled = false
        activeTextView = descriptionTextView
        scrollView.isScrollEnabled = true
        
        if textView == descriptionTextView { //descField & ActiveField interchangable inside this scope
            if descriptionTextView.textColor == UIColor.lightGray {
                descriptionTextView.text = nil
                descriptionTextView.textColor = UIColor.black
            }
        }
    }
    
    // MARK: - Fields & Views End Editing
    
    /**
     when editing of the textfields ends in this view, this function is called. This function enables the addImgBtn, sets the activeTextfield to nil, and disnables scrolling for this View's scrollView
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        addImgBtn.isEnabled = true
        activeTextField = nil
        scrollView.isScrollEnabled = false
    }
    
    /**
     when editing of the textView ends in this view, this function is called. This function enables the addImgBtn, sets the activeTextView to nil, and disnables scrolling for this View's scrollView
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        addImgBtn.isEnabled = true
        activeTextView = nil
        scrollView.isScrollEnabled = false
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Insert Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
}
