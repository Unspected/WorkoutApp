//
//  ViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/14/22.
//

import UIKit

class MainViewController: UIViewController {
    
    private let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderWidth = 5
        // Обязательно указывать такой формат  cGColor
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    // Создание Label где будет имя
    private let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Pavel Andreev"
        label.textAlignment = .center
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Create button
    private let addWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .robotoMedium12()
        button.setImage(UIImage(named: "plusBtn"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 15, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 50, left: -40, bottom: 0, right: 0)
        button.tintColor = .specialDarkGreen
        button.addShadowOnView()
        button.layer.cornerRadius = 10
        button.backgroundColor = .specialYellow
        button.setTitle("Add workout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - FUNC Для ПЕРЕХОДА НА НОВЫЙ ЭКРАН
    @objc private func addWorkoutButtonTapped() {
        
       let newController = NewWorkoutViewController()
       present(newController, animated: true)

    }
    
    private let workoutTodayLabel : UILabel = {
        let label = UILabel()
        label.text = "Workout Today"
        label.textColor = .specialLightBrown
        label.font = .robotoMedium14()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - HIDDEN, nonTableViewImage isNotHidden
    private let tableView : UITableView = {
        let tableView = UITableView()
        // Разделение ячеек отключено
        tableView.separatorStyle = .none
        // Отскок скролла bounces = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delaysContentTouches = false
        // Ячейка отключена
        //tableView.isHidden = true
        return tableView
    }()
    
    // MARK: - nonTableViewImage Active
    private let nonTableViewImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "noWorkout")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    

    // новый блок погоды
    private let weatherBlock = WeatherBlock()
    // Импорт класса в котором вся логика
    private let calendarView = CalendarView()
    
    // MARK: -  ID Ячейки tableView
    private let idWorkoutTableViewCell = "idWorkoutTableViewCell"
    
    // Прочитать про этот метод
    override func viewDidLayoutSubviews() {
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setConstrains()
        setDelegate()
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: idWorkoutTableViewCell)
        
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - setupViews ВСЕ ЭЛЕМЕНТЫ НУЖНО ДОБАВЛЯТЬ СЮДА!!!
    // СЮДА ДОБАВЛЯТЬ ВСЕ ЭЛЕМЕНТЫ через ADDSomeView
    private func setUpViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(calendarView)
        view.addSubview(userPhoto)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherBlock)
        view.addSubview(workoutTodayLabel)
        view.addSubview(tableView)
        view.addSubview(nonTableViewImage)
    }
}





// MARK: - TableViewDataSource
extension MainViewController : UITableViewDataSource {
    
    // Количество Ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    // Инициализация ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idWorkoutTableViewCell, for: indexPath) as! WorkoutTableViewCell
        
        // Кнопка в ячейки откликаеться на действие и можно привязать action
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
    
}


// MARK: - UITableViewDelegate ВЫСОТА ЯЧЕЙКИ
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}


// MARK: - setConstrains
extension MainViewController {
    
    // Метод в котором задаем координаты элементов
    private func setConstrains() {
        
        // Список констрейнтов для UserPhoto
        NSLayoutConstraint.activate([
            userPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhoto.widthAnchor.constraint(equalToConstant: 100),
            userPhoto.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Позиционирование календаря
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            // Отступ от правой стороны идет в отрицальных единицах
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // Позиционирование Label Name
        NSLayoutConstraint.activate([
            // Слева констрейнт мы отталиваемся от правого края userPhoto
            userNameLabel.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor, constant: 5),
            // Снизу констрейнт мы отталкиваемся от верха календаря
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        // Позиционирование блока погоды
        NSLayoutConstraint.activate([
            weatherBlock.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherBlock.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            //weatherTodayBlock.widthAnchor.constraint(equalToConstant: 260),
            weatherBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherBlock.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // WorkOut Label Today
        NSLayoutConstraint.activate([
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 14),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            nonTableViewImage.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            nonTableViewImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            nonTableViewImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            nonTableViewImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
            
        ])
        
        
        
    }
}


