//
//  EmployeesTableViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 24/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class EmployeesTableViewController: UITableViewController {

    
    // MARK: Public Properties
    
    var company: Company?
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let plus = "plus"
    }
    
    
    // MARK: Private Properties
    
    private let manager = CreateManager()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupTableView()
    }
    
    deinit {
        print("EmployeesTableViewController \(#function)")
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = company?.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Strings.plus), style: .plain, target: self, action: #selector(handleAddEmployee))
    }
    
    @objc private func handleAddEmployee() {
        let createEmployeeController = manager.createEmployeeController
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
    }
    

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
}
