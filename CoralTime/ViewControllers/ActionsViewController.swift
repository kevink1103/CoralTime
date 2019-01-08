//
//  ActionsViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 4/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class ActionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Global Variables
    var previousVC = PlansTableViewController()
    var thisPlan: PlanCD? = nil
    var actionSet: [ActionCD] = []
    
    // UI Part
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var calcedFrame: UIImageView!
    @IBOutlet weak var targetFrame: UIImageView!
    @IBOutlet weak var calcedTime: UILabel!
    @IBOutlet weak var targetTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table Row Height
        tableView.rowHeight = 60
        
        // Navigation Title
        var accTitle = ""
        if thisPlan!.emoji!.count > 0 {
            accTitle = thisPlan!.emoji! + " "
        }
        accTitle.append(thisPlan!.title!)
        navItem.title = accTitle

        // Long Press
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        actionSet = CDManager.loadActions(view: self)
        tableView.reloadData()
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if indexPath.row >= 0 {
                     editTable()
                }
            }
        }
    }
    
    @objc func editTable() {
        // Set Table to Edit Mode
        if tableView.isEditing != true {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(editTable))
        }
        // Set Table to Normal Mode
        else {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    // MARK: - Table view data source
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath as IndexPath)
        let thisAction = actionSet[indexPath.row]
        
        var accTitle = ""
        if thisAction.emoji!.count > 0 {
            accTitle = thisAction.emoji! + " "
        }
        accTitle.append(thisAction.title!)
        cell.textLabel?.text = accTitle
        cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        cell.detailTextLabel?.text = TimeToString(date: thisAction.duration!)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 25)
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editActionSegue", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove this plan
            actionSet = CDManager.removeAction(view: self, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        actionSet = CDManager.rearrangeActions(view: self, from: fromIndexPath.row, to: to.row)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let addVC = segue.destination as? AddActionTableViewController {
            addVC.previousVC = self
        }
        else if let editVC = segue.destination as? EditActionTableViewController {
            editVC.previousVC = self
            editVC.actionIndex = (sender as? Int)!
        }
    }

}
