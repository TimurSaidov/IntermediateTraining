//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 18/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: Private Structures
    
    enum Constant {
        static let companies = "Companies"
        static let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
        static let plus = "plus"
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupView()
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = Constant.companies
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Constant.lightRed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constant.plus), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func handleAddCompany() {
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
}

