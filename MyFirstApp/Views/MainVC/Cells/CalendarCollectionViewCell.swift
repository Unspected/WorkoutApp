//
//  CalendarCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/15/22.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    private var dayOfWeek : UILabel = {
        let label = UILabel()
        label.text = "Mon"
        label.font = .robotoBold16()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    func setLabelDayOfWeek(name: String = "Mon") {
        dayOfWeek.text = name
        
    }
    
    private let numberOfDay : UILabel = {
        let label = UILabel()
        label.font = .robotoBold20()
        label.text = "29"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Функция для клика на ячейку
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .specialYellow
                layer.cornerRadius = 10
                dayOfWeek.textColor = .specialBlack
                numberOfDay.textColor = .specialDarkGreen
            } else {
                backgroundColor = .specialGreen
                dayOfWeek.textColor = .white
                numberOfDay.textColor = .white
                
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstrains()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(dayOfWeek)
        addSubview(numberOfDay)
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            dayOfWeek.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayOfWeek.topAnchor.constraint(equalTo: topAnchor,constant: 7),
            
        ])
        NSLayoutConstraint.activate([
            numberOfDay.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberOfDay.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),
            
        ])
    }
 
}
