//
//  TimerNotifications.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 18/02/2022.
//

import Foundation
import UserNotifications

struct TimerNotifications {
    var id: String
    var title: String
    var timeRemaining: TimeInterval
}

class LocalNotifcationManager {
    
    var notifications = [TimerNotifications]()
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined: self.requestAuthorisation()
            case .authorized, .provisional: self.scheduleNotifications()
            default: break
            }
        }
    }
    
    private func requestAuthorisation() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { authorised, error in
            if authorised == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func removeNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    private func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.timeRemaining, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Notification scheduled! - ID = \(notification.id)")
            }
        }
    }
    
}

