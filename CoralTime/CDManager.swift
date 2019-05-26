//
//  CDManager.swift
//  CoralTime
//
//  Created by Kevin Kim on 4/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import CoreData
import Firebase

// Manage Core Data
class CDManager {
    // Used to store Context
    static var masterContext: NSManagedObjectContext? = nil
    
    // Load Plans and Sort
    static func loadPlans() -> [PlanCD] {
        var planSet: [PlanCD] = []
        
        if let plansCD = ((try? masterContext?.fetch(PlanCD.fetchRequest()) as? [PlanCD]) as [PlanCD]??) {
            if let plans = plansCD {
                planSet = plans.sorted { (left, right) -> Bool in
                    left.order < right.order
                }
            }
        }
        return planSet
    }
    
    // Load Actions inside a Plan and Sort
    static func loadActions(plan: PlanCD) -> [ActionCD] {
        var actionSet: [ActionCD] = []
        
        if let actionsCD = plan.actionR?.allObjects as? [ActionCD] {
            actionSet = actionsCD.sorted { (left, right) -> Bool in
                left.order < right.order
            }
        }
        return actionSet
    }
    
    // Load all recently used Emoji
    static func loadRecentEmoji() -> [EmojiCD] {
        var emojiSet: [EmojiCD] = []
        
        if let emojisCD = ((try? masterContext?.fetch(EmojiCD.fetchRequest()) as? [EmojiCD]) as [EmojiCD]??) {
            if let emojis = emojisCD {
                emojiSet = emojis.sorted { (left, right) -> Bool in
                    left.timestamp! > right.timestamp!
                }
            }
        }
        return emojiSet
    }

    // Add a Plan
    static func addPlan(emoji: String, title: String, target: Date, order: Int16) {
        let plan = PlanCD(entity: PlanCD.entity(), insertInto: masterContext!)
        
        if emoji == " " {
            plan.emoji = ""
        }
        else {
            plan.emoji = emoji
        }
        plan.title = title
        plan.target = target
        plan.noti = false
        plan.noti_id = ""
        plan.order = order
        do {
            try masterContext?.save()
        } catch {
            masterContext?.delete(plan)
            print ("There was an error")
        }

        // Firebase Analytics
        FirebaseManager.addPlan(emoji: emoji, title: title, target: target)
    }

    // Add an Action inside a Plan
    static func addAction(plan: PlanCD, emoji: String, title: String, duration: Date, order: Int16) {
        let action = ActionCD(entity: ActionCD.entity(), insertInto: masterContext!)
        
        if emoji == " " {
            action.emoji = ""
        }
        else {
            action.emoji = emoji
        }
        action.title = title
        action.duration = duration
        action.order = order
        plan.addToActionR(action)
        do {
            try masterContext?.save()
        } catch {
            masterContext?.delete(action)
            print ("There was an error")
        }
        
        // Firebase Analytics
        FirebaseManager.addAction(plan: plan, emoji: emoji, title: title, duration: duration)
    }
    
    // Add an EmojiCD record
    static func addEmoji(emoji: String) {
        let single = EmojiCD(entity: EmojiCD.entity(), insertInto: masterContext!)
        
        single.emoji = emoji
        single.timestamp = Date()
        
        do {
            try masterContext?.save()
        } catch {
            masterContext?.delete(single)
            print ("There was an error")
        }
    }
    
    // Update Notification Info in a Plan
    static func notiPlan(plan: PlanCD, flag: Bool, identifier: String) {
        plan.noti = flag
        plan.noti_id = identifier
        do {
            try masterContext?.save()
        } catch {
            print ("There was an error")
        }
    }
    
    // Update a Plan
    static func updatePlan(plan: PlanCD, emoji: String, title: String, target: Date) {
        plan.emoji = emoji
        plan.title = title
        plan.target = target
        do {
            try masterContext?.save()
        } catch {
            print ("There was an error")
        }
    }
    
    // Update an Action inside a Plan
    static func updateAction(action: ActionCD, emoji: String, title: String, duration: Date) {
        action.emoji = emoji
        action.title = title
        action.duration = duration
        do {
            try masterContext?.save()
        } catch {
            print ("There was an error")
        }
    }
    
    // Remove a Plan
    static func removePlan(planSet: [PlanCD], index: Int) -> [PlanCD] {
        var resultSet: [PlanCD] = planSet
        
        masterContext?.delete(resultSet[index])
        do {
            try masterContext?.save()
        } catch {
            print ("There was an error")
        }
        
        resultSet.remove(at: index)
        
        for (idx, plan) in resultSet.enumerated() {
            plan.order = Int16(idx)
        }
        return resultSet
    }
    
    // Remove an Action
    static func removeAction(actionSet: [ActionCD], index: Int) -> [ActionCD] {
        var resultSet: [ActionCD] = actionSet
        
        masterContext?.delete(resultSet[index])
        do {
            try masterContext?.save()
        } catch {
            print ("There was an error")
        }
        
        resultSet.remove(at: index)
        
        for (idx, action) in resultSet.enumerated() {
            action.order = Int16(idx)
        }
        return resultSet
    }
    
    // Remove an EmojiCD Object
    static func removeEmoji(emojiCD: EmojiCD) {
        masterContext?.delete(emojiCD)
        do {
            try masterContext?.save()
        } catch {
            print ("There was an error")
        }
    }
    
    // Rearrage Plans
    static func rearrangePlans(planSet: [PlanCD], from: Int, to: Int) -> [PlanCD] {
        var resultSet: [PlanCD] = planSet
        let source = resultSet[from]
        
        resultSet.remove(at: from)
        resultSet.insert(source, at: to)
        
        for (idx, plan) in resultSet.enumerated() {
            plan.order = Int16(idx)
            do {
                try masterContext?.save()
            } catch {
                print ("There was an error")
            }
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
            do {
                try masterContext?.save()
            } catch {
                print ("There was an error")
            }
        }
        return resultSet
    }
    
    // Delete All for Development
    static func deleteAll() {
        for entity in ["PlanCD", "ActionCD", "EmojiCD"] {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try masterContext?.execute(deleteRequest)
                try masterContext?.save()
            } catch {
                print ("There was an error")
            }
        }
    }
    
}
