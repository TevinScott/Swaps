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
    
    // MARK: - Initializers
    init( view: UIScrollView){
        scrollViewHandle = view
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
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if scrollViewHandle?.frame.origin.y == 0{
                scrollViewHandle?.frame.origin.y -= keyboardSize.height
            }
            else {
                scrollViewHandle?.frame.origin.y = 0
                scrollViewHandle?.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if scrollViewHandle?.frame.origin.y != 0{
                scrollViewHandle?.frame.origin.y += keyboardSize.height
            }
        }
    }
    
}
