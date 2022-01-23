//
//  CalendarView.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/15/22.
//

import UIKit

class CalendarView: UIView {
    
    private let colletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .specialGreen
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
        
    }()
    
    private let weekDaysList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let idCell = "IdCell"
    // Функция отрисовки
    
    // MARK: - Все инциализаторы ДОЛЖНЫ БЫТЬ ВЫЗЫВАНЫ ЗДЕСЬ !
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstrains()
        setDelegate()
        colletionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: idCell)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .specialGreen
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        addSubview(colletionView)
        
    }
    // Делигировать что сам класс управляет собой через расширения
    private func setDelegate() {
        colletionView.delegate = self
        colletionView.dataSource = self
    }
    
    // Устанавливаем констрейнты для СollectionView
    private func setConstrains() {
        var const = [NSLayoutConstraint]()
        const.append(colletionView.topAnchor.constraint(equalTo: topAnchor, constant: 5))
        const.append(colletionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 105))
        const.append(colletionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5))
        const.append(colletionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5))
        NSLayoutConstraint.activate(const)
        
    }
}

// MARK: - Size for each Cell
extension CalendarView: UICollectionViewDelegateFlowLayout {

    // Размер каждой ячейки ширина длина
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 34, //collectionView.frame.width / 7.5 ,
               height: collectionView.frame.height)
    }

    // Расстояние между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
}


// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Количество айтемов
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDaysList.count
    }
    
    // Реализовать айтем
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Перееспользованная ячейка
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath) as! CalendarCollectionViewCell
        cell.setLabelDayOfWeek(name: weekDaysList[indexPath.row])

        return cell
    }
    
// MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // Выполнение при выбранном элементе
    }
    
    
}

