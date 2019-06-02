//
//  JSONEmployee.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

struct JSONEmployee: Decodable {
    
    let name: String
    let birthday: String
    let type: String
}
