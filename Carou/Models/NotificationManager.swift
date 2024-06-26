//
//  NotifcationManager.swift
//  Carou
//
//  Created by Matt Groholski on 11/11/23.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    static let shared = NotificationManager()
    static var deviceId = ""
    
    private override init() {
        super.init()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound, .badge]) { (granted, error) in
            guard granted else {
                return
            }
            
            DispatchQueue.main.async{
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}



