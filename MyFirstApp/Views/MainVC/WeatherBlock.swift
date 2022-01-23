//
//  WeatherBlock.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/16/22.
//

import UIKit

class WeatherBlock: UIView {
    
    
    // Картинка Солнышко
    private let sunImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sunIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // Заголовок
    private let weatherTitle: UILabel = {
        let label = UILabel()
        label.text = "Солнечно"
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Описание контента под заголовком
    private let weatherContent: UILabel = {
        let label = UILabel()
        label.text = "Хорошая погода, чтобы позаниматься на улице"
        label.font = .robotoMedium14()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        label.numberOfLines = 2
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 10
        backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        addShadowOnView()
        addSubview(sunImg)
        addSubview(weatherTitle)
        addSubview(weatherContent)
    }
    
    private func setConstrains() {
        var const = [NSLayoutConstraint]()
        const.append(sunImg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10))
        const.append(sunImg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11))
        const.append(sunImg.topAnchor.constraint(equalTo: topAnchor, constant: 7))
        const.append(sunImg.widthAnchor.constraint(equalToConstant: 62))
        
        const.append(weatherTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10))
        const.append(weatherTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11))
        const.append(weatherTitle.heightAnchor.constraint(equalToConstant: 21))
        
        const.append(weatherContent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11))
        const.append(weatherContent.widthAnchor.constraint(equalToConstant: 171))
        const.append(weatherContent.topAnchor.constraint(equalTo: weatherTitle.bottomAnchor, constant: 5))
        
        
        NSLayoutConstraint.activate(const)
    }
}
