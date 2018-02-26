//
//  EditContactViewController.swift
//  ContactBook
//
//  Created by Evgenii Chopei on 2/26/18.
//  Copyright © 2018 Evgenii Chopei. All rights reserved.
//

import UIKit

class EditContactViewController: ContactDetailViewController, UITextFieldDelegate {

    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDeleteButton()
        setupTextfields()
        registerForKeyboardNotifications()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Private Setup
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    private func setupTextfields() {
        textfields.forEach { (textfield) in
            textfield.isUserInteractionEnabled = true
            textfield.borderStyle = .roundedRect
            textfield.delegate = self
        }
    }
    
   private func setupDeleteButton() {
   //if there no model. It means there is Creating Contact Screen
    guard contactModel != nil else {
        return
    }
    
    self.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    self.deleteButton.isHidden = false

    }
    
    override func setupNavBar() {
            let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
            self.navigationItem.rightBarButtonItem = save
        }
        
        //MARK: - Actions
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        if let size = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            scrollView.contentInset.bottom = size.height
        }
        
    }
    
    @objc fileprivate func keyboardWillHide() {
        scrollView.contentInset.bottom = 0.0

    }
    
    @objc fileprivate func saveAction() {
            
            if let contact = contactModel,validate()  {
                contact.firstName = self.firstNameTextField.text
                contact.lastName = self.lastNameTextField.text
                contact.phoneNumber = self.phoneNumberTextField.text
                contact.city = self.cityTextField.text
                contact.state = self.stateTextField.text
                contact.streetAdress1 = self.streetAdress1TextField.text
                contact.streetAdress2 = self.streetAdress2TextField.text
                contact.zipCode = self.zipCodeTextField.text
                CoreDataCoordinator.shared.saveContact(contact: contact)
            } else if validate() {
                let contact = ContactModel(_firstName: self.firstNameTextField.text, _lastName: self.lastNameTextField.text, _phoneNumber: self.phoneNumberTextField.text, _streetAdress1: self.streetAdress1TextField.text, _streetAdress2: self.streetAdress2TextField.text, _city: self.cityTextField.text, _state: self.stateTextField.text, _zipCode: self.zipCodeTextField.text, context: CoreDataCoordinator.shared.persistentContainer.viewContext)
                CoreDataCoordinator.shared.saveContact(contact: contact)
                
            }
          _ =  self.navigationController?.popViewController(animated: true)
            
        }
    
    @objc fileprivate func deleteAction() {
            
            guard let contact = contactModel else {
                return
            }
            CoreDataCoordinator.shared.deleteContact(contact: contact)
            _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    //MARK: Validation
    
    func validate() -> Bool {
        for textfield in textfields  {
            if let empty = textfield.text?.isEmpty, empty,let placeholder =  textfield.placeholder {
                showAlert(text: placeholder + " " + "field can't be empty")
                return false
            }
        }
        return true
    }
    
    func showAlert(text: String){
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: UITextfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if let index = textfields.index(of: textField) {
            if textfields.count > index + 1 {
                textfields[index + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        return false
    }
}
