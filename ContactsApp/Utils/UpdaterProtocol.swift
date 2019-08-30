//
//  UpdaterProtocol.swift
//  ContactsApp
//
//  Created by Krishna Kishore on 08/05/19.
//  Copyright © 2019 Krishna Kishore. All rights reserved.
//

import Foundation
import UIKit

protocol Result {}

enum SuccessEvents: Result {
    case success(result: Result)
    case failure(message: String)
}

protocol UpdaterProtocol{
    func success(_ event: Result)
}

extension UpdaterProtocol where Self: UIViewController {
    
    func registerForUpdates(with viewModel: BaseViewModel) {
        weak var weakSelf = self
        
        viewModel.updater = {(result) in
            switch result {
            case .success(let result):
                weakSelf?.success(result)
            case .failure(let message):
                weakSelf?.showAlert(title: Constants.error, message: message, actions: nil)
            }
        }
    }
}


class BaseViewModel {
    var updater: ((SuccessEvents) -> Void)?
}

extension UIViewController: AlertMessageProtocol {}
