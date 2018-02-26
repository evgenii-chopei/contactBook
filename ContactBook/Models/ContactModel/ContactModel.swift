//
//  ContactModel.swift
//  ContactBook
//
//  Created by Evgenii Chopei on 2/24/18.
//  Copyright © 2018 Evgenii Chopei. All rights reserved.
//

import Foundation
import CoreData


@objc class ContactModel: NSManagedObject, Codable {
    
    static let entityName: String = "ContactModel"
    //MARK: - Properties
    
    @NSManaged var contactID: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var streetAdress1: String?
    @NSManaged var streetAdress2: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var zipCode: String?
    
    //MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case contactID, firstName, lastName, phoneNumber, streetAdress1, streetAdress2, city, state, zipCode
    }
    
    //MARK: Init
    
    convenience init(_firstName: String?, _lastName: String?, _phoneNumber: String?, _streetAdress1: String?, _streetAdress2: String?, _city: String?, _state: String?, _zipCode: String?, context: NSManagedObjectContext) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ContactModel", in: context) else {
                fatalError("Failed to decode ContactModel!")
        }
        self.init(entity: entity, insertInto: context)
        
        self.firstName = _firstName
        self.lastName = _lastName
        self.phoneNumber = _phoneNumber
        self.streetAdress1 = _streetAdress1
        self.streetAdress2 = _streetAdress2
        self.city = _city
        self.state = _state
        self.zipCode = _zipCode
        self.contactID = String(objectID.uriRepresentation().absoluteString)
        
        
    }
    
    //MARK: - Decodable
    
     required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "ContactModel", in: managedObjectContext) else {
                fatalError("Failed to decode ContactModel!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.contactID = try values.decode(String.self, forKey: .contactID)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        self.streetAdress1 = try values.decode(String.self, forKey: .streetAdress1)
        self.streetAdress2 = try values.decode(String.self, forKey: .streetAdress2)
        self.city = try values.decode(String.self, forKey: .city)
        self.state = try values.decode(String.self, forKey: .state)
        self.zipCode = try values.decode(String.self, forKey: .zipCode)
        
    }
    
    //MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contactID, forKey: .contactID)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(streetAdress1, forKey: .streetAdress1)
        try container.encode(streetAdress2, forKey: .streetAdress2)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(zipCode, forKey: .zipCode)
    }
    

    
}

//MARK: - CodingUserInfoKey

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
