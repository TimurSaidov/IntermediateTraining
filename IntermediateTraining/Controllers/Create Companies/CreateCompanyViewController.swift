//
//  CreateCompanyViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 18/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class CreateCompanyViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let createCompany = "Create Company"
        static let editCompany = "Edit Company"
        static let cancel = "Cancel"
        static let save = "Save"
        static let name = "Name"
        static let enterName = "Enter name"
        static let company = "Company"
        static let emptyCompanyImage = "select_photo_empty"
    }
    
    
    // MARK: Public Properties
    
    var delegate: CreateCompanyControllerDelegate?
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }

    
    // MARK: Private Properties
    
    private let lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var companyImageView: UIImageView = { // lazy private var - To add gesture recognize.
        let imageView = UIImageView(image: UIImage(named: Strings.emptyCompanyImage))
        imageView.isUserInteractionEnabled = true // By default image views are not interactive.
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupView()
    }
    
    deinit {
        print("CreateCompanyViewController \(#function)")
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = company == nil ? Strings.createCompany : Strings.editCompany
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
    
    private func setupView() {
        view.backgroundColor = UIColor.darkBlue
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        nameLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func createCompany() {
        guard let context = createContext() else { return }
        
//        let company = NSEntityDescription.insertNewObject(forEntityName: Strings.company, into: context)
//        company.setValue(nameTextField.text, forKey: Strings.name)
        let company = Company(context: context) // Initializes a managed object subclass and inserts it into the specified managed object context -> context.perform {...} doen't needed.
        company.name = nameTextField.text
        company.founded = datePicker.date
        
        do {
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveCompanyChanges() {
        guard
            let context = createContext(),
            let company = company
            else { return }
        
        context.perform { [weak self] in
            guard let self = self else { return }
            
            company.name = self.nameTextField.text
            company.founded = self.datePicker.date
            
            do {
                try context.save()
                
                self.dismiss(animated: true) {
                    self.delegate?.didEditCompany(company)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func createContext() -> NSManagedObjectContext? {
        guard let persistantContainer = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer else { return nil }
        return persistantContainer.viewContext
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setupNavBarColorAndTint(navigationController)
    }
}
