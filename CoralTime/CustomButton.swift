//
//  CustomButton.swift
//  CoralTime
//
//  Created by Kevin Kim on 17/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
            }
            else {
                self.backgroundColor = UIColor.clear
            }
            
        }
    }
}
