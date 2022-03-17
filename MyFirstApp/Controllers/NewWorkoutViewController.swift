//
//  NewWorkoutViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/18/22.
//

import UIKit
import RealmSwift



class NewWorkoutViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    
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
    
    //MARK: - Images for choose
    private let collectionView: UICollectionView = {
        // init settings UICollection
        let layout = UICollectionViewFlowLayout()
        // type scrolling
        layout.scrollDirection = .horizontal
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.translatesAutoresizingMaskIntoConstraints = false
        collectionVIew.bounces = false
        collectionVIew.layer.cornerRadius = 10
        collectionVIew.showsHorizontalScrollIndicator = false
        collectionVIew.backgroundColor = .specialBrown
        return collectionVIew
    }()
    
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
    private var currentImage: UIImage?
    private let collectionImages = ["heavyItem","1","2","3","4"]
    private var imageTest = UIImage(named: "heavyItem")
    
    private let collectionViewIDCell = "collectionViewIDCell"
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setConstrains()
        setDelegates()
        addTaps()
        
    }
    
    // MARK: All have to locate here
    private func setUpViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(scrollView)
        scrollView.addSubview(closeButton)
        scrollView.addSubview(newWorkoutLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(labelDateAndRepeat)
        scrollView.addSubview(dateAndRepeatView)
        scrollView.addSubview(repsOrTimerLabel)
        scrollView.addSubview(repsOrTimerView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(saveButton)
        collectionView.register(NewWorkoutCell.self, forCellWithReuseIdentifier: collectionViewIDCell)

    }
    private func setDelegates() {
        nameTextField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
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
        
        guard let imageData = currentImage?.pngData() else { return}
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
            guard (workoutModel.workoutImage != nil) else { return simpleAlert(title: "You've didn't choose image", message: "pick the image")}
            RealmManager.shared.saveWorkoutModel(model: workoutModel)
            createNotification()
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
    
    private func createNotification() {
        let notifications = Notifications()
        let stringDate = workoutModel.workoutDate.ddMMyyyyFromDate()
        print(workoutModel.workoutDate)
        notifications.scheduleDateNotification(date: workoutModel.workoutDate, id: "workout" + stringDate)
    }
    
}

extension NewWorkoutViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIDCell, for: indexPath) as! NewWorkoutCell
        let model = collectionImages[indexPath.row]
        cell.cellConfigure(name: model)
        return cell
    }
    
    // MARK: - select certain Item and save for proccess it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.gray.cgColor
        if let cell = cell as? NewWorkoutCell {
            currentImage = cell.imageView.image
        }
    }
    
    //MARK: - action for remove all style from cell
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return}
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0
    }
    
    
}

extension NewWorkoutViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Size The Cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 65, height: 65)
    }
    
    // MARK: - Spacing beetwin cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 40),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
  
            newWorkoutLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -57),
            newWorkoutLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 40),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),

            nameTextField.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 28),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 21),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 21),
            nameTextField.heightAnchor.constraint(equalToConstant: 38),
     
            nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -2),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 31),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
       
            labelDateAndRepeat.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 14),
            labelDateAndRepeat.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 31),
            labelDateAndRepeat.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
    
            dateAndRepeatView.topAnchor.constraint(equalTo: labelDateAndRepeat.bottomAnchor, constant: 3),
            dateAndRepeatView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 21),
            dateAndRepeatView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -21),
            dateAndRepeatView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor, multiplier: 0.22),
       
            repsOrTimerLabel.topAnchor.constraint(equalTo: dateAndRepeatView.bottomAnchor, constant: 20),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 31),
            repsOrTimerLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
       
            repsOrTimerView.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 3),
            repsOrTimerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 21),
            repsOrTimerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -21),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 320),
       
            collectionView.topAnchor.constraint(equalTo: repsOrTimerView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 21),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -21),
            collectionView.heightAnchor.constraint(equalToConstant: 72),
       
            saveButton.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 21),
            saveButton.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -21),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            saveButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 25),
            saveButton.heightAnchor.constraint(equalToConstant: 55),
            
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
    }
}
