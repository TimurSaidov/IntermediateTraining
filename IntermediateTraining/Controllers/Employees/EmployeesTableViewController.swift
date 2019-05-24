//
//  EmployeesTableViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 24/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class EmployeesTableViewController: UITableViewController, CreateEmployeeControllerDelegate {

    
    // MARK: Public Properties
    
    var company: Company?
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let cellID = "cellID"
        static let plus = "plus"
    }
    
    
    // MARK: Private Properties
    
    private let manager = CreateManager()
    private var employees = [Employee]()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupTableView()
        fetchEmployees()
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
        createEmployeeController.delegate = self
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellID)
    }
    
    private func fetchEmployees() {
        guard let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        let context = coreDataStack.createContext()
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        do {
            employees = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath)

        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        
        return cell
    }
    
    
    // MARK: CreateEmployeeControllerDelegate
    
    func didAddEmployee(_ employee: Employee) {
        employees.append(employee)
        let newIndexPath = IndexPath(row: employees.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
