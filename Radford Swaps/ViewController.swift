//
//  ViewController.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/21/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAnalytics
import FirebaseDatabase

class ViewController: UIViewController {
    
    let rootRef = FIRDatabase.database().reference()
    let dbManager = DataManager()

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var postViewer: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //dbManager.getAllPosts();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //gives access to the root known as condition in the JSON Tree

    }

    @IBAction func printPostsBtn(_ sender: Any) {
        dbManager.dataSync() { (listOfPosts) -> () in
            self.postViewer.text = listOfPosts
        }
        
        //doesnt post currently ***BUG - PLZ Squish***
        
    }
    @IBAction func addPostBtn(_ sender: Any) {
        if(titleField.hasText && descField.hasText){
            let newPost : [String : AnyObject] = ["title" : titleField.text as AnyObject, "message" : descField.text as AnyObject]
            rootRef.child("Posts").childByAutoId().setValue(newPost)
        }
    }
    @IBAction func deletePostBtn(_ sender: Any) {
    }
 
    
    func addPost(){
        let title = "title is T2"
        let message = "message sms2"
        //creates key vaule
        let newPost : [String : AnyObject] = ["title": title as AnyObject, "message" : message as AnyObject]
        //creates the reference to the database specifically at "Posts"
        //"Posts" is created as the parent in the hieracrchy
        // and the hashmap/dictionary "post" var is a child of "Posts"
        rootRef.child("Posts").childByAutoId().setValue(newPost)
        
        
    }
    
}

