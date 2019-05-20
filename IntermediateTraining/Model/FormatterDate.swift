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
}
