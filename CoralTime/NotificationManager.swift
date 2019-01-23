//
//  NotificationManager.swift
//  CoralTime
//
//  Created by Kevin Kim on 14/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase

class NotificationManager {
    static let currentLang: String = Mode.currentLang
    
    // Ask for Authorization if it is not set
    static func requestAuthorization(view: PlansTableViewController) {
        // User Notification
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];

        var authorized = false
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                authorized = true
            }
        }
        if !authorized {
            if currentLang == "ko" {
                center.requestAuthorization(options: options) { (granted, error) in
                    if !granted {
                        let alertController = UIAlertController(title: "알람 권한", message: "설정에서 코랄타임에게 알람 권한을 주세요.", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.default, handler: nil))
                        view.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            else {
                center.requestAuthorization(options: options) { (granted, error) in
                    if !granted {
                        let alertController = UIAlertController(title: "Notification Unauthorized", message: "Please authorize this app in Settings to receive Coral Time Notification.", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                        view.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // List all pending Notifications
    static func listAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
            for item in notifications {
                print(item.identifier)
                print(item.content)
            }
        }
    }
    
    // Cancel all pending Notifications
    static func cancelAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    // Manage Notification depending on the status
    static func manageNotification(view: ActionsViewController) {
        if currentLang == "ko" {
            var status = ""
            if view.thisPlan?.noti != true {
                status = "꺼짐"
            }
            else {
                status = "켜짐"
            }
            let alertController = UIAlertController(title: "코랄타임 알림", message:
                "상태: \(status)", preferredStyle: UIAlertController.Style.alert)
            
            if view.thisPlan?.noti != true {
                let createAction = UIAlertAction(title: "켜기", style: UIAlertAction.Style.default, handler: { _ in createNotification(plan: (view.thisPlan)!) })
                alertController.addAction(createAction)
            }
            else {
                let cancelAction = UIAlertAction(title: "끄기", style: UIAlertAction.Style.default, handler: { _ in cancelNotification(plan: (view.thisPlan)!) })
                alertController.addAction(cancelAction)
            }
            
            alertController.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.default,handler: nil))
            
            view.present(alertController, animated: true, completion: nil)
        }
        else {
            var status = ""
            if view.thisPlan?.noti != true {
                status = "Off"
            }
            else {
                status = "On"
            }
            let alertController = UIAlertController(title: "Coral Time Notification", message:
                "Status: \(status)", preferredStyle: UIAlertController.Style.alert)
            
            if view.thisPlan?.noti != true {
                let createAction = UIAlertAction(title: "Turn On", style: UIAlertAction.Style.default, handler: { _ in createNotification(plan: (view.thisPlan)!) })
                alertController.addAction(createAction)
            }
            else {
                let cancelAction = UIAlertAction(title: "Turn Off", style: UIAlertAction.Style.default, handler: { _ in cancelNotification(plan: (view.thisPlan)!) })
                alertController.addAction(cancelAction)
            }

            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            
            view.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func createNotification(plan: PlanCD) {
        let actionSet = CDManager.loadActions(plan: plan)
        
        var title = ""
        if plan.emoji!.count > 0 {
            title = (plan.emoji)! + " "
        }
        title += (plan.title)!
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Get yourself moving!"
        content.sound = UNNotificationSound.default
        
        let date = procCalcedTime(target: (plan.target)!, actionSet: actionSet)
        let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                print("Error in adding Notification Request")
            }
        }
        CDManager.notiPlan(plan: plan, flag: true, identifier: request.identifier)
        
        // Firebase Analytics
        FirebaseManager.createNoti(emoji: plan.emoji!, title: plan.title!, date: date)
    }
    
    static func cancelNotification(plan: PlanCD) {
        let center = UNUserNotificationCenter.current()
        let identifier = plan.noti_id
        center.removePendingNotificationRequests(withIdentifiers: [identifier!])
        CDManager.notiPlan(plan: plan, flag: false, identifier: "")
    }
    
}
