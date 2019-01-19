//
//  DateManager.swift
//  CoralTime
//
//  Created by Kevin Kim on 4/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit

func DateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
    
    let converted = dateFormatter.string(from: date)
    return converted
}

func TimeToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    let converted = dateFormatter.string(from: date)
    return converted
}

func StringToDate(text: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
    
    let converted = dateFormatter.date(from: text)!
    return converted
}

func procCalcedTime(target: Date, actionSet: [ActionCD]) -> Date {
    if actionSet.count == 0 {
        return target
    }
    
    var accTime = 0  // Accumulated time in seconds
    
    for action in actionSet {
        let time = TimeToString(date: action.duration!).split(separator: ":")
        accTime += Int(time[0])! * 3600
        accTime += Int(time[1])! * 60
    }
    return target - TimeInterval(accTime)
}
