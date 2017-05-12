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
    let defaults = UserDefaults.standard
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var quantity: Int?
    let quantityDefaultValue = 10
    let people = [Person]()
    let personController = PersonController()
    var refreshControl = UIRefreshControl()
    
    // Keys
    let kQuantityKey = "quantity"
    
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
        
        personController.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        initializeFetchedResultsController()
        
        // Configure the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.handlePullToRefresh(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl.backgroundColor = .yellow
        self.tableView?.addSubview(self.refreshControl)
        
        if let preservedQuantity = defaults.object(forKey: kQuantityKey) as? Int {
            setQuantityValue(preservedQuantity)
        } else {
            setQuantityValue(self.quantityDefaultValue)
        }
        
        configureButtons()
        configureNavigationBar()
        configureQuantityStepper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshFetchedResults()
        tableView.reloadData()
    }
    
    //==================================================
    // MARK: - Actions & Selectors
    //==================================================
    
    @IBAction func getRandomPeopleButtonTapped(_ sender: UIButton) {
        
        if let quantity = self.quantity {
            personController.getRandomPeople(quantity: quantity)
        }
    }
    
    @IBAction func quantityStepperValueChanged(_ sender: UIStepper) {
        
        setQuantityValue(Int(sender.value))
    }
    
    func handlePullToRefresh(_ sender: UIRefreshControl) {
        
        reset(returnQuantityToDefault: false)
        
        if let quantityString = self.quantityLabel.text, let quantity = Int(quantityString) {
            personController.getRandomPeople(quantity: quantity)
        }
        
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        reset(returnQuantityToDefault: true)
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
    
    func initializeFetchedResultsController() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)
            , NSSortDescriptor(key: "lastName", ascending: true)]
        
        guard let moc = PersonController.moc else {
            NSLog("Error unwrapping the managed object context.")
            return
        }
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request
            , managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        refreshFetchedResults()
    }
    
    func refreshFetchedResults() {
        
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            NSLog("Error fetching people: \(error.localizedDescription)")
        }
    }
    
    func reset(returnQuantityToDefault: Bool) {
        
        if returnQuantityToDefault {
            setQuantityValue(self.quantityDefaultValue)
        }
        
        defaults.removeObject(forKey: kQuantityKey)
        
        guard let people = fetchedResultsController?.fetchedObjects as? [Person] else {
            
            NSLog("Error getting all people.")
            return
        }
        
        for person in people {
            PersonController.deletePerson(person)
        }
        
        refreshFetchedResults()
        self.tableView.reloadData()
    }
    
    func setQuantityValue(_ quantity: Int) {
        
        self.quantity = quantity
        defaults.set(quantity, forKey: kQuantityKey)
        quantityStepper.value = Double(quantity)
        quantityLabel.text = "\(quantity)"
    }
    
    //==================================================
    // MARK: - NSFetchedResultsControllerDelegate
    //==================================================
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>
        , didChangeSection sectionInfo: NSFetchedResultsSectionInfo
        , atIndex sectionIndex: Int
        , forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .move:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .update:
            self.tableView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>
        , didChange anObject: Any
        , at indexPath: IndexPath?
        , for type: NSFetchedResultsChangeType
        , newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath as IndexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                self.tableView.moveRow(at: indexPath as IndexPath, to: newIndexPath as IndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath as IndexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
        
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? RandomPeopleTableViewCell else {
            NSLog("Error creating an instance of RandomPeopleTableViewCell.")
            return UITableViewCell()
        }
        
        if let person = fetchedResultsController?.object(at: indexPath) as? Person {
            cell.person = person
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if let person = fetchedResultsController?.object(at: indexPath) as? Person {
                PersonController.deletePerson(person)
            }
        }
    }
}









