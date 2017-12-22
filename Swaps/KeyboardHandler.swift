//
//  KeyboardHandler.swift
//  Swaps
//
//  Created by Tevin Scott on 10/13/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit

///This Class manages the adjustment of a Given View, creating the space for the iOS Keyboard
class KeyboardHandler {
    
    // MARK: - Attributes
    var scrollViewHandle: UIScrollView?
    var parentViewHandle: UIView!
    // MARK: - Initializers
    init( view: UIScrollView){
        scrollViewHandle = view
    }
    init (scrollView: UIScrollView, parentView: UIView ){
        scrollViewHandle = scrollView
        parentViewHandle = parentView
    }
    /**
     adds the observers from the viewHandle
     */
    func addObservers(){
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: nil){
            notification in
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil){
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    /**
     removes the observers from the viewHandle
     */
    func removeObservers(){
        NotificationCenter.default.removeObserver(scrollViewHandle!)
    }
    
    func keyboardWillShow(notification:Notification){

        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = parentViewHandle.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollViewHandle!.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollViewHandle?.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollViewHandle?.contentInset = contentInset
    }
    
}
