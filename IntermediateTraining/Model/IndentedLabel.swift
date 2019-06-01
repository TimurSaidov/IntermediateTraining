//
//  IndentedLabel.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 26/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class IndentedLabel: UILabel {
    
    
    // MARK: Overriding
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}
