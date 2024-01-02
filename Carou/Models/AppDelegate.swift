//
//  AppDelegate.swift
//  Carou
//
//  Created by Matt Groholski on 11/11/23.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map{String(format: "%02.2hhx", $0)}.joined()
        NotificationManager.deviceId = token
    }
}
