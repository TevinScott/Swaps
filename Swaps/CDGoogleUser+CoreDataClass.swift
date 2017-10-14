//
//  CDGoogleUser+CoreDataClass.swift
//  
//
//  Created by Tevin Scott on 10/13/17.
//
//

import Foundation
import CoreData
import GoogleSignIn
@objc(CDGoogleUser)
public class CDGoogleUser: NSManagedObject {

}
extension CDGoogleUser {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDGoogleUser> {
        return NSFetchRequest<CDGoogleUser>(entityName: "CDGoogleUser")
    }
    
    @NSManaged public var userdata: GIDGoogleUser?
    
}
