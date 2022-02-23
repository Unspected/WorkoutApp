//
//  StatisticViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/21/22.
//

import UIKit
import RealmSwift

struct DifferenceWorkout {
    let name: String
    let lastReps: Int
    let firstReps: Int
}

class StatisticViewController: UIViewController {
    
    private let statisticLabel: UILabel = UILabel(font24: "STATISTICS")
    
    private let segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Week", "Mounth"])
        // Index default
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "Roboto-Medium", size: 16)
        // Styles for non-selected item
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font:font as Any,
                                                 NSAttributedString.Key.foregroundColor:UIColor.white ],
                                                for: .normal)
        // Styles for selected item
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font as Any,
                                                 NSAttributedString.Key.foregroundColor: UIColor.specialGray],
                                                for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentValueChange), for: .valueChanged)
        return segmentedControl
    }()
    
    private let exercisesLabel: UILabel = UILabel(font14: "Exercises")
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let tableViewIdCell = "TableViewIdCell"
    private let localRealm = try! Realm()
    var workoutArray: Results<WorkoutModel>!
    var differenceArray = [DifferenceWorkout]()
    
    let dateToday = Date().localDate()
    private var isFiltred = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVIews()
        setDelegates()
        setConstrains()
        setStartScreen()
       
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func setStartScreen() {
        getDifferenceModel(dateStart: dateToday.offsetDays(days: 7))
        tableView.reloadData()
    }
    
    private func setupVIews() {
        
        view.backgroundColor = .specialBackground
        view.addSubview(statisticLabel)
        view.addSubview(segmentedControl)
        view.addSubview(exercisesLabel)
        view.addSubview(tableView)
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: tableViewIdCell)
    }
    
    private func getWorkoutNames() ->[String] {
        
        var nameArray = [String]()
        workoutArray = localRealm.objects(WorkoutModel.self)
        
        for workoutModel in workoutArray {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {
        
        differenceArray.removeAll()
        
        let dateEnd = Date().localDate()
        let nameArray = getWorkoutNames()
        
        for name in nameArray {
            
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@",[dateStart,dateEnd])
            workoutArray = localRealm.objects(WorkoutModel.self).filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            
            guard let first = workoutArray.first?.workoutReps,
                  let last = workoutArray.last?.workoutReps else {
                      return
                  }
            let differenceWorkout = DifferenceWorkout.init(name: name, lastReps: last, firstReps: first)
            differenceArray.append(differenceWorkout)
        }
    }
    
    @objc private func segmentValueChange() {
        if segmentedControl.selectedSegmentIndex == 0 {
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetDays(days: 7)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        } else {
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetDays(days: 30)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
            
        }
    }
}

extension StatisticViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        differenceArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdCell, for: indexPath) as! StatisticTableViewCell
        let differenceModel = differenceArray[indexPath.row]
        cell.CellConfigure(differenceWorkout: differenceModel)
        return cell
    }
}

extension StatisticViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}




extension StatisticViewController {
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            statisticLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            statisticLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: statisticLabel.bottomAnchor, constant: 31),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            exercisesLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
    }
}
