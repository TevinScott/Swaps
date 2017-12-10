//
//  DataManager.swift
//  organizer
//
//  Created by Tevin Scott on 1/17/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Firebase
import GoogleSignIn

/// a Composite Class that manages the saving, reading, & viewing of the CoreData Entities
class CoreDataManager {
    
    //MARK: - Attributes
    let appDelegate: AppDelegate
    var context: NSManagedObjectContext 
    
    // MARK: - Intializer
    /**
     Initializes the CoreDataManager Object
     */
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Get Data
    /**
     Returns the currently signed in user data from core data
     */
    func getUser() -> GIDGoogleUser {
        var currentGoogleUser: [CDGoogleUser] = []
        let fetchedUser = NSFetchRequest<NSFetchRequestResult>(entityName: "CDGoogleUser")
        do{
            currentGoogleUser = try context.fetch(fetchedUser) as! [CDGoogleUser]
        } catch{}
        return currentGoogleUser[0].userdata as! GIDGoogleUser;
    }
    
    // MARK: - Save Data
    /**
    Saves the GIDGoogleUser data corresponding to a user that has signed in on this device to core data.
     
     - Parameter signedInUser : the GIDGoogle User data o the user that has signed in.
     
    */
    func saveGoogleUser(signedInUser: GIDGoogleUser){
        let entity = NSEntityDescription.entity(forEntityName: "CDGoogleUser", in: context)!
        let userNSManagedObject = NSManagedObject(entity: entity, insertInto: context)
        userNSManagedObject.setValue(signedInUser, forKeyPath: "userdata")
        do {
            try context.save()
        } catch {}
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    // MARK: - Delete Data
    /**
     Deletes a signedInUser stored within this apps core data storage.
     
     - Parameter signedInUser : a reference to the CDGoogleUser that will be deleted
     
     */
    func deleteCurrentUser(signedInUser: CDGoogleUser){
        context.delete(signedInUser)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    /**
     Deletes all entities stored within this apps core data storage.
     */
    func deleteAll(){
        // Initialize Fetch Request
        let googleUserFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDGoogleUser")
        // Configure Fetch Request
        googleUserFetch.includesPropertyValues = false
        do {
            let items = try context.fetch(googleUserFetch) as! [NSManagedObject]
            
            for item in items {
                context.delete(item)
            }
            // Save Changes
            try context.save()
        } catch {

        }
    }
    
    
}
