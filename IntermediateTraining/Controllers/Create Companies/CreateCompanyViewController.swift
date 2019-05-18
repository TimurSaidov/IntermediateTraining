//
//  CreateCompanyViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 18/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class CreateCompanyViewController: UIViewController {
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let createCompany = "Create Company"
        static let cancel = "Cancel"
        static let save = "Save"
        static let name = "Name"
        static let enterName = "Enter name"
        static let company = "Company"
    }
    
    
    // MARK: Public Properties
    
    var delegate: CreateCompanyControllerDelegate?

    
    // MARK: Private Properties
    
    private let lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.name
        label.translatesAutoresizingMaskIntoConstraints = false // Enable Autolayout.
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = Strings.enterName
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
        removeData()
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = Strings.createCompany
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.lightRed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.cancel, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.save, style: .done, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        guard let persistantContainer = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer else { return }
        let context = persistantContainer.viewContext
        
//        let company = NSEntityDescription.insertNewObject(forEntityName: Strings.company, into: context)
//        company.setValue(nameTextField.text, forKey: Strings.name)
        let company = Company(context: context)
        company.name = nameTextField.text
        
        do {
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.darkBlue
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        nameLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func removeData() {
        nameTextField.text = .empty
    }
}
