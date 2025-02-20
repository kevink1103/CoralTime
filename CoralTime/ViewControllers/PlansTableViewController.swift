//
//  PlansTableViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 4/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import AudioToolbox
import FirebaseAnalytics

class PlansTableViewController: UITableViewController {
    
    // Global Variables
    let currentLang: String = Mode.currentLang
    var planSet: [PlanCD] = []
    
    // UI Part
    @IBOutlet var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Tint
        self.navigationController?.navigationBar.tintColor = ColorManager.highlightColor
        
        // Long Press
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        // Notification Request
        NotificationManager.requestAuthorization(view: self)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationtem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        planSet = CDManager.loadPlans()
        tableView.reloadData()
        
        // Update All Notifications
        for plan in planSet {
            if plan.noti == true {
                NotificationManager.cancelNotification(plan: plan)
                NotificationManager.createNotification(plan: plan)
            }
        }
        // Debug
        // NotificationManager.listAllNotifications()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        let thisPlan = planSet[sender.tag]
        
        if sender.isOn {
            NotificationManager.createNotification(plan: thisPlan)
        }
        else {
            NotificationManager.cancelNotification(plan: thisPlan)
        }
        // Debug
        // NotificationManager.listAllNotifications()
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if indexPath.row >= 0 {
                    if tableView.isEditing != true {
                        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                        feedbackGenerator.impactOccurred()
                    }
                    editTable()
                }
            }
        }
    }
    
    @objc func editTable() {
        // Set Table to Edit Mode
        var done: String = ""
        
        if tableView.isEditing != true {
            if currentLang == "ko" {
                done = "완료"
            }
            else {
                done = "Done"
            }
            
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: done, style: UIBarButtonItem.Style.done, target: self, action: #selector(editTable))
        }
        // Set Table to Normal Mode
        else {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planSet.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlanCell
        let thisPlan = planSet[indexPath.row]
        
        var accTitle = ""
        if thisPlan.emoji!.count > 0 {
            accTitle = thisPlan.emoji! + " "
        }
        accTitle.append(thisPlan.title!)
        cell.titleLabel?.text = accTitle
        cell.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
        cell.notiSwitch.tintColor = ColorManager.highlightColor
        cell.notiSwitch.tag = indexPath.row
        if thisPlan.noti != true {
            cell.notiSwitch.setOn(false, animated: true)
        }
        else {
            cell.notiSwitch.setOn(true, animated: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            performSegue(withIdentifier: "editPlanSegue", sender: indexPath.row)
        }
        else {
            performSegue(withIdentifier: "actionsSegue", sender: indexPath.row)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove this plan
            planSet = CDManager.removePlan(
                planSet: planSet,
                index: indexPath.row
            )
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        planSet = CDManager.rearrangePlans(
            planSet: planSet,
            from: fromIndexPath.row,
            to: to.row
        )
     }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let addVC = segue.destination as? AddPlanTableViewController {
            addVC.previousVC = self
        }
        else if let editVC = segue.destination as? EditPlanTableViewController {
            editVC.previousVC = self
            editVC.planIndex = (sender as? Int)!
        }
        else if let actionVC = segue.destination as? ActionsViewController {
            actionVC.previousVC = self
            actionVC.thisPlan = planSet[((sender as? Int)!)]
            actionVC.planIndex = (sender as? Int)!
        }
    }
    
}
