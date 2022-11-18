//
//  UITextFieldExtensions.swift
//  BirthdayReminder
//
//  Created by Gulnaz on 24.10.2022.
//

import UIKit

extension UITextField {
    func setOnlyBottomBorder() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
