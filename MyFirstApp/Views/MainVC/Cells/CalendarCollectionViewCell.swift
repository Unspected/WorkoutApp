//
//  CalendarCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/15/22.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    private var dayOfWeekLabel : UILabel = {
        let label = UILabel()
        label.text = "Mon"
        label.font = .robotoBold16()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let numberOfDayLabel : UILabel = {
        let label = UILabel()
        label.font = .robotoBold20()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func cellConfigure(numberOfDay:String, dayOfWeek:String) {
        numberOfDayLabel.text = numberOfDay
        dayOfWeekLabel.text = dayOfWeek
    }
    
    // Функция для клика на ячейку
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .specialYellow
                layer.cornerRadius = 10
                dayOfWeekLabel.textColor = .specialBlack
                numberOfDayLabel.textColor = .specialDarkGreen
            } else {
                backgroundColor = .specialGreen
                dayOfWeekLabel.textColor = .white
                numberOfDayLabel.textColor = .white
                
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
        addSubview(dayOfWeekLabel)
        addSubview(numberOfDayLabel)
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            dayOfWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayOfWeekLabel.topAnchor.constraint(equalTo: topAnchor,constant: 7),
            
        ])
        NSLayoutConstraint.activate([
            numberOfDayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberOfDayLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),
            
        ])
    }
 
}
