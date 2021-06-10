//
//  UIViewController-ErrorAlert.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(for error: Error) {
        let alertController = UIAlertController(title: error.userVisibleTitle, message: error.userVisibleOverallDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Localizable.ok, style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
