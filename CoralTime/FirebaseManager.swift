//
//  FirebaseManager.swift
//  CoralTime
//
//  Created by Kevin Kim on 21/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    static let enabled: Bool = !Mode.development
    
    static func addPlan(emoji: String, title: String, target: Date) {
        if enabled {
            Analytics.logEvent("add_plan", parameters: [
                "emoji": emoji as NSObject,
                "title": title as NSObject,
                "target_time": DateToString(date: target) as NSObject
                ])
        }
    }
    
    static func addAction(plan: PlanCD, emoji: String, title: String, duration: Date) {
        if enabled {
            Analytics.logEvent("add_action", parameters: [
                "plan": (plan.emoji)! + " " + (plan.title)! as NSObject,
                "emoji": emoji as NSObject,
                "title": title as NSObject,
                "duration": TimeToString(date: duration) as NSObject
                ])
        }
    }
    
    static func createNoti(emoji: String, title: String, date: Date) {
        if enabled {
            Analytics.logEvent("create_noti", parameters: [
                "emoji": emoji as NSObject,
                "title": title as NSObject,
                "target_time": DateToString(date: date) as NSObject
                ])
        }
    }
}
