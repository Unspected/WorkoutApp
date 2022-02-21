//
//  StatisticTableViewCell.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 2/12/22.
//

import UIKit


class StatisticTableViewCell: UITableViewCell {
    
    private let differenceLabel: UILabel = {
        let label = UILabel()
        label.text = "+2"
        label.font = .robotoMedium24()
        label.textColor = .specialGreen
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = UILabel(font24: "Biceps")
    
    private var stackView: UIStackView = UIStackView()
    
    private let beforeLabel: UILabel = UILabel(font14: "Before: 18")
    private let nowLabel: UILabel = UILabel(font14: "Now: 15")
    
    private let lineView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(differenceLabel)
        addSubview(nameLabel)
        stackView = UIStackView(arrangedSubviews: [beforeLabel, nowLabel],
                                axis: .horizontal, spacing: 3)
        addSubview(stackView)
        addSubview(lineView)
    }
    
    func CellConfigure(differenceWorkout: DifferenceWorkout) {
        
        nameLabel.text = "\(differenceWorkout.name)"
        beforeLabel.text = "Before: \(differenceWorkout.firstReps)"
        nowLabel.text = "Now: \(differenceWorkout.lastReps)"
        
        let difference = differenceWorkout.lastReps - differenceWorkout.firstReps
        differenceLabel.text = "\(difference)"
        
        switch difference {
        case ..<0:
            differenceLabel.textColor = .specialYellow
        case 1...:
            differenceLabel.text = "+\(difference)"
            differenceLabel.textColor = .specialGreen
        default:
            differenceLabel.textColor = .specialGray
        }
        
    }
    
}

extension StatisticTableViewCell {
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            differenceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            differenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            differenceLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: differenceLabel.leadingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
