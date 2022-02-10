//
//  DateAndRepeatView.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/19/22.
//

import UIKit

class DateAndRepeatView: UIView {
    
    private let dateLabel = UILabel(font18: "Date")
       
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.tintColor = .specialGreen
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    
    private let repeatLabel = UILabel(font18: "Repeat every 7 days")
    
    let switchButton : UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.isOn = true
        switchBtn.tintColor = .specialGreen
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.addTarget(self, action: #selector(switchBtnChanged), for: .valueChanged)
        return switchBtn
    }()
    
    
    // Функция для switcha
    @objc func switchBtnChanged() {
        print("Turn on")
    }
    
    var dateStackView = UIStackView()
    var repeatStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupVIew()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVIew() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        dateStackView = UIStackView(arrangedSubviews: [dateLabel, datePicker],
                                axis: .horizontal, spacing: 10)
        addSubview(dateStackView)
        repeatStackView = UIStackView(arrangedSubviews: [repeatLabel, switchButton],
                                      axis: .horizontal, spacing: 10)
        addSubview(repeatStackView)
        
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            dateStackView.topAnchor.constraint(equalTo: topAnchor, constant: 11)
        ])
        
        NSLayoutConstraint.activate([
            repeatStackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            repeatStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            repeatStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 5)
        ])
    }
}
