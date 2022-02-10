//
//  UILabel + Extenstions.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/19/22.
//

import UIKit

extension UILabel {
    convenience init(font14: String = "") {
        self.init()
        self.text = font14
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

extension UILabel {
    convenience init(font24: String = "") {
        self.init()
        self.text = font24
        self.font = .robotoMedium24()
        self.minimumScaleFactor = 0.5
        self.textColor = .specialGray
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


