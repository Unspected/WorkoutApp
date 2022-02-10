//
//  StartWorkoutViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/26/22.
//

import UIKit
import SwiftUI



class RepsWorkoutViewController: UIViewController {
    
    private let closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private var startWorkoutLabel: UILabel = UILabel(font24: "START WORKOUT")
     //Woman for Reps and Ellipce for Timer
    let mainBackGroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "SportWoman")
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let detailsLabel: UILabel = UILabel(font14: "Details")
    
    // MARK: - Details Form
    private lazy var setDetailWorkoutForm = detailWorkoutForm as! DetailsWorkoutForm
    
    private var detailWorkoutForm: UIView = DetailsWorkoutForm()
    private var numberOfSet = 1
    
    
    private let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("FINISH", for: .normal)
        button.titleLabel?.font = .robotoMedium16()
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func finishButtonTapped() {
        // Добавить количество сетс NumberOfSets
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true, completion: nil)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel, bool: true)
        } else {
            
            alertOkCancel(title: "Warning", message: "You have not finish your excercise") {
                self.dismiss(animated: true, completion: nil)
            }
    }}
    
    var workoutModel = WorkoutModel()
    let customAlert = CustomAlert()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        setConstrains()
        setupWorkoutModel()
        setDelegates()

    }
    
    private func setDelegates() {
        setDetailWorkoutForm.nextButtonDelegate = self
    }
    
    private func setupViews() {
        
        view.backgroundColor = .specialBackground
        view.addSubview(closeButton)
        view.addSubview(startWorkoutLabel)
        view.addSubview(mainBackGroundImage)
        view.addSubview(detailsLabel)
        view.addSubview(detailWorkoutForm)
        view.addSubview(finishButton)
        
    }
    //ПЕРЕДАЧИ ДАННЫХ С МОДЕЛИ В ПОЛЯ
    private func setupWorkoutModel() {
        setDetailWorkoutForm.titleNameExcercise.text = workoutModel.workoutName
        setDetailWorkoutForm.setsCountLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        setDetailWorkoutForm.repsCountLabel.text = "\(workoutModel.workoutReps)"
    }
}



extension RepsWorkoutViewController: NextSetProtocol {
    
    func editingTapped() {
        customAlert.alertCustom(viewController: self,repsOrTimer: "Reps") { [self] sets, reps in
            if sets != "" && reps != "" {
                setDetailWorkoutForm.setsCountLabel.text = "\(numberOfSet)/\(sets)"
                setDetailWorkoutForm.repsCountLabel.text = reps
            guard let numberOfSets = Int(sets) else { return }
            guard let numberOfReps = Int(reps) else { return }
            RealmManager.shared.updateSetsRepsWorkoutModel(model: workoutModel, sets: numberOfSets, reps: numberOfReps)
            }
        }
    }
    
    func nextSetTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            setDetailWorkoutForm.setsCountLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            simpleAlert(title: "Workout Done", message: "Finish your workout")
        }
    }
}

extension RepsWorkoutViewController {
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            startWorkoutLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -57),
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainBackGroundImage.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 28),
            mainBackGroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: mainBackGroundImage.bottomAnchor, constant: 26),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
        ])
        
        NSLayoutConstraint.activate([
            detailWorkoutForm.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 0),
            detailWorkoutForm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            detailWorkoutForm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            detailWorkoutForm.heightAnchor.constraint(equalToConstant: 255)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: detailWorkoutForm.bottomAnchor, constant: 13),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}

