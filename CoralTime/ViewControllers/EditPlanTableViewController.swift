//
//  EditPlanTableViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 8/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class EditPlanTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Global Variables
    var previousVC = PlansTableViewController()
    var planIndex = 0
    var thisPlan: PlanCD? = nil
    
    // UI Part
    @IBOutlet weak var titleEmoji: UITextField!
    @IBOutlet weak var planTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleEmoji.delegate = self
        planTitle.delegate = self
        
        // Load This Action
        thisPlan = previousVC.planSet[planIndex]
        titleEmoji.text = thisPlan!.emoji
        planTitle.text = thisPlan!.title
        datePicker.setDate((thisPlan?.target)!, animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let titleText = planTitle.text
        if titleText!.count > 0 {
            CDManager.updatePlan(
                plan: thisPlan!,
                emoji: titleEmoji.text!,
                title: planTitle.text!,
                target: getDatePicker()
            )
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removePressed(_ sender: Any) {
        previousVC.planSet = CDManager.removePlan(
            planSet: previousVC.planSet,
            index: planIndex
        )
        // Remove the Last View Controller from Navigation Stack
        // if it is ActionsViewController
        var navigationArray = self.navigationController?.viewControllers
        let lastViewController = navigationArray![(navigationArray!.count)-2]
        if (lastViewController is ActionsViewController) {
            navigationArray!.remove(at: (navigationArray?.count)! - 2)
            navigationController?.viewControllers = navigationArray!
        }
        navigationController?.popViewController(animated: true)
    }
    
    func getDatePicker() -> Date {
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        return datePicker.date
    }
    
    // Limit titleEmoji Length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 20
        if textField == titleEmoji {
            maxLength = 5
        }
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= maxLength // replace 1 for your max length value
    }
    
    // Return Key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
