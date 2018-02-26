//
//  StorageProtocol.swift
//  ContactBook
//
//  Created by Evgenii Chopei on 2/24/18.
//  Copyright © 2018 Evgenii Chopei. All rights reserved.
//

import Foundation



protocol StorageProtocol {
    
    func saveContact(contact: ContactModel)
    func deleteContact(contact: ContactModel)
    
}
