//
//  AddActionTableViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 7/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AddActionTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Global Variables
    var previousVC = ActionsViewController()
    
    // UI Part
    @IBOutlet weak var titleEmoji: UITextField!
    @IBOutlet weak var actionTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleEmoji.delegate = self
        actionTitle.delegate = self
        
        var ranAction = SampleText.getRanAction().split(separator: "#")
        titleEmoji.placeholder = String(ranAction[0])
        actionTitle.placeholder = String(ranAction[1])
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let titleText = actionTitle.text
        if titleText!.count > 0 {
            CDManager.addAction(view: self)
        }
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
