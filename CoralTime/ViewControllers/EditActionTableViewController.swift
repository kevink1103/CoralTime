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
    var emojiChanged: Bool = false
    
    // UI Part
    @IBOutlet weak var titleEmoji: UIButton!
    @IBOutlet weak var actionTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionTitle.delegate = self
        
        // Load This Action
        thisAction = previousVC.actionSet[actionIndex]
        if thisAction!.emoji!.count > 0 {
            titleEmoji.setTitle(thisAction!.emoji, for: .normal)
        }
        actionTitle.text = thisAction!.title
        datePicker.setDate((thisAction?.duration)!, animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func emojiPressed(_ sender: Any) {
        performSegue(withIdentifier: "editActionToEmojiSegue", sender: self)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let titleText = actionTitle.text
        if titleText!.count > 0 {
            var emoji = titleEmoji.titleLabel!.text!
            if !emojiChanged && thisAction?.emoji == "" {
                emoji = ""
            }
            CDManager.updateAction(
                action: thisAction!,
                emoji: emoji,
                title: actionTitle.text!,
                duration: getDatePicker()
            )
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removePressed(_ sender: Any) {
        previousVC.actionSet = CDManager.removeAction(
            actionSet: previousVC.actionSet,
            index: actionIndex
        )
        navigationController?.popViewController(animated: true)
    }
    
    func getDatePicker() -> Date {
        datePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
        return datePicker.date
    }
    
    // Limit titleEmoji Length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
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
