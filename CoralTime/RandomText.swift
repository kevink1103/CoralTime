//
//  RandomText.swift
//  CoralTime
//
//  Created by Kevin Kim on 18/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit

class RandomText {
    static let planSample: [String: String] = [
        "✈️": "To Seoul",
        "🚅": "To Beijing",
        "🏖": "To Beach w/...",
        "🛥": "Boat Party!",
        "🎤": "Karaoke w/ Freddie",
        "🍽": "Dinner w/ Friends",
        "🦷": "Dentist Appointment",
        "👨‍💻": "Go to Work",
        "👜": "Go Shopping",
        "💍": "Propose",
        "🏋️‍♂️": "Gym",
        "🎷": "Go for Concert",
        "🏰": "Go to Disneyland",
        "🎞": "Catch Movie",
        "🗽": "Go Travel",
        "👨‍🍳": "Cook",
        "🍳": "Cook",
        ]
    
    static let actionSample: [String: String] = [
        "🚶‍♂️": "Walk",
        "🚶‍♀️": "Walk",
        "🏃‍♂️": "Run",
        "🏃‍♀️": "Run",
        "👫": "Date",
        "👭": "Date",
        "👬": "Date",
        "👨‍💻": "Coding",
        "👜": "Shopping",
        "🎒": "Packing",
        "🎤": "Sing",
        "🎮": "Play Games",
        "♟": "Play Chess",
        "🎰": "Gamble",
        "🚗": "Drive",
        "🚙": "Drive",
        "🚌": "Bus",
        "🚑": "Hospital",
        "🚲": "Bike",
        "🚅": "Train",
        "✈️": "Plane",
        "🛥": "Boat",
        "🗽": "Travel",
        "🎡": "Amusement Park",
        "🎢": "Amusement Park",
        "🏨": "Hotel",
        "🏦": "Bank",
        "🎞": "Movie",
        "📞": "Phone Call",
        "☎️": "Phone Call",
        "🚿": "Shower",
        "🗝": "Lock My Place",
        ]
    
    static func getRanPlan() -> [String] {
        let index: Int = Int(arc4random_uniform(UInt32(RandomText.planSample.count)))
        let randomKey = Array(RandomText.planSample.keys)[index]
        let randomVal = RandomText.planSample[randomKey]!
        return [randomKey, randomVal]
    }
    
    static func getRanAction() -> [String] {
        let index: Int = Int(arc4random_uniform(UInt32(RandomText.actionSample.count)))
        let randomKey = Array(RandomText.actionSample.keys)[index]
        let randomVal = RandomText.actionSample[randomKey]!
        return [randomKey, randomVal]
    }
}
