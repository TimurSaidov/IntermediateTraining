//
//  CompaniesAutoUpdateTableViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    // MARK: Private Structures
    
    private enum Strings {
        static let companies = "Companies"
        static let cellID = "cellID"
        static let companyName = "name"
        static let reset = "Reset"
    }
    
    private enum Numbers {
        static let height: CGFloat = 50
        static let fontSize: CGFloat = 16
    }
    
    
    // MARK: Private Properties
    
    private lazy var fetchedResultController: NSFetchedResultsController<Company> = {
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: Strings.companyName, ascending: true)
        ]
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.createContext()
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: Strings.companyName, cacheName: nil)
        
        do {
            try frc.performFetch()
        } catch let error {
            print(error)
        }
        
        frc.delegate = self
        
        return frc
    }()
    private let networkManager: NetworkManager
    private let service: ServiceAssembly
    private lazy var refControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    
    // MARK: Lifecycle
    
    init(networkManager: NetworkManager, service: ServiceAssembly) {
        self.networkManager = networkManager
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.reset, style: .plain, target: self, action: #selector(handleDelete))
    }
    
    @objc private func handleDelete() {
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        
        guard let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        let context = coreDataStack.createContext()
        
        let companies = try? context.fetch(fetchRequest)
        companies?.forEach({ company in
            context.delete(company)
        })
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(CompaniesTableViewCell.self, forCellReuseIdentifier: Strings.cellID)
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.addSubview(refControl)
    }
    
    @objc private func handleRefresh() {
        navigationItem.leftBarButtonItem?.isEnabled = false
        networkManager.downloadCompaniesFromServer { [weak self] in
            guard let self = self else { return }
            self.refControl.endRefreshing()
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = .lightBlue
        label.text = fetchedResultController.sections![section].name
        label.font = UIFont.boldSystemFont(ofSize: Numbers.fontSize)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Numbers.height
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath) as! CompaniesTableViewCell
        
        let company = fetchedResultController.object(at: indexPath)
        cell.company = company

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Numbers.height
    }
    
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let empolyeesController = service.empolyeesController
        empolyeesController.company = fetchedResultController.object(at: indexPath)
        navigationController?.pushViewController(empolyeesController, animated: true)
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
}
