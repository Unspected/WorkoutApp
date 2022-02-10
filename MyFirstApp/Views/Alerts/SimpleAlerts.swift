//
//  SimpleAlerts.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/25/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func simpleAlert(title: String, message: String?) {
        // Создание окна алерта
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Создание действий под алертом ОК кнопка окей и закрытие handler сделан для действий
        let actionAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        // Добавление функциональной кнопки для нашего окна алерт
        alert.addAction(actionAlert)
        
        // Подключение алерта уже к выводу на экран
        present(alert, animated: true, completion: nil)
    }
}
