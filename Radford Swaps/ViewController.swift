//
//  ViewController.swift
//  Radford Swaps
//
//  Created by Tevin Scott on 9/21/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//
//***NOT FOR FINAL BUILD***
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
    
    @IBOutlet var imageForUpload: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    

    @IBAction func uploadImgBtn(_ sender: Any) {
        if(titleField.text!.characters.count > 0){
            //dbManager.uploadImage(imageParam: imageForUpload.image!, name: titleField.text!)
        }
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
    
    /**
     Desc: print posts that are currently in the database
     
     -parameter
     
     -returns 
     */
    @IBAction func printPostsBtn(_ sender: Any) {
        dbManager.dataSync() { (listOfPosts) -> () in
            self.postViewer.text = listOfPosts
        }
        
        //doesnt post currently ***BUG - PLZ Squish***
        
    }
    /**
     Desc:
     
     @param
     
     @return
     */
    @IBAction func addPostBtn(_ sender: Any) {
        if(titleField.hasText && descField.hasText){
            let newPost : [String : AnyObject] = ["title" : titleField.text as AnyObject, "message" : descField.text as AnyObject]
            rootRef.child("Posts").childByAutoId().setValue(newPost)
        }
    }
    /**
     Desc:
     
     @param
     
     @return
     */
    @IBAction func deletePostBtn(_ sender: Any) {
    
    }
 
    /**
     Desc:
     
     @param
     
     @return
     */
    
    
}

