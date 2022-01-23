//
//  NewWorkoutViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/18/22.
//

import UIKit

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
    
    private let newWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW WORKOUT"
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private let dateAndRepeatView: UIView = DateAndRepeatView()
    
    private let nameLabel = UILabel(extensionLabel: "Name")
    private let labelDateAndRepeat = UILabel(extensionLabel: "Date and repeat")
    private let repsOrTimerLabel = UILabel(extensionLabel: "Reps or timer")
    
    private let repsOrTimerView: UIView = RepsOrTimerView()
    
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
    
    @objc private func saveButtonTapped() {
        print("saveButtonTapped")
    }
 
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
    }
    
    @objc private func hideKeyboeard() {
        view.endEditing(true)
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
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 275)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            saveButton.topAnchor.constraint(equalTo: repsOrTimerView.bottomAnchor, constant: 25),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
}
