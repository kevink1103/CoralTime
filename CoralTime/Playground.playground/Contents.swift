import Foundation
import UIKit

class SampleText {
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
        "🎞": "Go for Movie",
        "🗽": "Go Travel",
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
    
    static func getRanPlan() -> String {
        let index: Int = Int(arc4random_uniform(UInt32(SampleText.planSample.count)))
        let randomKey = Array(SampleText.planSample.keys)[index]
        let randomVal = SampleText.planSample[randomKey]!
        return randomKey + " " + randomVal
    }
    
    static func getRanAction() -> String {
        let index: Int = Int(arc4random_uniform(UInt32(SampleText.actionSample.count)))
        let randomKey = Array(SampleText.actionSample.keys)[index]
        let randomVal = SampleText.actionSample[randomKey]!
        return randomKey + " " + randomVal
    }
}


for _ in 1...5 {
    print(SampleText.getRanPlan())
}

for _ in 1...5 {
    print(SampleText.getRanAction())
}
