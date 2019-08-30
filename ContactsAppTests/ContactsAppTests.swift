//
//  ContactsAppTests.swift
//  ContactsAppTests
//
//  Created by Krishna Kishore on 08/05/19.
//  Copyright © 2019 Krishna Kishore. All rights reserved.
//

import XCTest
import Contacts
@testable import ContactsApp

class ContactsAppTests: XCTestCase, PermissionsProtocol {
    
    var contactViewModel: ContactsViewModel?
    
    override func setUp() {
        contactViewModel = ContactsViewModel()
        contactViewModel?.updater = { result in
            switch result {
            case .success(let result):
                XCTAssertTrue(true)
            case .failure(let message):
                XCTAssertTrue(!message.isEmpty)
            }
        }
    }
    
    override func tearDown() {
        contactViewModel = nil
    }
    
    func testFetchContacts() {
        contactViewModel?.fetchContacts()
    }
    
    func testNumberOfSections() {
        
        XCTAssertTrue(contactViewModel?.numberOfSections() == 0)
        contactViewModel?.fetchContacts()
        let result = contactViewModel?.numberOfSections()
        XCTAssertTrue(contactViewModel?.sectionTitles?.count == result)
    }
    
    func testNumberOfRowsInSection() {
        
        XCTAssertTrue(contactViewModel?.numberOfRowsInSection(section: 3) == 0)
        contactViewModel?.fetchContacts()
        let result = contactViewModel?.numberOfRowsInSection(section: 0)
        XCTAssertTrue(contactViewModel?.contacts?.first?.count == result)
    }
    
    func testGetContactAtIndexPath() {
        XCTAssertTrue(contactViewModel?.getContactAtIndexPath(indexPath: IndexPath(row: 0, section: 0)) == nil)
        contactViewModel?.fetchContacts()
        let result = contactViewModel?.numberOfRowsInSection(section: 0)
        if  result != nil {
            XCTAssertTrue(contactViewModel?.getContactAtIndexPath(indexPath: IndexPath(item: 0, section: 0)) != nil)
        }
    }
    
    func testInsertContact() {
        contactViewModel?.fetchContacts()
        let mockCNContact = CNMutableContact()
        mockCNContact.givenName = "A"
        let numberOfrows = contactViewModel?.numberOfRowsInSection(section: 0)
        contactViewModel?.insertNewContact(contact: mockCNContact)
        XCTAssertTrue(numberOfrows != contactViewModel?.numberOfRowsInSection(section: 0))
    }
}
