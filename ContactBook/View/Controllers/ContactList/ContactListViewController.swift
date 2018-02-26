//
//  ContactListViewController.swift
//  ContactBook
//
//  Created by Evgenii Chopei on 2/24/18.
//  Copyright © 2018 Evgenii Chopei. All rights reserved.
//

import UIKit
import CoreData

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    
    //MARK: - Properties
    
    private var fetchController: NSFetchedResultsController<ContactModel> = {
        let fetchRequest = NSFetchRequest<ContactModel>(entityName: ContactModel.entityName)
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataCoordinator.shared.persistentContainer.viewContext, sectionNameKeyPath: "firstName", cacheName: nil)
          return fController
    }()
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupNavigationBar()
        fetchControllerFetch()
    }
    
    //MARK: Private Setup
    
    private func setupTableViewDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerCell() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Contacts"
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContactAction))
        self.navigationItem.leftBarButtonItem = addItem
        
    }
    
    //MARK: - Actions
    
    @objc private func addNewContactAction() {
        let detailedViewController = EditContactViewController.init(nibName: "ContactDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(detailedViewController, animated: true)
    }
    
    
    //MARK: - Fetch
    
    private func fetchControllerFetch() {
       fetchController.delegate = self
        do {
            try fetchController.performFetch()
        } catch {
            debugPrint("Error while fetching objects")
        }
        setupTableViewDelegate()
    }
    
    
    //MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = fetchController.object(at: indexPath)
        configureCell(cell: cell, contact: contact)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, contact: ContactModel) {
        cell.textLabel?.text = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
        if let text = cell.textLabel?.text, text == " " {
            cell.textLabel?.text = "No Name"
        }
    }
    
    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedViewController = ContactDetailViewController.init(nibName: "ContactDetailViewController", bundle: nil)
        let contact = fetchController.object(at: indexPath)
        detailedViewController.contactModel = contact
        self.navigationController?.pushViewController(detailedViewController, animated: true)
    }
    
    
    //MARK: - Fetch Controller Delegate
   
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .insert:
                if let safeIndexPath = newIndexPath {
                    tableView.insertRows(at: [safeIndexPath], with: .automatic)
                }
            case .delete:
                if let safeIndexPath = indexPath {
                    tableView.deleteRows(at: [safeIndexPath], with: .automatic)
                }
            
            case .update:
                if let safeIndexPath = indexPath {
                    tableView.reloadRows(at: [safeIndexPath], with: .automatic)
                }
            case .move:
                if let safeIndexPath = indexPath, let safeNewIndexPath = newIndexPath {
                    tableView.deleteRows(at: [safeIndexPath], with: .automatic)
                    tableView.insertRows(at: [safeNewIndexPath], with: .automatic)
                }
            }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            case .delete:
                tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            default:
                return
        }
    }
   
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
 
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()

    }
    

}
