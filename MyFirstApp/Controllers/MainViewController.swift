//
//  ViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/14/22.
//

import UIKit
import RealmSwift
import CoreLocation

class MainViewController: UIViewController {
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderWidth = 5
        // Обязательно указывать такой формат  cGColor
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    // Создание Label где будет имя
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Your Name"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
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
        newController.modalPresentationStyle = .fullScreen
        
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
        tableView.backgroundColor = .specialBackground
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
    
    // MARK: - WeatherBlock
    private let weatherBlock = WeatherBlock()
    // Импорт класса в котором вся логика
    private let calendarView = CalendarView()
    
    // MARK: -  ID Ячейки tableView
    private let idWorkoutTableViewCell = "idWorkoutTableViewCell"
    
    //MARK: REALM INIT Object
    private let localRealm = try! Realm()
    // Инициализация массивка по которому мы собираем
    private var workoutArray: Results<WorkoutModel>!
    private var userArray: Results<UserModel>!
    
    //MARK: - networkManager
    var networkManager = NetworkWeatherManager()
    
    //MARK: - locationManager
    var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        setupUserParameters()
        screenWithoutCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOnboarding()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = localRealm.objects(UserModel.self)
        setUpViews()
        setConstrains()
        setDelegate()
        setupUserParameters()
        getWorkoutDate(date: Date().localDate())
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: idWorkoutTableViewCell)
    }
    
    //MARK: - DELEGATES
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        calendarView.cellCollectionViewDelegate = self
        locationManager.delegate = self
    }
    
    
    // MARK: - setupViews all UIElements located here
    private func setUpViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(calendarView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherBlock)
        view.addSubview(workoutTodayLabel)
        view.addSubview(tableView)
        view.addSubview(nonTableViewImage)
    }
    
    private func screenWithoutCells() {
        if workoutArray.count == 0 {
            tableView.isHidden = true
            nonTableViewImage.isHidden = false
        } else {
            tableView.isHidden = false
            nonTableViewImage.isHidden = true
        }
    }
    
    private func getWorkoutDate(date: Date) {
        
        let dateTimeZone = date
        let weekday = dateTimeZone.getWeekdayNumber()
        let dateStart = dateTimeZone.startEndDate().0
        let dateEnd = dateTimeZone.startEndDate().1
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnRepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dateStart,dateEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat,predicateUnRepeat])
        
        // Вызываем список
        workoutArray = localRealm.objects(WorkoutModel.self).filter(compound).sorted(byKeyPath: "workoutName")
        tableView.reloadData()
    }
    
    private func setupUserParameters() {
        if userArray.count != 0 {
            userNameLabel.text = "\(userArray[0].userFirstName) \(userArray[0].userLastName)"
            // Check the photo in DataBase
            guard let data = userArray[0].userImage else { return }
            //потом дальше проверяет фото и далее присваиваем фото
            guard let image = UIImage(data: data) else { return }
            userPhotoImageView.image = image
        }
    }
    
    // MARK: - UserDefault Settings Screen Before Starting App
    private func showOnboarding() {
        let userDefaults = UserDefaults.standard
        let onBoardingWasViewed = userDefaults.bool(forKey: "OnBoardingWasViewed")
        if onBoardingWasViewed == false {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: false)
        }
    }
    
    //MARK: - Update Interface with Api
    private func updateInterfaceWeather(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.weatherBlock.weatherTitle.text = ("\(weather.weatherDescription)  \(weather.temperatureString)℃").capitalized
            self.weatherBlock.weatherContent.text = "\(weather.cityName), feels like: \(weather.feelsLikeTemperatureString)℃"
            self.weatherBlock.sunImg.image = UIImage(named: weather.systemIconNameString)
        }
    }
    
}

// MARK: - LocationDelegate
extension MainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return}
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude

        networkManager.fetchCurrentWeather(latitude: latitude, longtitude: longtitude) { currentWeather in
            self.updateInterfaceWeather(weather: currentWeather)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    // DID AUTORIZATION FOR YOU REQUEST
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            }
        }
}


// MARK: - TableViewDataSource
extension MainViewController : UITableViewDataSource {
    
    // AMOUNT OF CELLS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutArray.count
    }
    
    // INIT CELL
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idWorkoutTableViewCell, for: indexPath) as! WorkoutTableViewCell
        let model = workoutArray[indexPath.row]
        cell.cellConfigure(model: model)
        // Кнопка в ячейки откликаеться на действие и можно привязать action
        cell.cellStartWorkoutDelegate = self
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
    
}

// MARK: - UITableViewDelegate Height Cells
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    // MARK: - Delete Cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            let deleteModel = self.workoutArray[indexPath.row]
            RealmManager.shared.deleteWorkoutModel(model: deleteModel)
            tableView.reloadData()
            self.screenWithoutCells()
        }
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

// MARK: - StartWorkOutProtocol
extension MainViewController: StartWorkoutProtocol {
    
    func startButtonTapped(model: WorkoutModel) {
        
        if model.workoutTimer == 0 {
            let startWorkoutVC = RepsWorkoutViewController()
            startWorkoutVC.modalPresentationStyle = .fullScreen
            startWorkoutVC.workoutModel = model
            present(startWorkoutVC, animated: true, completion: nil)
        }
        else  {
//            let startWorkoutTimerVC = TimerWorkoutViewController()
            let startWorkoutTimerVC = TimerWorkoutViewController()
            startWorkoutTimerVC.modalPresentationStyle = .fullScreen
            startWorkoutTimerVC.workoutModel = model
            present(startWorkoutTimerVC, animated: true, completion: nil)
        }
    }
}

extension MainViewController : SelectCollectionViewItemProtocol {
    
    func selectItem(date: Date) {
        getWorkoutDate(date: date)
    }
}


// MARK: - setConstrains
extension MainViewController {
    
    // Coordinates our elements
    private func setConstrains() {
        
        // USER PHOTO
        NSLayoutConstraint.activate([
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // CALENDAR BLOCK
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            // Отступ от правой стороны идет в отрицальных единицах
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // USER LABEL NAME
        NSLayoutConstraint.activate([
            // Слева констрейнт мы отталиваемся от правого края userPhoto
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            // Снизу констрейнт мы отталкиваемся от верха календаря
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        // Add Workout Button
        NSLayoutConstraint.activate([
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        // WEATHER BLOCK
        NSLayoutConstraint.activate([
            weatherBlock.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherBlock.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            //weatherTodayBlock.widthAnchor.constraint(equalToConstant: 260),
            weatherBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherBlock.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        //
        NSLayoutConstraint.activate([
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 14),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13)
        ])
        // TABLE VIEW
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


