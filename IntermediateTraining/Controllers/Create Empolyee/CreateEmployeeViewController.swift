//
//  CreateEmployeeViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 24/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class CreateEmployeeViewController: UIViewController {
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let createEmployee = "Create Employee"
        static let cancel = "Cancel"
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
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
}
