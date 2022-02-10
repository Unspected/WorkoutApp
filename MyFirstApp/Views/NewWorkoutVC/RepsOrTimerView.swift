//
//  RepsOrTimerView.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/20/22.
//

import UIKit

class RepsOrTimerView: UIView {
    
    private let setsNameLabel: UILabel = UILabel(font18: "Sets")
    let setsCountLabel: UILabel = UILabel(font24: "0")
    private var setsStackView: UIStackView = UIStackView()
    
    let setsSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 50
        // дефолтное положение 0
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.addTarget(self, action: #selector(sliderValueSets), for: .valueChanged)
        return slider
    }()
    
    @objc private func sliderValueSets() {
        setsCountLabel.text = String(Int(setsSlider.value))
    }
    
    private let chooseRepeatOrTimerLabel: UILabel = UILabel(font14: "Choose repeat or timer")
    
    private let repsNameLabel: UILabel = UILabel(font18: "Reps")
    let repsCountLabel: UILabel = UILabel(font24: "0")
    private var repsStackView: UIStackView = UIStackView()
    
    
    let repsSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        // Необходимо ставить дефолтное значчение для корректной работы
        slider.maximumValue = 50
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.addTarget(self, action: #selector(sliderRepsChanged), for: .valueChanged)
        return slider
    }()
    
    @objc private func sliderRepsChanged() {
        repsCountLabel.text = String(Int(repsSlider.value))
        
        setDeactivate(label: timerNameLabel, numberLabel: timerCountLabel, slider: timerSlider)
        setActive(label: repsNameLabel, numberLabel: repsCountLabel, slider: repsSlider)
    }
    
    private let timerNameLabel: UILabel = UILabel(font18: "Timer")
    let timerCountLabel: UILabel = UILabel(font24: "0 min")
    private var timerStackView: UIStackView = UIStackView()
    
    let timerSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 600
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.addTarget(self, action: #selector(sliderTimerChanged), for: .valueChanged)
        return slider
    }()
    
    @objc private func sliderTimerChanged() {
        
        let (min, sec) = { (secs: Int) -> (Int, Int) in
                    return (secs / 60, secs % 60) }(Int(timerSlider.value))
        
        timerCountLabel.text = (sec != 0 ? "\(min) min \(sec) sec" : "\(min) min")
        setDeactivate(label: repsNameLabel, numberLabel: repsCountLabel, slider: repsSlider)
        setActive(label: timerNameLabel, numberLabel: timerCountLabel, slider: timerSlider)
        
    }
    
    // MARK: - 1 method Active do it active slider 2 method Deactivated and reset value slider
    private func setActive(label: UILabel, numberLabel: UILabel, slider: UISlider) {
        label.alpha = 1
        numberLabel.alpha = 1
        slider.alpha = 1
    }
    // Сбрасываем значения у выбранного лэйбла и затемняем его
    private func setDeactivate(label: UILabel, numberLabel: UILabel, slider: UISlider) {
        label.alpha = 0.5
        numberLabel.alpha = 0.5
        numberLabel.text = "0"
        slider.alpha = 0.5
        slider.value = 0
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        backgroundColor = .specialBrown
        setsStackView = UIStackView(arrangedSubviews: [setsNameLabel,setsCountLabel],
                                axis: .horizontal, spacing: 10)
        addSubview(setsStackView)
        addSubview(setsSlider)
        addSubview(chooseRepeatOrTimerLabel)
        repsStackView = UIStackView(arrangedSubviews: [repsNameLabel,repsCountLabel],
                                    axis: .horizontal, spacing: 10)
        addSubview(repsStackView)
        addSubview(repsSlider)
        timerStackView = UIStackView(arrangedSubviews: [timerNameLabel,timerCountLabel],
                                     axis: .horizontal, spacing: 10)
        addSubview(timerStackView)
        addSubview(timerSlider)
        
    }
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            setsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            setsSlider.topAnchor.constraint(equalTo: setsStackView.topAnchor, constant: 25),
            setsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsSlider.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            chooseRepeatOrTimerLabel.topAnchor.constraint(equalTo: setsSlider.bottomAnchor, constant: 20),
            chooseRepeatOrTimerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            repsStackView.topAnchor.constraint(equalTo: chooseRepeatOrTimerLabel.bottomAnchor, constant: 20),
            repsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            repsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            repsSlider.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 10),
            repsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            repsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            timerStackView.topAnchor.constraint(equalTo: repsSlider.bottomAnchor, constant: 20),
            timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            timerStackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            timerSlider.topAnchor.constraint(equalTo: timerStackView.bottomAnchor, constant: 10),
            timerSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            timerSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
