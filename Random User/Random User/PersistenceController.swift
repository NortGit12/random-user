//
//  PersistenceController.swift
//  Random User
//
//  Created by Jeff Norton on 5/11/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import UIKit

class PersistenceController {
    
    //==================================================
    // MARK: - _Properties
    //==================================================
    
    static let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    static func saveContext() {
        
        do {
            try PersistenceController.moc.save()
        } catch let error as NSError {
            NSLog("Error saving the context: \(error.localizedDescription)")
        }
    }
}









