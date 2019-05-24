//
//  CompaniesTableViewCell.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 24/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class CompaniesTableViewCell: UITableViewCell {
    
    
    // MARK: Public Properties
    
    var company: Company? {
        didSet {
            if let imageData = company?.image, let founded = company?.founded, let name = company?.name {
                companyImageView.image = UIImage(data: imageData)
                companyImageView.layer.borderColor = UIColor.white.cgColor
                companyImageView.layer.borderWidth = 1
                let foundedDate = FormatterDate.df.string(from: founded)
                nameFoundedDateLabel.text = "\(name) - Founded: \(foundedDate)"
            } else if let founded = company?.founded, let name = company?.name {
                companyImageView.image = UIImage(named: Strings.emptyCompanyImage)
                let foundedDate = FormatterDate.df.string(from: founded)
                nameFoundedDateLabel.text = "\(name) - Founded: \(foundedDate)"
            } else {
                companyImageView.image = UIImage(named: Strings.emptyCompanyImage)
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let emptyCompanyImage = "select_photo_empty"
    }
    
    private enum Numbers {
        static let cornerRadius: CGFloat = 20
        static let fontSize: CGFloat = 16
        static let heightConstant: CGFloat = 40
        static let leftConstant: CGFloat = 16
        static let betweenConstant: CGFloat = 8
    }
    
    
    // MARK: Private Properties
    
    private let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Numbers.cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Numbers.fontSize)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Private
    
    private func setupUI() {
        backgroundColor = UIColor.tealColor
        
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: Numbers.heightConstant).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: Numbers.heightConstant).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: Numbers.leftConstant).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: Numbers.betweenConstant).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
