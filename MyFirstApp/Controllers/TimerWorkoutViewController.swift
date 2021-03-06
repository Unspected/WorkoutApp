//
//  StartTimerWorkoutViewController.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/26/22.
//

import UIKit

class TimerWorkoutViewController : UIViewController {
    
    private let closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func closeButtonTapped() {
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    private var startWorkoutLabel: UILabel = UILabel(font24: "START WORKOUT")
     //Woman for Reps and Ellipce for Timer
    let ellipseImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Circle")
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
         label.text = "01:37"
         label.textColor = .specialGray
         label.font = .robotoBold48()
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let detailsLabel: UILabel = UILabel(font14: "Details")
    
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
        // Add incriment to sets after done timer
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true, completion: nil)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel, bool: true)
        } else {
            
            alertOkCancel(title: "Warning", message: "You have not finish your excercise") {
                self.dismiss(animated: true, completion: nil)
            }
    }
        timer.invalidate()
    }
    
    // MARK: - Details Form
    private let timerWorkoutParametersView = TimerWorkoutParametersView()
    var durationTimer = 10
    private var numberOfSet = 1
    
    var workoutModel = WorkoutModel()
    let customAlert = CustomAlert()
    
    let shapeLayer = CAShapeLayer()
    
    var timer = Timer()
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        animationCircular()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        setConstrains()
        setupWorkoutModel()
        setDelegates()
        addTaps()

    }
    private func setDelegates() {
        timerWorkoutParametersView.cellNextSetTimerDelegate = self
    }
    private func setupViews() {
        
        view.backgroundColor = .specialBackground
        view.addSubview(closeButton)
        view.addSubview(startWorkoutLabel)
        view.addSubview(ellipseImageView)
        view.addSubview(timerLabel)
        view.addSubview(detailsLabel)
        view.addSubview(timerWorkoutParametersView)
        view.addSubview(finishButton)
        
    }
    //???????????????? ???????????? ?? ???????????? ?? ????????
    func setupWorkoutModel() {
        timerWorkoutParametersView.workoutNameLabel.text = workoutModel.workoutName
        timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        
        let (min, sec) = workoutModel.workoutTimer.convertToSecond()
        timerWorkoutParametersView.numberOfTimerLabel.text = "\(min) min \(sec) sec"
        
        timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
        durationTimer = workoutModel.workoutTimer
    }
    
    private func addTaps() {
        // ???????????????? UITapGesture
        
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        // ???????????????????? ?????????????????????????????? ?????? ???????????? ?? true
        timerLabel.isUserInteractionEnabled = true
        // ?????????????????? ???????????????? ???? ???????? ???? ?????? ??????????
        timerLabel.addGestureRecognizer(tapLabel)
        
    }
    
    
    @objc private func startTimer() {
        if numberOfSet == workoutModel.workoutSets {
            simpleAlert(title: "Error", message: "Finish your workout")
        } else  {
            if untouchableTimer  {
                untouchableTimer = false
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
            timerWorkoutParametersView.editingButton.isEnabled = false
                timerWorkoutParametersView.nextSetsButton.isEnabled = false
                
            }
        }
    }
    
    // variable for secure Timer, check status timer before start
    private var untouchableTimer: Bool = true
    // ?????????? ?????????????? ?????????????????????? ???????????????? ??????????????
    @objc private func timerAction() {
        durationTimer -= 1
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = workoutModel.workoutTimer
            
            numberOfSet += 1
            timerWorkoutParametersView.numberOfSetsLabel.text  = "\(numberOfSet)/\(workoutModel.workoutSets)"
            
            timerWorkoutParametersView.editingButton.isEnabled = true
            timerWorkoutParametersView.nextSetsButton.isEnabled = true
            untouchableTimer = true
        }
        let (min,sec) = durationTimer.convertToSecond()
        timerLabel.text =  "\(min):\(sec.setZeroForSeconds())"
    }
}

// MARK: - Animation
extension TimerWorkoutViewController {
    
    private func animationCircular() {
        
        let center = CGPoint(x: ellipseImageView.frame.width / 2, y: ellipseImageView.frame.height / 2)
        //let center = ellipseImageView.center
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 135, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        //MARK: - Drow Line for Animation
        // Way animation
        shapeLayer.path = circularPath.cgPath
        // Line thickness
        shapeLayer.lineWidth = 19
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        ellipseImageView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // ???????????????? ???????????? ???????????????? ????????????????
        basicAnimation.toValue = 0
        // ???????????????? ???? ?????????????? ?????????? ?????????????????? ????????????????
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        
    }
}


extension TimerWorkoutViewController: NextSetTimerProtocol {
    
    func nextSetTimerTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            simpleAlert(title: "Error", message: "Finish your workout")
        }
    }
    
    func editingTimerTapped() {
        customAlert.alertCustom(viewController: self, repsOrTimer: "Timer of set") { [self] sets, timerOfset in
            
            if sets != "" && timerOfset != "" {
                guard let numberOfSets = Int(sets) else { return }
                guard let numberOfTimer = Int(timerOfset) else { return }
                let (min, sec) = numberOfTimer.convertToSecond()
                timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(sets)"
                timerWorkoutParametersView.numberOfTimerLabel.text = "\(min) min \(sec) sec"
                timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
                durationTimer = numberOfTimer
                RealmManager.shared.updateSetsTimerWorkoutModel(model: workoutModel, sets: numberOfSets, timer: numberOfTimer)
            }
        }
    }
}

extension TimerWorkoutViewController {
    
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
            ellipseImageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 20),
            ellipseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            ellipseImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])

        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: ellipseImageView.leadingAnchor, constant: 40),
            timerLabel.trailingAnchor.constraint(equalTo: ellipseImageView.trailingAnchor, constant: -40),
            timerLabel.centerYAnchor.constraint(equalTo: ellipseImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: ellipseImageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            timerWorkoutParametersView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            timerWorkoutParametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerWorkoutParametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerWorkoutParametersView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: timerWorkoutParametersView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}



