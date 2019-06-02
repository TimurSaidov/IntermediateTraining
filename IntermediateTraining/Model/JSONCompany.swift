//
//  JSONCompany.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

struct JSONCompany: Decodable {
    
    let name: String
    let founded: String
    let photoUrl: String
    var employees: [JSONEmployee]?
}
