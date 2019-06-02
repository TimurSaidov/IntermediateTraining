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
    
    private enum Numbers {
        static let heightForHeaderView: CGFloat = 50
        static let fontSize: CGFloat = 16
    }
    
    
    // MARK: Private Properties
    
    private let manager = CreateManager()
    private var allEmployees = [[Employee]]()
    
    
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
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellID)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        let executives = companyEmployees.filter { employee -> Bool in
            return employee.employeeInformation?.type == EmployeeType.Executive.rawValue
        }
        let seniorManagement = companyEmployees.filter { employee -> Bool in
            return employee.employeeInformation?.type == EmployeeType.SeniorManagement.rawValue
        }
        let staff = companyEmployees.filter { employee -> Bool in
            return employee.employeeInformation?.type == EmployeeType.Staff.rawValue
        }
        
        allEmployees = [
            executives,
            seniorManagement,
            staff
        ]
    }
    

    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        if section == 0 {
            label.text = EmployeeType.Executive.rawValue
        } else if section == 1 {
            label.text = EmployeeType.SeniorManagement.rawValue
        } else {
            label.text = EmployeeType.Staff.rawValue
        }
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: Numbers.fontSize)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Numbers.heightForHeaderView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath)
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: Numbers.fontSize)
        cell.textLabel?.textColor = .white
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        if let birthday = employee.employeeInformation?.birthday {
            let birthdayText = FormatterDate.df.string(from: birthday)
            cell.textLabel?.text = "\(employee.name ?? " ")  \(birthdayText)"
        } else {
            cell.textLabel?.text = employee.name
        }
        
        if indexPath.row == allEmployees[indexPath.section].count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Numbers.heightForHeaderView
    }
    
    
    // MARK: CreateEmployeeControllerDelegate
    
    func didAddEmployee(_ employee: Employee) {
        var sect: Int?
        guard let empoyeeInformation = employee.employeeInformation else { return }
        if empoyeeInformation.type == EmployeeType.Executive.rawValue {
            sect = 0
        } else if empoyeeInformation.type == EmployeeType.SeniorManagement.rawValue {
            sect = 1
        } else {
            sect = 2
        }
        guard let section = sect else { return }
        allEmployees[section].append(employee)
        let row = allEmployees[section].count
        let indexPath = IndexPath(row: row - 1, section: section)
        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
