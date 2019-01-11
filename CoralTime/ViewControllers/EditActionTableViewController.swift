//
//  EditActionTableViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 7/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class EditActionTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Global Variables
    var previousVC = ActionsViewController()
    var actionIndex = 0
    var thisAction: ActionCD? = nil
    
    // UI Part
    @IBOutlet weak var titleEmoji: UITextField!
    @IBOutlet weak var actionTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleEmoji.delegate = self
        actionTitle.delegate = self
        
        // Load This Action
        thisAction = previousVC.actionSet[actionIndex]
        titleEmoji.text = thisAction!.emoji
        actionTitle.text = thisAction!.title
        datePicker.setDate((thisAction?.duration)!, animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let titleText = actionTitle.text
        if titleText!.count > 0 {
            CDManager.updateAction(view: self)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removePressed(_ sender: Any) {
        previousVC.actionSet = CDManager.removeAction(view: previousVC, index: actionIndex)
        navigationController?.popViewController(animated: true)
    }
    
    func getDatePicker() -> Date {
        datePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
        return datePicker.date
    }
    
    // Limit titleEmoji Length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 20
        if textField == titleEmoji {
            maxLength = 1
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
