//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 18/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let companies = "Companies"
        static let plus = "plus"
        static let cellID = "cellID"
        static let delete = "Delete"
        static let edit = "Edit"
        static let emptyCompanyImage = "select_photo_empty"
    }
    
    private enum Numbers {
        static let height: CGFloat = 50
    }
    
    
    // MARK: Private Properties
    
    private let service: ServiceAssembly
    private var companies: [Company] = []
    
    
    // MARK: Lifecycle
    
    init(service: ServiceAssembly) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        fetchCompanies()
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
        let createCompanyController = service.createCompanyController
        createCompanyController.delegate = self
        presentCreateCompanyScreen(createCompanyController: createCompanyController)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellID)
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
    private func fetchCompanies() {
        guard let persistantContainer = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer else { return }
        let context = persistantContainer.viewContext
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        
        do {
            companies = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func handleDelete(action: UITableViewRowAction, indexPath: IndexPath) {
        let company = self.companies[indexPath.row]
        // Delete from tableView.
        companies.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        // Delete from CoreData.
        guard let persistantContainer = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer else { return }
        let context = persistantContainer.viewContext
        context.delete(company)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func handleEdit(action: UITableViewRowAction, indexPath: IndexPath) {
        let createCompanyController = service.createCompanyController
        createCompanyController.delegate = self
        createCompanyController.company = companies[indexPath.row]
        presentCreateCompanyScreen(createCompanyController: createCompanyController)
    }
    
    private func presentCreateCompanyScreen(createCompanyController: CreateCompanyViewController) {
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true, completion: nil)
    }
    
    
    // MARK: TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath)
        cell.backgroundColor = UIColor.tealColor
        
        let company = companies[indexPath.row]
        
        if let imageData = company.image, let founded = company.founded, let name = company.name {
            cell.imageView?.image = UIImage(data: imageData)
            let foundedDate = FormatterDate.df.string(from: founded)
            cell.textLabel?.text = "\(name) - Founded: \(foundedDate)"
        } else if let founded = company.founded, let name = company.name {
            cell.imageView?.image = UIImage(named: Strings.emptyCompanyImage)
            let foundedDate = FormatterDate.df.string(from: founded)
            cell.textLabel?.text = "\(name) - Founded: \(foundedDate)"
        } else {
            cell.imageView?.image = UIImage(named: Strings.emptyCompanyImage)
            cell.textLabel?.text = company.name
        }
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Numbers.height
    }
    
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Numbers.height
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: Strings.delete, handler: handleDelete)
        deleteAction.backgroundColor = UIColor.lightRed
        let editAction = UITableViewRowAction(style: .normal, title: Strings.edit, handler: handleEdit)
        editAction.backgroundColor = UIColor.darkBlue
        return [deleteAction, editAction]
    }
    
    
    // MARK: CreateCompanyControllerDelegate
    
    func didAddCompany(_ company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(_ company: Company) {
        guard let row = companies.firstIndex(of: company) else { return }
        let reloadIndexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .automatic)
    }
}
