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
    fileprivate static let kPictureKey = "picture"
    fileprivate static let kThumbnailImageURLKey = "thumbnail"

    //==================================================
    // MARK: - Initializers
    //==================================================
    
    // Purpose: Creating instances in code
    convenience init?(firstName: String
        , lastName: String
        , email: String
        , thumbnailImageData: NSData? = nil
        , thumbnailImageURL: String? = nil
        , context: NSManagedObjectContext? = PersonController.moc) {
        
        // Only get "Person" Entities
        guard let context = context, let entity = NSEntityDescription.entity(forEntityName: "Person"
            , in: context) else {
                
                NSLog("Error attempting to access the entity in the context.")
                return nil
        }
        
        // Identify the context in which we want to put the Entity
        self.init(entity: entity, insertInto: context)
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        
        if let thumbnailImageData = thumbnailImageData {
            self.thumbnailImageData = thumbnailImageData
        }
        
        if let thumbnailImageURL = thumbnailImageURL {
            self.thumbnailImageURL = thumbnailImageURL
        }
    }
    
    // Purpose: Support creating instances from JSON
    convenience init?(dictionary: [String : Any]) {
        
        guard let name = dictionary[Person.kNameKey] as? [String : Any],
            let firstName = name[Person.kFirstNameKey] as? String,
            let lastName = name[Person.kLastNameKey] as? String,
            let email = dictionary[Person.kEmailKey] as? String,
            let picture = dictionary[Person.kPictureKey] as? [String : Any],
            let thumbnailImageURL = picture[Person.kThumbnailImageURLKey] as? String else {
                
                NSLog("Error creating Person instance from a dictionary.")
                return nil
        }
        
        // Only get "Person" Entities
        guard let context = PersonController.moc, let entity = NSEntityDescription.entity(forEntityName: "Person"
            , in: context) else {
                
                NSLog("Error attempting to access the entity in the context.")
                return nil
        }
        
        self.init(entity: entity, insertInto: context)
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.thumbnailImageURL = thumbnailImageURL
    }
}









