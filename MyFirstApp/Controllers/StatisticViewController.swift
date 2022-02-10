//
//  StatisticViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/21/22.
//

import UIKit

class StatisticViewController: UIViewController {
    
    private let statisticLabel: UILabel = UILabel(font24: "STATISTICS")

    override func viewDidLoad() {
        super.viewDidLoad()

        setupVIews()
        setConstrains()
    }
    
    private func setupVIews() {
        view.backgroundColor = .specialBackground
        view.addSubview(statisticLabel)
    }
    
}

extension StatisticViewController {
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            statisticLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            statisticLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
    }
}
