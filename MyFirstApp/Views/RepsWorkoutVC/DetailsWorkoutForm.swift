//
//  DetailsView.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/26/22.
//

import Foundation
import UIKit

protocol NextSetProtocol: AnyObject {
    func nextSetTapped()
    func editingTapped()
}

class DetailsWorkoutForm: UIView {
    
   let titleNameExcercise: UILabel = {
        let name = UILabel()
        name.text = "NAME"
        name.font = .robotoMedium24()
        name.textAlignment = .center
        name.adjustsFontSizeToFitWidth = true
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let setsLabel: UILabel = UILabel(font18: "Sets")
    let setsCountLabel: UILabel = UILabel(font24: "1/4")
    private var setsStackView: UIStackView = UIStackView()
    private let lineForSets: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.8110429645, green: 0.8110429049, blue: 0.8110428452, alpha: 1)
        return line
    }()
    
    var repsLabel: UILabel = UILabel(font18: "Reps")
    var repsCountLabel: UILabel = UILabel(font24: "20")
    private var repsStackView: UIStackView = UIStackView()
    private let lineForReps: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.8110429645, green: 0.8110429049, blue: 0.8110428452, alpha: 1)
        return line
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "pencilButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Editing", for: .normal)
        button.tintColor = .specialLightBrown
        button.titleLabel?.font = .robotoMedium16()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT SET", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .robotoMedium16()
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .specialYellow
        button.tintColor = .specialGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var nextButtonDelegate: NextSetProtocol?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editButtonTapped() {
        nextButtonDelegate?.editingTapped()
    }
    
    @objc private func nextButtonTapped() {
        nextButtonDelegate?.nextSetTapped()
    }
    
    private func setupViews() {
        layer.cornerRadius = 10
        backgroundColor = .specialBrown
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleNameExcercise)
        setsStackView = UIStackView(arrangedSubviews: [setsLabel, setsCountLabel],
                                    axis: .horizontal, spacing: 5)
        addSubview(setsStackView)
        addSubview(lineForSets)
        repsStackView = UIStackView(arrangedSubviews: [repsLabel,repsCountLabel],
                                    axis: .horizontal, spacing: 5)
        addSubview(repsStackView)
        addSubview(lineForReps)
        addSubview(editButton)
        addSubview(nextSetButton)
    }
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            titleNameExcercise.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            titleNameExcercise.heightAnchor.constraint(equalToConstant: 24),
            titleNameExcercise.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            setsStackView.topAnchor.constraint(equalTo: titleNameExcercise.bottomAnchor, constant: 20),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            lineForSets.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 3),
            lineForSets.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lineForSets.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lineForSets.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            repsStackView.topAnchor.constraint(equalTo: lineForSets.bottomAnchor, constant: 25),
            repsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            repsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            lineForReps.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 3),
            lineForReps.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lineForReps.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lineForReps.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: lineForReps.bottomAnchor, constant: 15),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            editButton.heightAnchor.constraint(equalToConstant: 20),
            editButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            nextSetButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 12),
            nextSetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nextSetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextSetButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
    }
    
}
