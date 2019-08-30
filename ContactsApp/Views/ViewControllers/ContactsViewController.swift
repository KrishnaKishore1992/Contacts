//
//  ContactsViewController.swift
//  ContactsApp
//
//  Created by Krishna Kishore on 08/05/19.
//  Copyright © 2019 Krishna Kishore. All rights reserved.
//

import UIKit
import ContactsUI

class ContactsViewController: UIViewController, UpdaterProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ContactsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForUpdates(with: viewModel)
        viewModel.fetchContacts()
    }
    
    @IBAction func addContactBarButtonAction(_ sender: Any) {
        
        let addContactView = CNContactViewController(forNewContact: nil)
        addContactView.delegate = self
        present(UINavigationController(rootViewController: addContactView), animated: true, completion: nil)
    }
    
    func success(_ event: Result) {
        
        guard let contactEvent = event as? ContactListEvents else {return}
        
        DispatchQueue.main.async { [weak self] in
            switch contactEvent {
            case .default:
                self?.tableView.reloadData()
            case .insertNewContact(let indexPath, let isNewSectionAdded):
                isNewSectionAdded ? self?.tableView.insertSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic) : self?.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
            }
        }
    }
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"CustomCell") as? ContactTableViewCell else { fatalError("Couldnot find the table view cell")}
        
        cell.updateCell(contact: viewModel.getContactAtIndexPath(indexPath: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles?[section] ?? ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionTitles
    }
}

extension ContactsViewController: CNContactViewControllerDelegate {
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
        viewController.dismiss(animated: true, completion: nil)
        viewModel.insertNewContact(contact: contact)
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}
