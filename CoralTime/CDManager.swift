//
//  CDManager.swift
//  CoralTime
//
//  Created by Kevin Kim on 4/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase

// Manage Core Data
class CDManager {
    
    // Used to store Context
    static var masterContext: NSManagedObjectContext? = nil
    
    // Load Plans and Sort
    static func loadPlans() -> [PlanCD] {
        var planSet: [PlanCD] = []
        
        if let plansCD = try? self.masterContext!.fetch(PlanCD.fetchRequest()) as? [PlanCD] {
            if let plans = plansCD {
                planSet = plans
            }
        }
        planSet = planSet.sorted { (left, right) -> Bool in
            left.order < right.order
        }
        return planSet
    }
    
    // Load Actions inside a Plan and Sort
    static func loadActions(plan: PlanCD) -> [ActionCD] {
        var actionSet: [ActionCD] = []
        
        actionSet = plan.actionR?.allObjects as! [ActionCD]
        actionSet = actionSet.sorted { (left, right) -> Bool in
            left.order < right.order
        }
        return actionSet
    }

    // Add a Plan
    static func addPlan(emoji: String, title: String, target: Date, order: Int16) {
        let plan = PlanCD(entity: PlanCD.entity(), insertInto: self.masterContext!)
        
        plan.emoji = emoji
        plan.title = title
        plan.target = target
        plan.noti = false
        plan.noti_id = ""
        plan.order = order
        try? self.masterContext!.save()

        // Firebase Analytics
        Analytics.logEvent("add_plan", parameters: [
            "emoji": emoji as NSObject,
            "title": title as NSObject,
            "target_time": DateToString(date: target) as NSObject
            ])
    }

    // Add an Action inside a Plan
    static func addAction(plan: PlanCD, emoji: String, title: String, duration: Date, order: Int16) {
        let action = ActionCD(entity: ActionCD.entity(), insertInto: self.masterContext!)
        
        action.emoji = emoji
        action.title = title
        action.duration = duration
        action.order = order
        plan.addToActionR(action)
        try? self.masterContext!.save()
        
        // Firebase Analytics
        Analytics.logEvent("add_action", parameters: [
            "plan": (plan.emoji)! + " " + (plan.title)! as NSObject,
            "emoji": emoji as NSObject,
            "title": title as NSObject,
            "duration": TimeToString(date: duration) as NSObject
            ])
    }
    
    // Update Notification Info in a Plan
    static func notiPlan(plan: PlanCD, flag: Bool, identifier: String) {
        plan.noti = flag
        plan.noti_id = identifier
        try? self.masterContext!.save()
    }
    
    // Update a Plan
    static func updatePlan(plan: PlanCD, emoji: String, title: String, target: Date) {
        plan.emoji = emoji
        plan.title = title
        plan.target = target
        try? self.masterContext!.save()
    }
    
    // Update an Action inside a Plan
    static func updateAction(action: ActionCD, emoji: String, title: String, duration: Date) {
        action.emoji = emoji
        action.title = title
        action.duration = duration
        try? self.masterContext!.save()
    }
    
    // Remove a Plan
    static func removePlan(planSet: [PlanCD], index: Int) -> [PlanCD] {
        var resultSet: [PlanCD] = planSet
        
        self.masterContext!.delete(resultSet[index])
        try? self.masterContext!.save()
        
        resultSet.remove(at: index)
        for (idx, plan) in resultSet.enumerated() {
            plan.order = Int16(idx)
        }
        return resultSet
    }
    
    // Remove an Action
    static func removeAction(actionSet: [ActionCD], index: Int) -> [ActionCD] {
        var resultSet: [ActionCD] = actionSet
        
        self.masterContext!.delete(resultSet[index])
        try? self.masterContext!.save()
        
        resultSet.remove(at: index)
        for (idx, action) in resultSet.enumerated() {
            action.order = Int16(idx)
        }
        return resultSet
    }
    
    // Rearrage Plans
    static func rearrangePlans(planSet: [PlanCD], from: Int, to: Int) -> [PlanCD] {
        var resultSet: [PlanCD] = planSet
        let source = resultSet[from]
        
        resultSet.remove(at: from)
        resultSet.insert(source, at: to)
        
        for (idx, plan) in resultSet.enumerated() {
            plan.order = Int16(idx)
            try? self.masterContext!.save()
        }
        return resultSet
    }
    
    // Rearrage Actions
    static func rearrangeActions(actionSet: [ActionCD], from: Int, to: Int) -> [ActionCD] {
        var resultSet: [ActionCD] = actionSet
        let source = resultSet[from]
        
        resultSet.remove(at: from)
        resultSet.insert(source, at: to)
        
        for (idx, action) in resultSet.enumerated() {
            action.order = Int16(idx)
            try? self.masterContext!.save()
        }
        return resultSet
    }
    
    static func deleteAll() {
        for entity in ["PlanCD", "ActionCD"] {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try self.masterContext!.execute(deleteRequest)
                try self.masterContext!.save()
            } catch {
                print ("There was an error")
            }
        }
    }
    
}
