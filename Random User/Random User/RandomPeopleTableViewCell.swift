//
//  RandomPeopleTableViewCell.swift
//  Random User
//
//  Created by Jeff Norton on 5/12/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import UIKit

class RandomPeopleTableViewCell: UITableViewCell {
    
    //==================================================
    // MARK: - _Properties
    //==================================================
    
    // General
    var person: Person? {
        didSet {
            if let person = self.person {
                updateWith(person)
            }
        }
    }
    
    // Outlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var profileImageview: UIImageView!
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func updateWith(_ person: Person) {
        
        self.emailLabel.text = person.email
        self.nameLabel.text = "\(person.firstName) \(person.lastName)"
        
        if let thumbnailImageURLString = person.thumbnailImageURL {
            
            ImageController.imageForURL(urlString: thumbnailImageURLString, completion: { (image) in
                self.profileImageview.image = image
            })
        }
        
        self.phoneLabel.text = person.phone
    }
}









