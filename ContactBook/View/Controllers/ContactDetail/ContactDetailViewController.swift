//
//  ContactDetailViewController.swift
//  ContactBook
//
//  Created by Evgenii Chopei on 2/25/18.
//  Copyright © 2018 Evgenii Chopei. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var streetAdress2TextField: UITextField!
    @IBOutlet weak var streetAdress1TextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet var textfields: [UITextField]!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
  
    //MARK: Properties
    
    var contactModel: ContactModel?
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupController()
    }
    
    private func setupController() {
        guard let contact = contactModel else {
            return
        }
        self.firstNameTextField.text = contact.firstName
        self.lastNameTextField.text = contact.lastName
        self.phoneNumberTextField.text = contact.phoneNumber
        self.cityTextField.text = contact.city
        self.stateTextField.text = contact.state
        self.streetAdress1TextField.text = contact.streetAdress1
        self.streetAdress2TextField.text = contact.streetAdress2
        self.zipCodeTextField.text = contact.zipCode
    }
    
     func setupNavBar() {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction))
        self.navigationItem.rightBarButtonItem = edit
        
    }
    
    //MARK: - Actions
    
    @objc fileprivate func editAction() {
        let edit = EditContactViewController.init(nibName: "ContactDetailViewController", bundle: nil)
        edit.contactModel = contactModel
        self.navigationController?.pushViewController(edit, animated: true)
    }


}
