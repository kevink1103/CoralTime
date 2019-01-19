import Foundation
import UIKit

class SampleText {
    static let data: [[String:Date]:[String:Date]] = [
        ["👨‍💻;To Work": StringToDate(text: "2019-01-15 07:30")]: [
            "💆‍♂️;Meditation": StringToDate(text: "2019-01-15 00:10"),
            "🚿;Shower": StringToDate(text: "2019-01-15 00:20"),
            "🚽;Can't Tell": StringToDate(text: "2019-01-15 00:20"),
            "👔;Get Dressed": StringToDate(text: "2019-01-15 00:10"),
            "🚌;Commute": StringToDate(text: "2019-01-15 00:30"),
        ],
        ["👨‍🍳;Cook for Dinner": StringToDate(text: "2019-01-15 07:30")]: [
            "💆‍♂️;Meditation": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["🏟;Watch Match": StringToDate(text: "2019-01-15 07:30")]: [
            "💆‍♂️;Meditation": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["🕶;Party Night!": StringToDate(text: "2019-01-15 07:30")]: [
            "💆‍♂️;Meditation": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["🏨;Check-In": StringToDate(text: "2019-01-15 07:30")]: [
            "💆‍♂️;Meditation": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["✈️;To Barcelona (CX321)": StringToDate(text: "2019-01-16 00:15")]: [
            "🚿;Shower": StringToDate(text: "2019-01-15 00:20"),
            "🎒;Packing": StringToDate(text: "2019-01-15 00:30"),
            "🗝;Lock My Place": StringToDate(text: "2019-01-15 00:10"),
            "🚌;Bus to the Airport": StringToDate(text: "2019-01-15 01:10"),
            "🏷;Ticket & Check-In": StringToDate(text: "2019-01-15 00:45"),
            "🚪;Find the Gate": StringToDate(text: "2019-01-15 00:20"),
            "👾;Take Rest": StringToDate(text: "2019-01-15 00:20"),
        ],
    ]
    
    static func loadSampleData() {
        for (plan, action) in data {
            var tokens = plan.keys.first!.split(separator: ";")
            let planEmoji = tokens[0]
            let planTitle = tokens[1]
            let planTarget = plan.values.first!
            print(planEmoji, planTitle, planTarget)
            
            for (title, date) in action {
                var actionTokens = title.split(separator: ";")
                let actionEmoji = actionTokens[0]
                let actionTitle = actionTokens[1]
                print(actionEmoji, actionTitle, date)
            }
        }
    }
}

func StringToDate(text: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
    
    let converted = dateFormatter.date(from: text)!
    return converted
}

SampleText.loadSampleData()
