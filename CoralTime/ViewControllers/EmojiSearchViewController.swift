//
//  EmojiSearchViewController.swift
//  CoralTime
//
//  Created by Kevin Kim on 24/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import emojidataios

class EmojiSearchViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Global Variables
    var emojiSet: [String] = EmojiManager.allEmojis
    var recentEmojiCD: [EmojiCD] = []
    var recentEmojiSet: [String] = []
    
    // UI Part
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection View Inset
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 25, bottom: 15, right: 25)
        
        // Search Bar
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.tintColor = ColorManager.highlightColor
        navigationItem.searchController = search
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Load Recent Emoji
        loadRecentEmojis()
        
    }
    
    func loadRecentEmojis() {
        recentEmojiCD = CDManager.loadRecentEmoji()
        if (recentEmojiCD.count > 20) {
            for count in 20...(recentEmojiCD.count-1) {
                CDManager.removeEmoji(emojiCD: recentEmojiCD[count])
            }
        }
        for single in recentEmojiCD {
            if let emoji = single.emoji {
                recentEmojiSet.append(emoji)
            }
        }
    }
    
    @IBAction func trashPressed(_ sender: Any) {
        updateLastViewController(title: "➕", emojiMode: false)
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0) ? recentEmojiSet.count : emojiSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emojiHeader", for: indexPath) as! CustomCollectionReusableView
        
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                if Mode.currentLang == "ko" {
                    reusableview.title.text = "최근"
                }
                else {
                    reusableview.title.text = "RECENT"
                }
            }
            else {
                if Mode.currentLang == "ko" {
                    reusableview.title.text = "이모지"
                }
                else {
                    reusableview.title.text = "EMOJI"
                }
            }
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
        
        var thisEmoji: String = ""
        if (indexPath.section == 0) {
            thisEmoji = recentEmojiSet[indexPath.row]
        }
        else {
            thisEmoji = emojiSet[indexPath.row]
        }
        cell.emojiLabel.text = thisEmoji
        cell.emojiLabel?.font = UIFont.systemFont(ofSize: 35)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var thisEmoji: String? = nil
        
        if (indexPath.section == 0) {
            thisEmoji = recentEmojiSet[indexPath.row]
        }
        else {
            thisEmoji = emojiSet[indexPath.row]
        }
        
        if let emoji = thisEmoji {
            for emojiCD in recentEmojiCD {
                if emojiCD.emoji == emoji {
                    CDManager.removeEmoji(emojiCD: emojiCD)
                }
            }
            CDManager.addEmoji(emoji: emoji)
            updateLastViewController(title: emoji, emojiMode: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateLastViewController(title: String, emojiMode: Bool) {
        // Get the Last View Controller from Navigation Stack
        var navigationArray = self.navigationController?.viewControllers
        let lastViewController = navigationArray![(navigationArray!.count)-2]
        
        if lastViewController is AddPlanTableViewController {
            let lastViewController: AddPlanTableViewController = lastViewController as! AddPlanTableViewController
            lastViewController.titleEmoji.setTitle(title, for: .normal)
            lastViewController.emojiChanged = emojiMode
        }
        else if lastViewController is EditPlanTableViewController {
            let lastViewController: EditPlanTableViewController = lastViewController as! EditPlanTableViewController
            lastViewController.titleEmoji.setTitle(title, for: .normal)
        }
        else if lastViewController is AddActionTableViewController {
            let lastViewController: AddActionTableViewController = lastViewController as! AddActionTableViewController
            lastViewController.titleEmoji.setTitle(title, for: .normal)
            lastViewController.emojiChanged = emojiMode
        }
        else if lastViewController is EditActionTableViewController {
            let lastViewController: EditActionTableViewController = lastViewController as! EditActionTableViewController
            lastViewController.titleEmoji.setTitle(title, for: .normal)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        emojiSet = EmojiManager.searchEmoji(searchText: searchController.searchBar.text!)
        collectionView.reloadData()
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
