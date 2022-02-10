//
//  WorkoutTableViewCell.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/17/22.
//

import UIKit


protocol StartWorkoutProtocol : AnyObject {
    
    func startButtonTapped(model : WorkoutModel)
    
}

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
    private var imageCell : UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "heavyItem")
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
    
    // Название упражнения
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Pull Ups"
        label.font = .robotoMedium22()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var workoutModel = WorkoutModel()
    // Нужно починить
    @objc private func startButtonTapped() {
        cellStartWorkoutDelegate?.startButtonTapped(model: workoutModel)
    }
    
    // Заполняем модель данными из полей
    func cellConfigure(model: WorkoutModel) {
        
        // Передаем сюда нашу модель
        workoutModel = model
        workoutNameLabel.text = model.workoutName
        
        let (min, sec) = { (secs: Int) -> (Int, Int) in
                    return (secs / 60, secs % 60) }(Int(model.workoutTimer))
        
        repeatLabel.text = (model.workoutTimer == 0 ? "Reps: \(model.workoutReps)" : "Timer: \(min) min \(sec) sec")
        setsLabel.text = "Sets: \(model.workoutSets)"
        
        guard let imageData = model.workoutImage else { return }
        guard let image = UIImage(data: imageData) else { return }
        imageCell.image = image
        
        // Если статус ставиться true, тогда изменяем кнопку на Complete и ставим статус isEnabled
        if model.status {
            startButton.setTitle("COMPLETE", for: .normal)
            startButton.tintColor = .white
            startButton.backgroundColor = .specialGreen
            startButton.isEnabled = false
        } else {
            startButton.setTitle("START", for: .normal)
            startButton.tintColor = .specialDarkGreen
            startButton.backgroundColor = .specialYellow
            startButton.isEnabled = true
        }
        
    }
    
    // Инициализация стак вью что бы поместить 2 лэйбла
    var stackVIewLabels = UIStackView()
    
    weak var cellStartWorkoutDelegate: StartWorkoutProtocol?
    
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
                                  axis: .horizontal, spacing: 13)
        addSubview(stackVIewLabels)
        addSubview(workoutNameLabel)
        
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
            workoutNameLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            workoutNameLabel.leadingAnchor.constraint(equalTo: frameForImageCell.trailingAnchor, constant: 10),
            workoutNameLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 5)
        ])
    }
    
}
