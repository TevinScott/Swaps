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
    
    var viewHandle: UIViewController?
    
    init( view: UIViewController){
        viewHandle = view
    }
    
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if viewHandle?.view.frame.origin.y == 0{
                viewHandle?.view.frame.origin.y -= keyboardSize.height
            }
            else {
                viewHandle?.view.frame.origin.y = 0
                viewHandle?.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if viewHandle?.view.frame.origin.y != 0{
                viewHandle?.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
