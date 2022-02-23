//
//  Notifications.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 2/19/22.
//

import Foundation
import UserNotifications
import UIKit

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
    
    func scheduleDateNotification(date: Date, id: String) {
        
        // Content for Notification alert
        let content = UNMutableNotificationContent()
        content.title = "WORKOUT"
        content.body = "workout was created successfully"
        content.sound = .default
        content.badge = 1
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "PST")!
        // MARK: - Trigger Event which to start Notify Action
//        var triggerDate = calendar.dateComponents([.year, .month, .day], from: date)
//        triggerDate.hour = 12
//        triggerDate.minute = 46
//        // СALL Notification in 5 second after create Training
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger1)
        notificationCenter.add(request) { error in
            print("Error \(error?.localizedDescription ?? "error")")
        }
    }
}

// Delegate for shows notification when app open on the screen
extension Notifications: UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    // Method do after when you click on Notifcation
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationCenter.removeAllDeliveredNotifications()
    }
}
