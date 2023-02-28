//
//  AppDelegate.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/21/23.
//

import Firebase
import UIKit
import FirebaseMessaging
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        let fcmToken = Messaging.messaging().fcmToken
        
        print("FCM TOKEN: \(fcmToken)")
        
        if let fcmToken = Messaging.messaging().fcmToken {
            let pushManager = PushNotificationManager(userID: fcmToken)
            pushManager.registerForPushNotifications()
        } else {
            print("ERROR WITH FCM TOKEN - NOT ABLE TO GET PUSH NOTIFICATIONS")
        }
        
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: "token", title: "Notification title", body: "Notification body")
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for Apple Remote Notifications")
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("MESSAGING FUNCTION INSIDE OF APP DELEGATE")
        
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
    
    
    
    
}




