//
//  PopUpService.swift
//  IntermediateTraining
//
//  Created by Timur Saidov on 20/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class PopUpService {
    
    
    // MARK: Private Structures
    
    private enum Strings {
        static let titleSelectPhoto = "Изменить изображение"
        static let titleDeletePhoto = "Удалить изображение"
        static let titleCancel = "Отмена"
        static let emptyCompanyImage = "select_photo_empty"
    }
    
    
    // MARK: Public
    
    func makeSelectPhotoPopUp(title: String?,
                              message: String?,
                              preferredStyle: UIAlertController.Style,
                              completionToSelectPhoto: (() -> ())?,
                              completionToDeletePhoto: (() -> ())?,
                              company: Company?,
                              companyImageView: UIImageView) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let selectPhoto = UIAlertAction(title: Strings.titleSelectPhoto, style: .default) { _ in
            completionToSelectPhoto?()
        }
        let deletePhoto = UIAlertAction(title: Strings.titleDeletePhoto, style: .destructive) { _ in
            completionToDeletePhoto?()
        }
        let cancel = UIAlertAction(title: Strings.titleCancel, style: .cancel, handler: nil)
        alertController.addAction(selectPhoto)
        if company != nil {
            if companyImageView.image != UIImage(named: Strings.emptyCompanyImage) {
                alertController.addAction(deletePhoto)
            }
        }
        alertController.addAction(cancel)
        
        return alertController
    }
}
