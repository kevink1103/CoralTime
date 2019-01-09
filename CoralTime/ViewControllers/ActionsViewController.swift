//
//  ActionsViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 4/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import AudioToolbox

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
        
        // Table Row Height and Inset
        tableView.rowHeight = 60
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: calcedFrame.frame.height + targetFrame.frame.height + 10, right: 0)
        
        // Navigation Title
        var accTitle = ""
        if thisPlan!.emoji!.count > 0 {
            accTitle = thisPlan!.emoji! + " "
        }
        accTitle.append(thisPlan!.title!)
        navItem.title = accTitle
        
        // Floating Times Frame
        let screenSize: CGRect = UIScreen.main.bounds
        calcedFrame.frame = CGRect(x: calcedFrame.frame.minX, y: calcedFrame.frame.minY, width: screenSize.width, height: calcedFrame.frame.maxY - calcedFrame.frame.minY)
        calcedFrame.frame = calcedFrame.frame
        targetFrame.frame = CGRect(x: targetFrame.frame.minX, y: targetFrame.frame.minY, width: screenSize.width, height: targetFrame.frame.maxY - targetFrame.frame.minY)
        targetFrame.frame = targetFrame.frame
        drawFrame(image: calcedFrame, width_rate: 0.88, height_rate: 0.85)
        drawFrame(image: targetFrame, width_rate: 0.8, height_rate: 0.8)
        
        // Time Text Color
        targetTime.textColor = UIColor.white
        calcedTime.textColor = UIColor.white

        // Long Press
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        actionSet = CDManager.loadActions(view: self)
        tableView.reloadData()
        
        // Update Time Texts
        targetTime.text = DateToString(date: (thisPlan?.target)!)
        calcedTime.text = DateToString(date: procCalcedTime(target: (thisPlan?.target)!, actionSet: actionSet))
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
    
    func drawFrame(image: UIImageView, width_rate: CGFloat, height_rate: CGFloat) {
        image.layer.backgroundColor = UIColor.init(white: 0, alpha: 0).cgColor
        
        // Set the size of rectangle
        let rectWidth = image.frame.width * width_rate
        let rectHeight = image.frame.height * height_rate
        // Find center of actual frame to set rectangle in middle
        let xf: CGFloat = (image.frame.width - rectWidth) / 2
        let yf: CGFloat = (image.frame.height - rectHeight) / 2
        let rect = CGRect(x: xf, y: yf, width: CGFloat(rectWidth), height: CGFloat(rectHeight))
        let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: rectHeight).cgPath
        
        let backgroundColor = ColorManager.highlightColor.cgColor
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = clipPath
        shapeLayer.fillColor = backgroundColor
        shapeLayer.cornerRadius = 1.00;
        
        // Shadow
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.85
        shapeLayer.shadowOffset = CGSize(width: 3, height: 3)
        shapeLayer.shadowRadius = 8.5
        shapeLayer.shouldRasterize = false
        
        image.layer.addSublayer(shapeLayer)
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
