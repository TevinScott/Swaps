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

class CoreDataManager {
    let appDelegate: AppDelegate
    var context: NSManagedObjectContext 

    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func giveContext() -> NSManagedObjectContext{
        return context;
    }
    func getUser() -> GIDGoogleUser {
        var currentGoogleUser: [CDGoogleUser] = []
        let fetchedUser = NSFetchRequest<NSFetchRequestResult>(entityName: "CDGoogleUser")
        do{
            currentGoogleUser = try context.fetch(fetchedUser) as! [CDGoogleUser]
        } catch{}
        return currentGoogleUser[0].userdata as! GIDGoogleUser;
    }
    /**
    
    */
    func saveGoogleUser(signedInUser: GIDGoogleUser){
        let entity = NSEntityDescription.entity(forEntityName: "CDGoogleUser", in: context)!
        let userNSManagedObject = NSManagedObject(entity: entity, insertInto: context)
        userNSManagedObject.setValue(signedInUser, forKeyPath: "userdata")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    func deleteCurrentUser(signedInUser: CDGoogleUser){
        context.delete(signedInUser)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    
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
