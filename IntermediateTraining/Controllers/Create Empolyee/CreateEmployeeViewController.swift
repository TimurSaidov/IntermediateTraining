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
        static let birthday = "Birthday"
        static let enterBirthday = "MM/dd/yyyy"
        static let emptyFieldsPopUpTitle = "Empty fields"
        static let emptyFieldsPopUpMessage = "Please enter all fields"
        static let invalidDatePopUpTitle = "Invalid birthday"
        static let invalidDatePopUpMessage = "Please enter birthday in a correct format: MM/dd/yyyy"
        static let executive = "Executive"
        static let senior = "Senior"
        static let staff = "Staff"
    }
    
    private enum Numbers {
        static let lightBlueViewHeight: CGFloat = 150
        static let topConstant: CGFloat = 8
        static let leftConstant: CGFloat = 16
        static let rightConstant: CGFloat = -16
        static let nameLabelWidth: CGFloat = 100
        static let nameLabelHeight: CGFloat = 50
        static let quality: CGFloat = 0.75
        static let segmentedControlHeight: CGFloat = 34
    }
    
    
    // MARK: Private Properties
    
    private let popUpManager = PopUpManager()
    
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
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.birthday
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let birthdayTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = Strings.enterBirthday
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let employeeTypeSegmentedControl: UISegmentedControl = {
        let types = [Strings.executive, Strings.senior, Strings.staff]
        let segmentedControl = UISegmentedControl(items: types)
        segmentedControl.tintColor = UIColor.darkBlue
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
    }
    
    deinit {
        print("CreateEmployeeViewController \(#function)")
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
        guard
            let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack,
            let name = nameTextField.text,
            name != String.empty,
            name != String.space,
            let birthdayText = birthdayTextField.text,
            birthdayText != String.empty,
            birthdayText != String.space,
            let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex)
            else {
                let alertController = popUpManager.makeErrorPopUp(title: Strings.emptyFieldsPopUpTitle, message: Strings.emptyFieldsPopUpMessage)
                present(alertController, animated: true, completion: nil)
                return
        }
        guard let birthday = FormatterDate.createDate(from: birthdayText) else {
            let alertController = popUpManager.makeErrorPopUp(title: Strings.invalidDatePopUpTitle, message: Strings.invalidDatePopUpMessage)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let context = coreDataStack.createContext()
        
        let employeeInformation = EmployeeInformation(context: context)
        employeeInformation.birthday = birthday
        employeeInformation.type = employeeType
        
        let employee = Employee(context: context)
        employee.name = name
        employee.company = company
        employee.employeeInformation = employeeInformation
        
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
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Numbers.leftConstant).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: Numbers.nameLabelWidth).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: Numbers.nameLabelHeight).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Numbers.leftConstant).isActive = true
        birthdayTextField.heightAnchor.constraint(equalToConstant: Numbers.nameLabelHeight).isActive = true
        
        view.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Numbers.leftConstant).isActive = true
        employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Numbers.rightConstant).isActive = true
        employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: Numbers.segmentedControlHeight).isActive = true
    }
}
