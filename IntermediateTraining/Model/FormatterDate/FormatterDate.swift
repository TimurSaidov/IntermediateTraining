//
//  FormatterDate.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 20/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

class FormatterDate {
    static let df: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
    static func createDate(from dateText: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: dateText)
        
        return date
    }
}
