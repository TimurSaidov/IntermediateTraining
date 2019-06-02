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
        static let reset = "Reset"
        static let doUpdatesOnBackgroundThread = "Do Updates"
    }
    
    private enum Numbers {
        static let height: CGFloat = 50
        static let viewHeight: CGFloat = 150
        static let fontSize: CGFloat = 16
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
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: Strings.reset, style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: Strings.doUpdatesOnBackgroundThread, style: .plain, target: self, action: #selector(handleDoUpdatesOnBackgroundThread))
            ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Strings.plus), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    @objc private func handleReset() {
        guard let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        let context = coreDataStack.createContext()
        
        companies.forEach { company in
            context.delete(company)
        }
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.save()
//            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .top)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func handleDoUpdatesOnBackgroundThread() {
        guard let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        let persistentContainer = coreDataStack.persistentContainer
        // Picture 1.
//        persistentContainer.performBackgroundTask { backgroundContext in
//            let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
//            fetchRequest.fetchLimit = 1
//        
//            do {
//                let companies = try backgroundContext.fetch(fetchRequest)
//                
//                companies.forEach({ company in
//                    company.name = "A: \(company.name ?? "")"
//                })
//                
//                do {
//                    try backgroundContext.save()
//                    
//                    DispatchQueue.main.async {
//                        persistentContainer.viewContext.reset()
//                        self.fetchCompanies()
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
        
        // Picture 2.
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = persistentContainer.viewContext
        
        privateContext.perform {
            let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(fetchRequest)
                
                companies.forEach({ company in
                    company.name = "A: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    try privateContext.parent?.save()
                    
                    DispatchQueue.main.async {
                        persistentContainer.viewContext.reset()
                        self.fetchCompanies()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func handleAddCompany() {
        let createCompanyController = service.createCompanyController
        createCompanyController.delegate = self
        presentCreateCompanyScreen(createCompanyController: createCompanyController)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(CompaniesTableViewCell.self, forCellReuseIdentifier: Strings.cellID)
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
    private func fetchCompanies() {
        guard let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        let context = coreDataStack.createContext()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath) as! CompaniesTableViewCell
        
        let company = companies[indexPath.row]
        cell.company = company
        
        if indexPath.row == companies.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? Numbers.viewHeight : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available ..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: Numbers.fontSize)
        return label
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let empolyeesController = service.empolyeesController
        empolyeesController.company = companies[indexPath.row]
        navigationController?.pushViewController(empolyeesController, animated: true)
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
