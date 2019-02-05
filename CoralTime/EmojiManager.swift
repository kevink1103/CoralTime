//
//  EmojiManager.swift
//  CoralTime
//
//  Created by Kevin Kim on 24/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import emojidataios

class EmojiManager {
    static let categories: [EmojiCategory] = [
        EmojiCategory.PEOPLE,
        EmojiCategory.ACTIVITY,
        EmojiCategory.FOODS,
        EmojiCategory.PLACES,
        EmojiCategory.OBJECTS,
        EmojiCategory.NATURE,
        EmojiCategory.SYMBOLS,
        EmojiCategory.FLAGS
    ]
    
    static let allEmojis = loadEmojis()
    static let allAliases = loadAliases(emojiSet: allEmojis)
    
    static func loadEmojis() -> [String] {
        var emojiSet: [String] = []
        for category in categories {
            for emoji in EmojiParser.getEmojisForCategory(category) {
                emojiSet.append(emoji)
            }
        }
        return emojiSet
    }
    
    static func loadAliases(emojiSet: [String]) -> [String] {
        var aliasSet: [String] = []
        for emoji in emojiSet {
            aliasSet.append(EmojiParser.parseUnicode(emoji))
        }
        return aliasSet
    }
    
    static func searchEmoji(searchText: String) -> [String] {
        if searchText == "" {
            return allEmojis
        }
        
        var searchResult: [String] = []
        for emoji in allEmojis {
            if searchText == emoji {
                searchResult.append(emoji)
            }
        }
        for alias in allAliases {
            if alias.contains(searchText.lowercased()) {
                searchResult.append(EmojiParser.parseAliases(alias))
            }
        }
        return searchResult
    }
}
