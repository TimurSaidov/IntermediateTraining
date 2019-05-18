//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 18/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    
    // MARK: Private Structures
    
    enum Constant {
        static let companies = "Companies"
        static let plus = "plus"
        static let cellID = "cellID"
        
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = Constant.companies
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.lightRed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constant.plus), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func handleAddCompany() {
        
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.cellID)
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellID, for: indexPath)
        cell.backgroundColor = UIColor.tealColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

