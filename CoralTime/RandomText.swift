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
    static let currentLang: String = Mode.currentLang
    
    static let planSample_en: [String: String] = [
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
    
    static let actionSample_en: [String: String] = [
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
    
    static let planSample_ko: [String: String] = [
        "✈️": "홍콩 가자",
        "🚅": "부산행",
        "🏖": "해변으로 가요",
        "🛥": "배 타기",
        "🎤": "노래방 가기",
        "🍽": "저녁 약속",
        "🦷": "치과 예약",
        "👨‍💻": "돈 벌러",
        "👜": "샤핑",
        "💍": "프로포즈",
        "🏋️‍♂️": "운동",
        "🎷": "콘서트 가기",
        "🏰": "환상의 나라로",
        "🎞": "영화 보기",
        "🗽": "여행 가기",
        "👨‍🍳": "오늘은 내가 요리사",
        "🍳": "요리하기",
        ]
    
    static let actionSample_ko: [String: String] = [
        "🚶‍♂️": "걷기",
        "🚶‍♀️": "걷기",
        "🏃‍♂️": "뛰기",
        "🏃‍♀️": "뛰기",
        "👫": "데이뚜",
        "👭": "데이뚜",
        "👬": "데이뚜",
        "👨‍💻": "코딩",
        "👜": "샤핑",
        "🎒": "짐 싸기",
        "🎤": "노래하기",
        "🎮": "게임하기",
        "♟": "체크메이트!",
        "🎰": "탕진잼",
        "🚗": "부릉부릉",
        "🚙": "붕붕이",
        "🚌": "버스",
        "🚑": "병원",
        "🚲": "자전거 타기",
        "🚅": "칙칙폭폭",
        "✈️": "비행기",
        "🛥": "배 타기",
        "🗽": "여행 가기",
        "🎡": "관람차",
        "🎢": "롤러코스터",
        "🏨": "쉬었다 가기",
        "🏦": "은행",
        "🎞": "여행",
        "📞": "전화하기",
        "☎️": "전화하기",
        "🚿": "샤월",
        "🗝": "문 잠그기",
        ]
    
    static func getRanPlan() -> [String] {
        var planSample: [String:String]? = nil
        if currentLang == "ko" {
            planSample = planSample_ko
        }
        else {
            planSample = planSample_en
        }
        
        if planSample == nil {
            return ["", ""]
        }
        let index: Int = Int(arc4random_uniform(UInt32(planSample!.count)))
        let randomKey = Array(planSample!.keys)[index]
        let randomVal = planSample![randomKey]!
        return [randomKey, randomVal]
    }
    
    static func getRanAction() -> [String] {
        var actionSample: [String:String]? = nil
        if currentLang == "ko" {
            actionSample = actionSample_ko
        }
        else {
            actionSample = actionSample_en
        }
        
        if actionSample == nil {
            return ["", ""]
        }
        let index: Int = Int(arc4random_uniform(UInt32(actionSample!.count)))
        let randomKey = Array(actionSample!.keys)[index]
        let randomVal = actionSample![randomKey]!
        return [randomKey, randomVal]
    }
}
