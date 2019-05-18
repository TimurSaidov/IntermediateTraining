//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 18/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController { //, CreateCompanyControllerDelegate {
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let companies = "Companies"
        static let plus = "plus"
        static let cellID = "cellID"
    }
    
    
    // MARK: Private Properties
    
    private let createCompanyController: CreateCompanyViewController
    private let coreDataStack: CoreDataStack
    private var companies: [Company] = []
    
    
    // MARK: Lifecycle
    
    init(createCompanyController: CreateCompanyViewController, coreDataStack: CoreDataStack) {
        self.createCompanyController = createCompanyController
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        
        let persistantContainer = coreDataStack.persistentContainer
        let context = persistantContainer.viewContext
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        
        do {
            companies = try context.fetch(fetchRequest)
            print(companies)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = Strings.companies
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.lightRed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Strings.plus), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func handleAddCompany() {
//        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellID)
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
    
    // MARK: TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath)
        cell.backgroundColor = UIColor.tealColor
        
        let company = companies[indexPath.row]
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    // MARK: CreateCompanyControllerDelegate
    
//    func didAddCompany(_ company: Company) {
//        companies.append(company)
//        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
//    }
}

