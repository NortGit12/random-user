//
//  PersonController.swift
//  Random User
//
//  Created by Jeff Norton on 5/11/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import CoreData
import Foundation

protocol PeopleControllerDelegate {
    
    func peopleUpdated(people: [Person])
}

class PersonController {
    
    //==================================================
    // MARK: - CRUD Methods
    //==================================================
    
    static func createPerson(firstName: String, lastName: String, email: String, thumbnailImageData: NSData? = nil) -> Person? {
        
        guard let person = Person(firstName: firstName, lastName: lastName, email: email, thumbnailImageData: thumbnailImageData) else {
            NSLog("Error creating a new person.")
            return nil
        }
        
        PersistenceController.saveContext()
        
        return person
    }
    
    static func deletePerson(_ person: Person) {
        
        PersistenceController.moc.delete(person)
        PersistenceController.saveContext()
    }
    
    static func getPersonByObjectID(_ objectID: String) -> Person? {
        
        guard let personObjectIDURIRep = URL(string: objectID),
            let personObjectID = PersistenceController.moc.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: personObjectIDURIRep) else {
                
                NSLog("Error getting the person's object ID.")
                return nil
        }
        
        guard let person = try? PersistenceController.moc.existingObject(with: personObjectID) as? Person else {
            NSLog("Error getting the person from its object ID.")
            return nil
        }
        
        return person
    }
    
    static func updatePerson(_ person: Person, firstName: String, lastName: String, email: String, thumbnailImageData: NSData? = nil) {
        
        person.firstName = firstName
        person.lastName = lastName
        person.email = email
        person.thumbnailImageData = thumbnailImageData
        
        PersistenceController.saveContext()
    }
}









