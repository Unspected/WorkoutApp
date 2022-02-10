//
//  ProfileCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 2/6/22.
//

// ЯЧЕЙКА ДЛЯ РЕЗУЛЬТАТА ЗАНЯТИЙ
import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.cornerRadius = 20
        backgroundColor = .specialDarkYellow
    }
    
    private func setConstrains() {
        
        
    }
}
