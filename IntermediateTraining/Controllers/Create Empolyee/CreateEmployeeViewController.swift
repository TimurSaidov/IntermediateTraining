//
//  CreateEmployeeViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 24/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class CreateEmployeeViewController: UIViewController {
    
    
    // MARK: Public Properties
    
    var delegate: CreateEmployeeControllerDelegate?
    var company: Company?
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let createEmployee = "Create Employee"
        static let cancel = "Cancel"
        static let name = "Name"
        static let enterName = "Enter name"
        static let save = "Save"
    }
    
    private enum Numbers {
        static let lightBlueViewHeight: CGFloat = 50
        static let topConstant: CGFloat = 8
        static let leftConstant: CGFloat = 16
        static let nameLabelWidth: CGFloat = 100
        static let nameLabelHeight: CGFloat = 50
        static let quality: CGFloat = 0.75
    }
    
    
    // MARK: Private Properties
    
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
        
        setupNavBar()
        setupUI()
    }
    
    deinit {
        print("CreateEmployeeViewController  \(#function)")
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = Strings.createEmployee
        guard let navigationController = navigationController else { return }
        setupNavBarColorAndTint(navigationController)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.cancel, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.save, style: .done, target: self, action: #selector(handleSave))
    }
    
    private func setupNavBarColorAndTint(_ navigationController: UINavigationController) {
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = UIColor.lightRed
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController.navigationBar.tintColor = .white
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        guard let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        let context = coreDataStack.createContext()
        
        let employee = Employee(context: context)
        employee.name = nameTextField.text
        employee.company = company
        
        do {
            try context.save()
            dismiss(animated: true) { [weak self] in
                self?.delegate?.didAddEmployee(employee)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .darkBlue
        
        setupLightBlueBackground(height: Numbers.lightBlueViewHeight)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Numbers.leftConstant).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: Numbers.nameLabelWidth).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Numbers.nameLabelHeight).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Numbers.leftConstant).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: Numbers.nameLabelHeight).isActive = true
    }
}
