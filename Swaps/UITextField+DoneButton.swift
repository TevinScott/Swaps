//
//  File.swift
//  Swaps
//
//  Created by Tevin Scott on 12/23/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import UIKit
/// An Extension for the UITextField that adds a done button above the user's keyboard
extension UITextField{
    
    /**
     to use this you specify the textfield or textview you would like to have the done button be associated with
     like so: mytextfield.addDoneButtonToKeyboard. the "done" button will be displayed above the keyboard when the user
     is editing mytextfield
    */
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
