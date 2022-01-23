//
//  UILabel + Extenstions.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/19/22.
//

import UIKit

extension UILabel {
    convenience init(extensionLabel: String = "") {
        self.init()
        self.text = extensionLabel
        self.font = .robotoMedium14()
        self.textColor = .specialLightBrown
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UILabel {
    convenience init(font18: String = "") {
        self.init()
        
        self.text = font18
        self.font = .robotoMedium18()
        self.textColor = .specialGray
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
