//
//  Person+CoreDataClass.swift
//  Random User
//
//  Created by Jeff Norton on 5/11/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import Foundation
import CoreData


public class Person: NSManagedObject {
    
    //==================================================
    // MARK: - _Properties
    //==================================================
    
    fileprivate static let kEmailKey = "email"
    fileprivate static let kFirstNameKey = "first"
    fileprivate static let kLastNameKey = "last"
    fileprivate static let kNameKey = "name"

    //==================================================
    // MARK: - Initializers
    //==================================================
    
    // Purpose: Creating instances in code
    convenience init?(firstName: String
        , lastName: String
        , email: String
        , thumbnailImageData: NSData? = nil
        , context: NSManagedObjectContext = PersistenceController.moc) {
        
        // Only get "Person" Entities
        guard let entity = NSEntityDescription.entity(forEntityName: "Person"
            , in: context) else {
                
                NSLog("Error attempting to access the entity in the context.")
                return nil
        }
        
        // Identify the context we want to put the "Song" Entity in
        self.init(entity: entity, insertInto: context)
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.thumbnailImageData = thumbnailImageData
    }
    
    // Purpose: Support creating instances from JSON
    convenience init?(dictionary: [String : Any]) {
        
        guard let name = dictionary[Person.kNameKey] as? [String : Any],
            let firstName = name[Person.kFirstNameKey] as? String,
            let lastName = dictionary[Person.kLastNameKey] as? String,
            let email = dictionary[Person.kEmailKey] as? String else {
                
                NSLog("Error creating Person instance from a dictionary.")
                return nil
        }
        
        self.init()
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}








