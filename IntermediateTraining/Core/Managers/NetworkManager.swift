//
//  NetworkManager.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class NetworkManager {
    
    
    // MARK: Public Properties
    
    static let shared = NetworkManager()
    
    
    // MARK: Private Properties
    
    private let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    
    // MARK: Public
    
    func downloadCompaniesFromServer(completionHandler: @escaping () -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8))
            do {
                let jsonCompanies = try JSONDecoder().decode([JSONCompany].self, from: data)
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataStack.shared.createContext()
                
                jsonCompanies.forEach({ jsonCompany in
                    guard let url = URL(string: jsonCompany.photoUrl) else { return }
                    let imageData = try? Data(contentsOf: url)
                    
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    company.founded = FormatterDate.createDate(from: jsonCompany.founded)
                    company.image = imageData
                    
                    jsonCompany.employees?.forEach({ jsonEmployee in
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        employeeInformation.birthday = FormatterDate.createDate(from: jsonEmployee.birthday)
                        employeeInformation.type = jsonEmployee.type
                        employee.employeeInformation = employeeInformation
                        employee.company = company
                    })
                })
                
                do {
                    try privateContext.save()
                    try privateContext.parent?.save()
                    
                    DispatchQueue.main.async {
                        completionHandler()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
