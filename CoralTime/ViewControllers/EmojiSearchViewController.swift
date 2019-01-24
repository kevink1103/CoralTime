//
//  EmojiSearchViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 24/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import emojidataios

class EmojiSearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Global Variables
    var emojiSet: [String] = EmojiManager.allEmojis
    
    // UI Part
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
        cell.emojiLabel.text = emojiSet[indexPath.row]
        cell.emojiLabel?.font = UIFont.systemFont(ofSize: 30)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the Last View Controller from Navigation Stack
        var navigationArray = self.navigationController?.viewControllers
        let lastViewController = navigationArray![(navigationArray!.count)-2]
        
        if lastViewController is AddPlanTableViewController {
            let lastViewController: AddPlanTableViewController = lastViewController as! AddPlanTableViewController
            lastViewController.titleEmoji.setTitle(emojiSet[indexPath.row], for: .normal)
            lastViewController.emojiChanged = true
        }
        else if lastViewController is EditPlanTableViewController {
            let lastViewController: EditPlanTableViewController = lastViewController as! EditPlanTableViewController
            lastViewController.titleEmoji.setTitle(emojiSet[indexPath.row], for: .normal)
            lastViewController.emojiChanged = true
        }
        else if lastViewController is AddActionTableViewController {
            let lastViewController: AddActionTableViewController = lastViewController as! AddActionTableViewController
            lastViewController.titleEmoji.setTitle(emojiSet[indexPath.row], for: .normal)
            lastViewController.emojiChanged = true
        }
        else if lastViewController is EditActionTableViewController {
            let lastViewController: EditActionTableViewController = lastViewController as! EditActionTableViewController
            lastViewController.titleEmoji.setTitle(emojiSet[indexPath.row], for: .normal)
            lastViewController.emojiChanged = true
        }
        navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        emojiSet = EmojiManager.searchEmoji(searchText: searchText)
        collectionView.reloadData()
    }
    
    // Search Key
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
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
