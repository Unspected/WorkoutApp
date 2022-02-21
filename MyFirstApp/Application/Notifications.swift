//
//  Notifications.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 2/19/22.
//

import Foundation
import UserNotifications

class Notifications: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { setting in
            print(setting)
        }
    }
    
}
