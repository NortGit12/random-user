//
//  PersonController.swift
//  Random User
//
//  Created by Jeff Norton on 5/11/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import CoreData
import UIKit

protocol PeopleControllerDelegate {
    
    func peopleUpdated(people: [Person])
}

class PersonController {
    
    //==================================================
    // MARK: - _Properties
    //==================================================
    
    // General
    var delegate: PeopleControllerDelegate?
    
    // Network
    static let getRandomPeopleBaseURL = "https://randomuser.me/api/"
    
    //==================================================
    // MARK: - General Methods
    //==================================================
    
    func getRandomPeople(quantity: Int) {
        
        getFromAPI(quantity: quantity)
    }
    
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
    
    //==================================================
    // MARK: - Networking Methods
    //==================================================
    
    func getFromAPI(quantity: Int, people completion: @escaping (_ people: [Person]) -> Void = { _ in }) {
        
        guard let getRandomPeopleURL = URL(string: PersonController.getRandomPeopleBaseURL) else {
            NSLog("Error building the random people URL.")
            return
        }
        
        let urlParameters = ["results": "\(quantity)"]
        
        NetworkController.performRequest(for: getRandomPeopleURL, httpMethod: .Get, urlParameters: urlParameters) { (data, error) in
            
            var people = [Person]()
            
            defer {
                
                completion(people)
            }
            
            if let error = error {
                
                NSLog("Erorr: \(error.localizedDescription)")
                return
            }
            
            if let data = data
                , let responseDataString = String(data: data, encoding: .utf8) {
                
                if responseDataString.contains("error") {
                    
                    NSLog("Error: \(responseDataString)")
                    return
                }
                
                guard let arrayOfResultsDictionaries = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any]
                    else {
                        
                        NSLog("Error parsing the JSON")
                        return
                }
                
                guard let arrayOfPeopleDictionaries = arrayOfResultsDictionaries["results"] as? [[String: Any]]
                    else {
                        
                        NSLog("Error parsing the JSON")
                        return
                }
                
                _ = arrayOfPeopleDictionaries.flatMap{ Person(dictionary: $0) }
                PersistenceController.saveContext()
                
                completion(people)
            }
        }
    }
}









