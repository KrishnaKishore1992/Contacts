//
//  ContactHelper.swift
//  ContactsApp
//
//  Created by Krishna Kishore on 08/05/19.
//  Copyright © 2019 Krishna Kishore. All rights reserved.
//

import UIKit
import Contacts

class ContactHelper {
    
    static func fetchContacts(completionHandler: @escaping ((_ contacts: [[Contact]], _ sectionTitles: [String]) -> Void)) {
        
        var contacts = [Contact]()
        let store = CNContactStore()
        let collation = UILocalizedIndexedCollation.current()
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        fetchRequest.sortOrder = CNContactSortOrder.userDefault
        
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, error) -> Void in
                
                let phoneNumbers = contact.phoneNumbers.map { Phone(label: $0.label?.replacingOccurrences(of: "_$!<", with: "").replacingOccurrences(of: ">!$_", with: ""), phoneNumber: $0.value.stringValue) }
                contacts.append(Contact(givenName: contact.givenName, familyName: contact.familyName, mobileNumbers: phoneNumbers, contactImage: UIImage(data: contact.imageData ?? Data())))
            })
            let (arrayContacts, arrayTitles) = collation.partitionObjects(array: contacts, collationStringSelector: #selector(getter: Contact.givenName))
            print(contacts)
            completionHandler(arrayContacts as? [[Contact]] ?? [], arrayTitles)
        }
            
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

extension UILocalizedIndexedCollation {
    
    func partitionObjects(array:[AnyObject], collationStringSelector:Selector) -> ([AnyObject], [String]) {
        var unsortedSections = [[AnyObject]]()
        
        //1. Create a array to hold the data for each section
        for _ in self.sectionTitles {
            unsortedSections.append([]) //appending an empty array
        }
        //2. Put each objects into a section
        for item in array {
            let index:Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        //3. sorting the array of each sections
        var sectionTitles = [String]()
        var sections = [AnyObject]()
        for index in 0 ..< unsortedSections.count { if unsortedSections[index].count > 0 {
            sectionTitles.append(self.sectionTitles[index])
            sections.append(self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as AnyObject)
            }
        }
        return (sections, sectionTitles)
    }
}
