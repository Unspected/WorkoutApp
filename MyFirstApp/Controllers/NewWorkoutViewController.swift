//
//  NewWorkoutViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/18/22.
//

import UIKit
import RealmSwift

class NewWorkoutViewController: UIViewController {
    
    // Кнопка крестик для закрытия окна
    private let closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Функция закрытия окна
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private let newWorkoutLabel: UILabel = UILabel(font24: "NEW WORKOUT")
    
    // name Text Field
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.layer.cornerRadius = 10
        textField.borderStyle = .none
        textField.textColor = .specialGray
        textField.font = .robotoBold20()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        return textField
    }()
    
    private let dateAndRepeatView = DateAndRepeatView()
    
    private let nameLabel = UILabel(font14: "Name")
    private let labelDateAndRepeat = UILabel(font14: "Date and repeat")
    private let repsOrTimerLabel = UILabel(font14: "Reps or timer")
    
    private let repsOrTimerView = RepsOrTimerView()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .specialGreen
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = .robotoMedium16()
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Action "SAVE" Button
    @objc private func saveButtonTapped() {
        setModel()
        saveModel()
    }
    
    //Инициализируем реалм
    private let localRealm = try! Realm()
    // Инициализируем модель
    private var workoutModel = WorkoutModel()
    
    // MARK: - ТЕСТОВОЕ ИЗОБРАЖЕНИЕ НУЖНО БУДЕТ СМЕНИТЬ В БУДУЩЕМ
    private let imageTest = UIImage(named: "heavyItem")
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setConstrains()
        setDelegates()
        addTaps()
        
    }
    
    // MARK: ВСЕ КНОПКИ ДОБАВЛЯТЬ СЮДА!!!
    private func setUpViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(closeButton)
        view.addSubview(newWorkoutLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameLabel)
        view.addSubview(labelDateAndRepeat)
        view.addSubview(dateAndRepeatView)
        view.addSubview(repsOrTimerLabel)
        view.addSubview(repsOrTimerView)
        view.addSubview(saveButton)

    }
    private func setDelegates() {
        nameTextField.delegate = self
    }
    
    // Функция скрытия клавиатуры
    private func addTaps() {
        //MARK: -   TapGestureRecognizer кликать где угодно и клавиатура скроеться
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboeard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
        // Отключение клавиатуры по свайпу
        let swipeGest = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboeard))
        swipeGest.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeGest)
    }
    
    @objc private func hideKeyboeard() {
        view.endEditing(true)
    }
    
    private func setModel() {
        
        guard let nameWorkout = nameTextField.text else { return}
        workoutModel.workoutName = nameWorkout
        
        workoutModel.workoutDate = dateAndRepeatView.datePicker.date.localDate()
        workoutModel.workoutNumberOfDay = dateAndRepeatView.datePicker.date.getWeekdayNumber()
        workoutModel.workoutRepeat = (dateAndRepeatView.switchButton.isOn)
        
        workoutModel.workoutSets = Int(repsOrTimerView.setsSlider.value)
        workoutModel.workoutReps = Int(repsOrTimerView.repsSlider.value)
        workoutModel.workoutTimer = Int(repsOrTimerView.timerSlider.value)
        
        guard let imageData = imageTest?.pngData() else { return }
        workoutModel.workoutImage = imageData
    }
    
    private func saveModel() {
        
        //precondition(nameTextField.text != "", "Text Field Empty")
        guard let text = nameTextField.text else {return}
        
        //Получить количество символов в строчке
        let count = text.filter{ $0.isNumber || $0.isLetter}.count
        
        //&& workoutModel.workoutSets != 0 && (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0)
        if count != 0 {
            guard workoutModel.workoutSets != 0 else { return simpleAlert(title: "Wrong value", message: "set Sets")}
            guard (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0) else { return simpleAlert(title: "Wrong Value", message: "set count of Reps or set Timer")}
            RealmManager.shared.saveWorkoutModel(model: workoutModel)
            workoutModel = WorkoutModel()
            dismiss(animated: true, completion: nil)
            refreshWorkoutObjects()
        } else {
            simpleAlert(title: "Wrong Value", message: "please fill your name")
        }
    }
    
    private func refreshWorkoutObjects() {
        dateAndRepeatView.datePicker.setDate(Date(), animated: true)
        nameTextField.text = ""
        dateAndRepeatView.switchButton.isOn = true
        repsOrTimerView.setsCountLabel.text = "0"
        repsOrTimerView.setsSlider.value = 0
        repsOrTimerView.repsCountLabel.text = "0"
        repsOrTimerView.repsSlider.value = 0
        repsOrTimerView.timerCountLabel.text = "0"
        repsOrTimerView.timerSlider.value = 0
    }
    
}

extension NewWorkoutViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Метод который позволяет вывести текстфил на первый план и сохранять значение в поле по клику Done
        nameTextField.resignFirstResponder()
        // При открытии окна becomeFirstResponder сразу ставить курсор на поле что можно было писать в нем
        //nameTextField.becomeFirstResponder()
    }
}

extension NewWorkoutViewController {
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            newWorkoutLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -57),
            newWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            nameTextField.heightAnchor.constraint(equalToConstant: 38),
            nameTextField.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 28)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -2),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            labelDateAndRepeat.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 14),
            labelDateAndRepeat.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            labelDateAndRepeat.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            dateAndRepeatView.topAnchor.constraint(equalTo: labelDateAndRepeat.bottomAnchor, constant: 3),
            dateAndRepeatView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            dateAndRepeatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            dateAndRepeatView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22)
        ])
        
        NSLayoutConstraint.activate([
            repsOrTimerLabel.topAnchor.constraint(equalTo: dateAndRepeatView.bottomAnchor, constant: 20),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            repsOrTimerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            repsOrTimerView.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 3),
            repsOrTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            repsOrTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            saveButton.topAnchor.constraint(equalTo: repsOrTimerView.bottomAnchor, constant: 25),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
}
