//
//  UITextField + Extensions.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 2/5/22.
//

import UIKit

extension UITextField {
    
    convenience init(keyBoard: UIKeyboardType = .default) {
        self.init()
        self.backgroundColor = .specialBrown
        self.borderStyle = .none
        self.layer.cornerRadius = 10
        self.textColor = .specialGray
        self.font = .robotoBold20()
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftViewMode = .always
        self.clearButtonMode = .always
        self.returnKeyType = .done
        // ТОЛЬКО ЧИСЛА
        self.keyboardType = keyBoard
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
