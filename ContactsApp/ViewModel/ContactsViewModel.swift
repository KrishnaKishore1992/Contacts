//
//  ContactsViewModel.swift
//  ContactsApp
//
//  Created by Krishna Kishore on 08/05/19.
//  Copyright © 2019 Krishna Kishore. All rights reserved.
//

import UIKit
import Contacts

enum ContactListEvents: Result {
    case insertNewContact(indexPath: IndexPath, isNewSectionAdded: Bool)
    case `default`
}

class ContactsViewModel: BaseViewModel, PermissionsProtocol {
    
    var contacts: [[Contact]]?
    var sectionTitles: [String]?
    
    func fetchContacts() {
        requestPermission(.contacts) {
            ContactHelper.fetchContacts(completionHandler: { [weak self] (contacts, sectionTitles) in
                guard let self = self else { return }
                self.contacts = contacts
                self.sectionTitles = sectionTitles
                self.updater?(SuccessEvents.success(result: ContactListEvents.default))
            })
        }
    }
    
    func numberOfSections() -> Int {
        return sectionTitles?.count ?? 0
    }
    
    func numberOfRowsInSection(section:Int) -> Int {
        return (contacts?[section].count) ?? 0
    }
    
    func getContactAtIndexPath(indexPath: IndexPath) -> Contact? {
        return contacts?[indexPath.section][indexPath.row]
    }
    
    func insertNewContact(contact: CNContact?) {
        
        guard let contact = contact, let contactGivenName =  contact.givenName.first else {return}
        
        var sectionIndex = (sectionTitles?.lastIndex { $0 == String(contactGivenName)})
        var isNewSectionAdded = false
        defer {
            if let sectionIndex = sectionIndex {

                let phoneNumbers = contact.phoneNumbers.map { Phone(label: $0.label?.replacingOccurrences(of: "_$!<", with: "").replacingOccurrences(of: ">!$_", with: ""), phoneNumber: $0.value.stringValue) }
                
                contacts?[sectionIndex].append(Contact(givenName: contact.givenName, familyName: contact.familyName, mobileNumbers: phoneNumbers, contactImage: UIImage(data: contact.imageData ?? Data())))
                
                contacts?[sectionIndex].sort { $0.givenName < $1.givenName }
                
                if let row = contacts?[sectionIndex].count {
                    updater?(SuccessEvents.success(result: ContactListEvents.insertNewContact(indexPath: IndexPath(row: row - 1, section: sectionIndex), isNewSectionAdded: isNewSectionAdded)))
                }
            }
        }
        
        guard sectionIndex == nil else { return }
        
        let newSectionTitle = String(contact.givenName.first!)
        (sectionTitles?.append(newSectionTitle))
        sectionTitles?.sort()
        isNewSectionAdded = true
        if let newSectionIndex = (sectionTitles?.lastIndex { $0 == String(contact.givenName.first!)}) {
            contacts?.insert([], at: newSectionIndex)
            sectionIndex = newSectionIndex
        }
    }
}
