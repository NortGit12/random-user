//
//  RandomPeopleViewController.swift
//  Random User
//
//  Created by Jeff Norton on 5/12/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import CoreData
import UIKit

class RandomPeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, PeopleControllerDelegate {
    
    //==================================================
    // MARK: - _Properties
    //==================================================
    
    // General
    let buttonCornerRadiusValue: CGFloat = 6.0
    let buttonBorderWidth: CGFloat = 2.0
    let buttonBorderColor: CGColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0).cgColor
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var quantity: Int?
    let quantityDefaultValue = 10
    let people = [Person]()
    let personController = PersonController()
    
    // Outlets
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var getRandomUsersButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var tableView: UITableView!
    
    //==================================================
    // MARK: - _View Lifecycle
    //==================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        setQuantityValue(self.quantityDefaultValue)
        
        configureButtons()
        configureNavigationBar()
        configureQuantityStepper()
    }
    
    //==================================================
    // MARK: - Actions & Selectors
    //==================================================
    
    @IBAction func getRandomPeopleButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func quantityStepperValueChanged(_ sender: UIStepper) {
        
        setQuantityValue(Int(sender.value))
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        setQuantityValue(self.quantityDefaultValue)
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func configureButtons() {
        
        clearButton.layer.cornerRadius = buttonCornerRadiusValue
        clearButton.layer.borderWidth = buttonBorderWidth
        clearButton.layer.borderColor = buttonBorderColor
        
        getRandomUsersButton.layer.cornerRadius = buttonCornerRadiusValue
        getRandomUsersButton.layer.borderWidth = buttonBorderWidth
        getRandomUsersButton.layer.borderColor = buttonBorderColor
    }
    
    func configureNavigationBar() {
        
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func configureQuantityStepper() {
        
        quantityStepper.autorepeat = true
        quantityStepper.minimumValue = 1
        quantityStepper.maximumValue = 25
    }
    
    func setQuantityValue(_ quantity: Int) {
        
        self.quantity = quantity
        quantityStepper.value = Double(quantity)
        quantityLabel.text = "\(quantity)"
    }
    
    //==================================================
    // MARK: - PeopleControllerDelegate
    //==================================================
    
    func peopleUpdated(people: [Person]) {
        
        self.tableView.reloadData()
    }
    
    //==================================================
    // MARK: - UITableViewDataSource
    //==================================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? RandomPeopleTableViewCell else {
            NSLog("Error creating an instance of RandomPeopleTableViewCell.")
            return UITableViewCell()
        }
        
        guard let profileImage = UIImage(named: "calvin"),
            let profileThumbnailData = UIImagePNGRepresentation(profileImage) else {
                
                return UITableViewCell()
        }
        
        let person = PersonController.createPerson(firstName: "First",
                                                   lastName: "LastName",
                                                   email: "e.mail@test.com",
                                                   thumbnailImageData: profileThumbnailData as NSData)
        
        cell.person = person
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}









