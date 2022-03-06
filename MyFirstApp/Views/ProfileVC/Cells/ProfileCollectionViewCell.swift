//
//  ProfileCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 2/6/22.
//

// ЯЧЕЙКА ДЛЯ РЕЗУЛЬТАТА ЗАНЯТИЙ
import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    private var nameLabel: UILabel = UILabel(font24: "Biceps")
    
    private let workoutImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "1")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.text = "180"
        label.textColor = .white
        label.font = .robotoBold48()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.cornerRadius = 20
        backgroundColor = .specialDarkYellow
        nameLabel.textColor = .white
        addSubview(nameLabel)
        addSubview(workoutImageView)
        addSubview(counterLabel)
    }
    
    //MARK: - setModel 
    func cellConfigure(model: ResultWorkout) {
        nameLabel.text = model.name
        counterLabel.text = "\(model.result)"
        
        guard let data = model.imageData else { return }
        let image = UIImage(data: data)
        workoutImageView.image = image
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            
        ])
        
        NSLayoutConstraint.activate([
            workoutImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            workoutImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            workoutImageView.heightAnchor.constraint(equalToConstant: 57),
            workoutImageView.widthAnchor.constraint(equalToConstant: 57)
        ])
        
        NSLayoutConstraint.activate([
            counterLabel.centerYAnchor.constraint(equalTo: workoutImageView.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: workoutImageView.trailingAnchor, constant: 10)
        ])
        
    }
}
