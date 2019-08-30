//
//  Contact.swift
//  ContactsApp
//
//  Created by Krishna Kishore on 08/05/19.
//  Copyright © 2019 Krishna Kishore. All rights reserved.
//

import UIKit

class Phone: NSObject {
    var label: String?
    var phoneNumber: String
    
    init(label: String?, phoneNumber: String) {
        self.label = label
        self.phoneNumber = phoneNumber
    }
}

@objc class Contact: NSObject {
    @objc var givenName: String
    var familyName: String
    var mobileNumbers: [Phone]
    var contactImage: UIImage?
    
    init(givenName: String, familyName: String, mobileNumbers: [Phone], contactImage: UIImage?) {
        self.givenName = givenName
        self.familyName = familyName
        self.mobileNumbers = mobileNumbers
        self.contactImage = contactImage
    }
}
