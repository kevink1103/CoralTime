//
//  SampleText.swift
//  CoralTime
//
//  Created by Kevin Kim on 9/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit

class SampleText {
    static let enabled: Bool = Mode.development
    static let currentLang: String = Mode.currentLang
    /*
    ["0;👨‍💻;To Work": StringToDate(text: "2019-01-15 07:30")]: [
        "0;💆‍♂️;Meditation": StringToDate(text: "2019-01-15 00:10"),
        "1;🚿;Shower": StringToDate(text: "2019-01-15 00:20"),
        "2;🚽;Can't Tell": StringToDate(text: "2019-01-15 00:20"),
        "3;👔;Get Dressed": StringToDate(text: "2019-01-15 00:10"),
        "4;🚌;Commute": StringToDate(text: "2019-01-15 00:30"),
    ],
    */
    static let text_en: [[String:Date]:[String:Date]] = [
        ["0;👨‍💻;To Work": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;Meditation": StringToDate(text: "2019-01-15 00:10"),
            "1;🚿;Shower": StringToDate(text: "2019-01-15 00:20"),
            "2;🚽;Can't Tell": StringToDate(text: "2019-01-15 00:20"),
            "3;👔;Get Dressed": StringToDate(text: "2019-01-15 00:10"),
            "4;🚌;Commute": StringToDate(text: "2019-01-15 00:30"),
        ],
        ["1;👨‍🍳;Cook for Dinner": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;Meditation": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["2;🏟;Watch Match": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;Meditation": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["3;🕶;Party Night!": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;Meditation": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["4;🏨;Check-In": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;Meditation": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["5;✈️;To Barcelona (CX321)": StringToDate(text: "2019-01-16 00:15")]: [
            "0;🚿;Shower": StringToDate(text: "2019-01-15 00:20"),
            "1;🎒;Packing": StringToDate(text: "2019-01-15 00:30"),
            "2;🗝;Lock My Place": StringToDate(text: "2019-01-15 00:10"),
            "3;🚌;Bus to the Airport": StringToDate(text: "2019-01-15 01:10"),
            "4;🏷;Ticket & Check-In": StringToDate(text: "2019-01-15 00:45"),
            "5;🚪;Find the Gate": StringToDate(text: "2019-01-15 00:20"),
            "6;👾;Take Rest": StringToDate(text: "2019-01-15 00:20"),
        ],
    ]
    
    static let text_ko: [[String:Date]:[String:Date]] = [
        ["0;👨‍💻;돈 벌러": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;뒤척뒤척": StringToDate(text: "2019-01-15 00:10"),
            "1;🚿;샤월": StringToDate(text: "2019-01-15 00:20"),
            "2;🚽;모닝X": StringToDate(text: "2019-01-15 00:20"),
            "3;👔;옷": StringToDate(text: "2019-01-15 00:10"),
            "4;🚇;지옥철": StringToDate(text: "2019-01-15 00:30"),
        ],
        ["1;👨‍🍳;요리하기": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;뒤척뒤척": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["2;🏟;경기 관람": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;뒤척뒤척": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["3;🕶;불금!": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;뒤척뒤척": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["4;🏨;호캉스 체크인": StringToDate(text: "2019-01-15 07:30")]: [
            "0;💆‍♂️;뒤척뒤척": StringToDate(text: "2019-01-15 07:30"),
        ],
        ["5;✈️;홍콩 가자 (KE603)": StringToDate(text: "2019-01-24 08:20")]: [
            "0;🚿;샤월": StringToDate(text: "2019-01-15 00:20"),
            "1;🎒;짐 싸기": StringToDate(text: "2019-01-15 00:30"),
            "2;🗝;문 잠그기": StringToDate(text: "2019-01-15 00:10"),
            "3;🚌;공항버스": StringToDate(text: "2019-01-15 01:20"),
            "4;🏷;티켓 & 체크인": StringToDate(text: "2019-01-15 00:45"),
            "5;🚪;게이트를 찾아서": StringToDate(text: "2019-01-15 00:20"),
            "6;👾;고요한 휴식시간": StringToDate(text: "2019-01-15 00:20"),
        ],
        ]
    
    static func loadSampleText() {
        if enabled {
            CDManager.deleteAll()
            var text: [[String:Date]:[String:Date]]? = nil
            
            if currentLang == "ko" {
                text = text_ko
            }
            else {
                text = text_en
            }
            
            
            if text == nil {
                return
            }
            for (plan, action) in text! {
                let tokens = plan.keys.first!.split(separator: ";")
                let planOrder = Int16(tokens[0])!
                let planEmoji = String(tokens[1])
                let planTitle = String(tokens[2])
                let planTarget = plan.values.first!
                
                CDManager.addPlan(
                    emoji: planEmoji,
                    title: planTitle,
                    target: planTarget,
                    order: planOrder
                )
                
                let planSet = CDManager.loadPlans()
                var thisPlan: PlanCD? = nil
                for plan in planSet {
                    if (plan.title == planTitle) {
                        thisPlan = plan
                        break
                    }
                }
                
                for (title, duration) in action {
                    let actionTokens = title.split(separator: ";")
                    let actionOrder = Int16(actionTokens[0])!
                    let actionEmoji = String(actionTokens[1])
                    let actionTitle = String(actionTokens[2])
                    
                    CDManager.addAction(
                        plan: thisPlan!,
                        emoji: actionEmoji,
                        title: actionTitle,
                        duration: duration,
                        order: actionOrder
                    )
                }
            }
        }
    }
    
}
