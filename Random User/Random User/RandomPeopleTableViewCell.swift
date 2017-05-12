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
    @IBOutlet weak var profileImageview: UIImageView!
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func updateWith(_ person: Person) {
        
        self.emailLabel.text = person.email
        self.nameLabel.text = "\(person.firstName) \(person.lastName)"
        
        if let profileThumbnailImageData = person.thumbnailImageData {
            self.profileImageview.image = UIImage(data: profileThumbnailImageData as Data)
        }
    }
}









