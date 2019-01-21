//
//  AboutViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 9/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func emailPressed(_ sender: Any) {
        sendEmail()
    }
    
    @IBAction func websitePressed(_ sender: Any) {
        guard let url = URL(string: "https://kevink1103.github.io/") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func feedbackPressed(_ sender: Any) {
        guard let url = URL(string: "https://kevink1103.github.io/blog/2019/01/10/coral-time-feedback.html") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func privacyPressed(_ sender: Any) {
        guard let url = URL(string: "https://kevink1103.github.io/blog/2019/01/10/coral-time-privacy-policy.html") else { return }
        UIApplication.shared.open(url)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["kevink1103@gmail.com"])
            mail.setMessageBody("<p>[Coral Time]</p><br/>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
