//
//  AddPlanTableViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 4/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class AddPlanTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Global Variables
    var previousVC = PlansTableViewController()
    var emojiChanged: Bool = false
    
    // UI Part
    @IBOutlet weak var titleEmoji: UIButton!
    @IBOutlet weak var planTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planTitle.delegate = self
        
        let ranPlan = RandomText.getRanPlan()
        planTitle.placeholder = String(ranPlan[1])
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func emojiPressed(_ sender: Any) {
        performSegue(withIdentifier: "addPlanToEmojiSegue", sender: self)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let titleText = planTitle.text
        if titleText!.count > 0 {
            var emoji = titleEmoji.titleLabel!.text!
            if !emojiChanged {
                emoji = ""
            }
            CDManager.addPlan(
                emoji: emoji,
                title: planTitle.text!,
                target: getDatePicker(),
                order: Int16(previousVC.planSet.count)
            )
        }
        navigationController?.popViewController(animated: true)
    }
    
    func getDatePicker() -> Date {
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
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
