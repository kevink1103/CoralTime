//
//  Mode.swift
//  CoralTime
//
//  Created by Kevin Kim on 21/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

class Mode {
    static let currentLang: String = Locale.preferredLanguages[0]
    // When development: true
    // When deploy: false
    // in FirebaseManager
    // in SampleText
    static let development = false
}
