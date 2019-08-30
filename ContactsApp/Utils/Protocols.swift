//
//  Protocols.swift
//  ContactsApp
//
//  Created by Krishna Kishore on 08/05/19.
//  Copyright © 2019 Krishna Kishore. All rights reserved.
//

import UIKit
import Contacts

enum PermissionType {
    case contacts
}

protocol AlertMessageProtocol {}

extension AlertMessageProtocol {
    
    func showAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction]? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions == nil ? alertController.addAction(UIAlertAction(title: Constants.ok , style: .default, handler: nil)) : actions?.forEach{ alertController.addAction($0) }
        
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

protocol PermissionsProtocol: class, AlertMessageProtocol {}

extension PermissionsProtocol {
    
    func requestPermission(_ permissionType: PermissionType, completionHandler: @escaping (() -> Void)) {
        switch permissionType {
        case .contacts:
            CNContactStore().requestAccess(for: .contacts) {[weak self] (isGranted, error) in
                if isGranted {
                    completionHandler()
                } else {
                    let settingsAction = UIAlertAction(title: Constants.gotoSettings, style: .default, handler: { (_) in
                        if let url = URL(string:UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    })
                    self?.showAlert(title: Constants.requestDenied, message: Constants.requestMessage, actions: [settingsAction])
                }
            }
        }
    }
}


