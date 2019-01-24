//
//  AddActionTableViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 7/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class AddActionTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Global Variables
    var previousVC = ActionsViewController()
    var emojiChanged: Bool = false
    
    // UI Part
    @IBOutlet weak var titleEmoji: UIButton!
    @IBOutlet weak var actionTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionTitle.delegate = self
        
        var ranAction = RandomText.getRanAction()
        actionTitle.placeholder = String(ranAction[1])
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func emojiPressed(_ sender: Any) {
        performSegue(withIdentifier: "addActionToEmojiSegue", sender: self)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let titleText = actionTitle.text
        if titleText!.count > 0 {
            var emoji = titleEmoji.titleLabel!.text!
            if !emojiChanged {
                emoji = ""
            }
            CDManager.addAction(
                plan: previousVC.thisPlan!,
                emoji: emoji,
                title: actionTitle.text!,
                duration: getDatePicker(),
                order: Int16(previousVC.actionSet.count)
            )
        }
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
