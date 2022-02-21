//
//  EditProfileViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 2/4/22.
//

import UIKit
import RealmSwift

protocol EditProfileVCDelegate: AnyObject {
    
    func renewVC()
}


class EditProfileViewController: UIViewController {
    
    private let editingProfileLabel: UILabel = UILabel(font24: "EDITING PROFILE")
    
    private let addPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderWidth = 5
        // Обязательно указывать такой формат  cGColor
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "photoIcon")
        return imageView
    }()
    
    private let userPhotoBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstNameLabel: UILabel = UILabel(font14: "First name")
    private let lastNameLabel: UILabel = UILabel(font14: "Last name")
    private let heightLabel: UILabel = UILabel(font14: "Height")
    private let weightLabel: UILabel = UILabel(font14: "Weight")
    private let targetLabel: UILabel = UILabel(font14: "Target")
    
    private let firstNameTextField: UITextField = UITextField(keyBoard: .default)
    private let lastNameTextField: UITextField = UITextField(keyBoard: .default)
    private let heightTextField: UITextField = UITextField(keyBoard: .numberPad)
    private let weightTextField: UITextField = UITextField(keyBoard: .numberPad)
    private let targetTextField: UITextField = UITextField(keyBoard: .numberPad)
    
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
    
    //ИНИЦИАЛИЗИРУЕМ РЕАЛМ
    private let localRealm = try! Realm()
    
    // МОДЕЛЬ РЕАЛМА К КОТОРОЙ МЫ ОБРАЩАЕМСЯ
    private var userArray: Results<UserModel>!
    
    //ОБЪЕКТ РЕАЛМА КУДА МЫ ХОТИМ СОХРАНИТЬ ДАННЫЕ
    private var userModel = UserModel()
    
    weak var delegate: EditProfileVCDelegate?
    
    override func viewDidLayoutSubviews() {
        addPhotoImageView.layer.cornerRadius = addPhotoImageView.frame.height / 2
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = localRealm.objects(UserModel.self)
        
        setupViews()
        setConstrains()
        setDelegates()
        addTaps()
        loadUserInfo()
    }
    
    private func setDelegates() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(editingProfileLabel)
        view.layer.cornerRadius = 35
        view.addSubview(userPhotoBlock)
        view.addSubview(addPhotoImageView)
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(heightLabel)
        view.addSubview(heightTextField)
        view.addSubview(weightLabel)
        view.addSubview(weightTextField)
        view.addSubview(targetLabel)
        view.addSubview(targetTextField)
        view.addSubview(saveButton)
        
        
    }
    
    @objc private func saveButtonTapped() {
        // Обращаемся к БД если в
        setUserModel()
        if userArray.count == 0 {
            RealmManager.shared.saveUserModel(model: userModel)
        } else {
            RealmManager.shared.updateUserModel(model: userModel)
        }
        userModel = UserModel()
        
        dismiss(animated: true, completion: nil)
        delegate?.renewVC()
        
    }
    
    private func addTaps() {
        //MARK: -   TapGestureRecognizer кликать где угодно и клавиатура скроеться
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboeard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
        let tapImageView = UITapGestureRecognizer(target: self, action: #selector(setUserPhoto))
        addPhotoImageView.isUserInteractionEnabled = true
        addPhotoImageView.addGestureRecognizer(tapImageView)
        
        
        //MARK: - SETTINGS KEYBOARD SHOW
        // Отображение клавиатуры (Появление)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        // Скрытие клавиатуры (Скрытие)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -200
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            self.view.frame.origin.y = keyboardHeight - (saveButton.frame.origin.y - saveButton.frame.height)
//        }
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc private func setUserPhoto() {
        alertPhotoOrCamera { [weak self] source in
            guard let self = self else { return }
            self.chooseImagePicker(source: source)
        }
    }
    
    @objc private func hideKeyboeard() {
        view.endEditing(true)
    }
    
    // Загружка в поля существующей модели
    private func loadUserInfo() {
        if userArray.count != 0 {
            firstNameTextField.text = userArray[0].userFirstName
            lastNameTextField.text = userArray[0].userLastName
            heightTextField.text = "\(userArray[0].userHeight)"
            weightTextField.text = "\(userArray[0].userWeight)"
            targetTextField.text = "\(userArray[0].userTarget)"
        
            guard let data = userArray[0].userImage else { return }
            guard let image = UIImage(data: data) else { return }
            addPhotoImageView.image = image
            addPhotoImageView.contentMode = .scaleAspectFit
        }
    }
    
    private func setUserModel() {
        
        // Проверяем что получили данные с полей
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let weight = weightTextField.text,
              let height = heightTextField.text,
              let target = targetTextField.text  else {
                  return
              }
        
        // Проверяем что можно конвертировать текст в ИНТ
        guard let intWeight = Int(weight),
              let intHeight = Int(height),
              let intTarget = Int(target) else {
                  return
              }
        
        // Сохраняем данные в полученный объект userModel = UserModel() он иницилазирован
        userModel.userFirstName = firstName
        userModel.userLastName = lastName
        userModel.userWeight = intWeight
        userModel.userHeight = intHeight
        userModel.userTarget = intTarget
        
        // Обработка полученного фото
        if addPhotoImageView.image == UIImage(named: "photoIcon") {
            userModel.userImage = nil
        } else {
            guard let imageData = addPhotoImageView.image?.pngData() else { return }
            userModel.userImage = imageData
        }
              
    }
}


extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        return true
    }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        addPhotoImageView.image = image
        addPhotoImageView.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
}

extension EditProfileViewController {
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            editingProfileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            editingProfileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoImageView.topAnchor.constraint(equalTo: editingProfileLabel.bottomAnchor, constant: 20),
            addPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            addPhotoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            userPhotoBlock.topAnchor.constraint(equalTo: addPhotoImageView.topAnchor, constant: 50),
            userPhotoBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            userPhotoBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            userPhotoBlock.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            firstNameLabel.topAnchor.constraint(equalTo: userPhotoBlock.bottomAnchor, constant: 40),
            firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor,constant: 2),
            firstNameTextField.leadingAnchor.constraint(equalTo: userPhotoBlock.leadingAnchor),
            firstNameTextField.trailingAnchor.constraint(equalTo: userPhotoBlock.trailingAnchor),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 2),
            lastNameTextField.leadingAnchor.constraint(equalTo: userPhotoBlock.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: userPhotoBlock.trailingAnchor),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            heightLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor,constant: 16),
            heightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            heightTextField.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 2),
            heightTextField.leadingAnchor.constraint(equalTo: userPhotoBlock.leadingAnchor),
            heightTextField.trailingAnchor.constraint(equalTo: userPhotoBlock.trailingAnchor),
            heightTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 16),
            weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
        ])
        
        NSLayoutConstraint.activate([
            weightTextField.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 2),
            weightTextField.leadingAnchor.constraint(equalTo: userPhotoBlock.leadingAnchor),
            weightTextField.trailingAnchor.constraint(equalTo: userPhotoBlock.trailingAnchor),
            weightTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            targetLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 16),
            targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            targetTextField.topAnchor.constraint(equalTo: targetLabel.bottomAnchor,constant: 2),
            targetTextField.leadingAnchor.constraint(equalTo: userPhotoBlock.leadingAnchor),
            targetTextField.trailingAnchor.constraint(equalTo: userPhotoBlock.trailingAnchor),
            targetTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: targetTextField.bottomAnchor, constant: 42),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
}
