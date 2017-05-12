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
    static var appDelegate: AppDelegate?
    var delegate: PeopleControllerDelegate?
    static var moc: NSManagedObjectContext?
    
    // Network
    static let getRandomPeopleBaseURL = "https://randomuser.me/api/"
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init() {
        PersonController.appDelegate = UIApplication.shared.delegate as? AppDelegate
        PersonController.moc = PersonController.appDelegate?.persistentContainer.viewContext
    }
    
    //==================================================
    // MARK: - General Methods
    //==================================================
    
    func getRandomPeople(quantity: Int) {
        
        getFromAPI(quantity: quantity)
    }
    
    static func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    //==================================================
    // MARK: - CRUD Methods
    //==================================================
    
    static func createPerson(firstName: String, lastName: String, email: String, phone: String, thumbnailImageURL: String? = nil) -> Person? {
        
        guard let person = Person(firstName: firstName, lastName: lastName, email: email, phone: phone, thumbnailImageURL: thumbnailImageURL) else {
            NSLog("Error creating a new person.")
            return nil
        }
        
        PersonController.appDelegate?.saveContext()
        
        return person
    }
    
    static func deletePerson(_ person: Person) {
        
        PersonController.moc?.delete(person)
        PersonController.appDelegate?.saveContext()
    }
    
    static func getPersonByObjectID(_ objectID: String) -> Person? {
        
        guard let personObjectIDURIRep = URL(string: objectID),
            let personObjectID = PersonController.moc?.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: personObjectIDURIRep) else {
                
                NSLog("Error getting the person's object ID.")
                return nil
        }
        
        guard let person = try? PersonController.moc?.existingObject(with: personObjectID) as? Person else {
            NSLog("Error getting the person from its object ID.")
            return nil
        }
        
        return person
    }
    
    static func updatePerson(_ person: Person, firstName: String, lastName: String, email: String, phone: String, thumbnailImageURL: String? = nil) {
        
        person.firstName = firstName
        person.lastName = lastName
        person.email = email
        person.phone = phone
        person.thumbnailImageURL = thumbnailImageURL
        
        PersonController.appDelegate?.saveContext()
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
                PersonController.appDelegate?.saveContext()
                
                completion(people)
            }
        }
    }
}









