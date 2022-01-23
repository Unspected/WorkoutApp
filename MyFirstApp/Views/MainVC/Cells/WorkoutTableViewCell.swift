//
//  WorkoutTableViewCell.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/17/22.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    // background Block
    private let backgroundCell : UIView = {
        let cell = UIView()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundColor = .specialBrown
        cell.layer.borderWidth = 0
        cell.layer.borderColor = .none
        cell.layer.cornerRadius = 20
        return cell
        
    }()
    
    // MARK: - Frame for Image
    private let frameForImageCell : UIView = {
        let frame = UIView()
        frame.layer.cornerRadius = 20
        frame.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9294117647, blue: 0.8862745098, alpha: 1)
        frame.translatesAutoresizingMaskIntoConstraints = false
        return frame
    }()
    
    // MARK: - Image which to contains in Frame
    private let imageCell : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "heavyItem")
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("START", for: .normal)
        button.addShadowOnView()
        button.backgroundColor = .specialYellow
        button.tintColor = .specialDarkGreen
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .robotoBold16()
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Нужно починить
    @objc private func startButtonTapped() {
        print("startButtonTapped")
    }
    
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reps: 10"
        label.font = .robotoMedium16()
        return label
    }()
    
    private let setsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sets: 2"
        label.font = .robotoMedium16()
        return label
    }()
    
    private let exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Pull Ups"
        label.font = .robotoMedium22()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Инициализация стак вью что бы поместить 2 лэйбла
    var stackVIewLabels = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        // Выделение ячейки
        selectionStyle = .none
        addSubview(backgroundCell)
        addSubview(frameForImageCell)
        addSubview(imageCell)
        addSubview(startButton)
        stackVIewLabels = UIStackView(arrangedSubviews: [repeatLabel, setsLabel],
                                  axis: .horizontal, spacing: 110)
        addSubview(stackVIewLabels)
        addSubview(exerciseNameLabel)
        
        
    }
    
    
    private func setConstrains() {
        
        // Декарация ячейки
        NSLayoutConstraint.activate([
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        // Фрэйм для картинки
        NSLayoutConstraint.activate([
            frameForImageCell.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            frameForImageCell.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 20),
            frameForImageCell.heightAnchor.constraint(equalToConstant: 70),
            frameForImageCell.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        // Картинка для фрэйма
        NSLayoutConstraint.activate([
            imageCell.centerYAnchor.constraint(equalTo: frameForImageCell.centerYAnchor),
            imageCell.centerXAnchor.constraint(equalTo: frameForImageCell.centerXAnchor),
            imageCell.widthAnchor.constraint(equalToConstant: 55),
            imageCell.heightAnchor.constraint(equalToConstant: 63)
        ])
        
        // START BUTTON CONSTRAINS
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: frameForImageCell.trailingAnchor, constant: 10),
            startButton.bottomAnchor.constraint(equalTo: backgroundCell.bottomAnchor, constant: -10),
            startButton.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            startButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // STACKVIEW ЗАКРЕПЛЕНИЯ 2 ЛЭЙБЛОВ
        NSLayoutConstraint.activate([
            stackVIewLabels.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -3),
            stackVIewLabels.leadingAnchor.constraint(equalTo: frameForImageCell.trailingAnchor, constant: 10),
            stackVIewLabels.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        // Закрепления название упражнений
        NSLayoutConstraint.activate([
            exerciseNameLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: frameForImageCell.trailingAnchor, constant: 10),
            exerciseNameLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 5)
        ])
    }
    
}
