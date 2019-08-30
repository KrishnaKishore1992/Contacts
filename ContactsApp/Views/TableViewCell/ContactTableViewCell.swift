//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Krishna Kishore on 08/05/19.
//  Copyright © 2019 Krishna Kishore. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var userimageView: UIImageView!
    
    func updateCell(contact: Contact?) {
        
        nameLabel.text = contact?.givenName ?? "--"
        userimageView.image = contact?.contactImage ?? #imageLiteral(resourceName: "noAvatar")
        phoneNumberLabel.text = contact?.mobileNumbers.first?.phoneNumber ?? ""
    }
}
