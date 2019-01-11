//
//  CDManager.swift
//  CoralTime
//
//  Created by Kevin Kim on 4/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// Manage Core Data
class CDManager {
    
    // Load Plans and Sort
    static func loadPlans(view: PlansTableViewController) -> [PlanCD] {
        var planSet: [PlanCD] = []
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let plansCD = try? context.fetch(PlanCD.fetchRequest()) as? [PlanCD] {
                if let plans = plansCD {
                    planSet = plans
                }
            }
        }
        planSet = planSet.sorted { (left, right) -> Bool in
            left.order < right.order
        }
        return planSet
    }
    
    // Load Actions inside a Plan and Sort
    static func loadActions(view: ActionsViewController) -> [ActionCD] {
        var actionSet: [ActionCD] = []
        actionSet = view.thisPlan?.actionR?.allObjects as! [ActionCD]
        actionSet = actionSet.sorted { (left, right) -> Bool in
            left.order < right.order
        }
        return actionSet
    }

    // Add a Plan
    static func addPlan(view: AddPlanTableViewController) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let plan = PlanCD(entity: PlanCD.entity(), insertInto: context)
            plan.emoji = view.titleEmoji.text!
            plan.title = view.planTitle.text!
            plan.target = view.getDatePicker()
            plan.order = Int16(view.previousVC.planSet.count.advanced(by: 1))
            print(plan)
            try? context.save()
        }
        // Firebase Analytics
        Analytics.logEvent("add_plan", parameters: [
            "emoji": view.titleEmoji.text! as NSObject,
            "title": view.planTitle.text! as NSObject,
            "target_time": DateToString(date: view.getDatePicker()) as NSObject
            ])
    }

    // Add an Action inside a Plan
    static func addAction(view: AddActionTableViewController) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let action = ActionCD(entity: ActionCD.entity(), insertInto: context)
            action.emoji = view.titleEmoji.text!
            action.title = view.actionTitle.text!
            action.duration = view.getDatePicker()
            action.order = Int16(view.previousVC.actionSet.count)
            view.previousVC.thisPlan?.addToActionR(action)
            try? context.save()
        }
        // Firebase Analytics
        Analytics.logEvent("add_action", parameters: [
            "plan": (view.previousVC.thisPlan?.emoji)! + " " + (view.previousVC.thisPlan?.title)! as NSObject,
            "emoji": view.titleEmoji.text! as NSObject,
            "title": view.actionTitle.text! as NSObject,
            "duration": TimeToString(date: view.getDatePicker()) as NSObject
            ])
    }
    
    // Update a Plan
    static func updatePlan(view: EditPlanTableViewController) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            view.thisPlan!.emoji = view.titleEmoji.text
            view.thisPlan!.title = view.planTitle.text!
            view.thisPlan!.target = view.getDatePicker()
            try? context.save()
        }
    }
    
    // Update an Action inside a Plan
    static func updateAction(view: EditActionTableViewController) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            view.thisAction!.emoji = view.titleEmoji.text
            view.thisAction!.title = view.actionTitle.text!
            view.thisAction!.duration = view.getDatePicker()
            try? context.save()
        }
    }
    
    // Remove a Plan
    static func removePlan(view: PlansTableViewController, index: Int) -> [PlanCD] {
        var planSet: [PlanCD] = view.planSet
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(planSet[index])
            planSet.remove(at: index)
            for (idx, plan) in planSet.enumerated() {
                plan.order = Int16(idx)
            }
            try? context.save()
        }
        return planSet
    }
    
    // Remove an Action
    static func removeAction(view: ActionsViewController, index: Int) -> [ActionCD] {
        var actionSet: [ActionCD] = view.actionSet
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(actionSet[index])
            actionSet.remove(at: index)
            for (idx, action) in actionSet.enumerated() {
                action.order = Int16(idx)
            }
            try? context.save()
        }
        return actionSet
    }
    
    // Rearrage Plans
    static func rearrangePlans(view: PlansTableViewController, from: Int, to: Int) -> [PlanCD] {
        var planSet: [PlanCD] = view.planSet
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let source = planSet[from]
            planSet.remove(at: from)
            planSet.insert(source, at: to)
            
            for (idx, plan) in planSet.enumerated() {
                plan.order = Int16(idx)
                try? context.save()
            }
        }
        return planSet
    }
    
    // Rearrage Actions
    static func rearrangeActions(view: ActionsViewController, from: Int, to: Int) -> [ActionCD] {
        var actionSet: [ActionCD] = view.actionSet
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let source = actionSet[from]
            actionSet.remove(at: from)
            actionSet.insert(source, at: to)
            
            for (idx, action) in actionSet.enumerated() {
                action.order = Int16(idx)
                try? context.save()
            }
        }
        return actionSet
    }
    
}
