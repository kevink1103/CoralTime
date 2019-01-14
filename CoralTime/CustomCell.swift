//
//  CustomCell.swift
//  CoralTime
//
//  Created by Kevin Kim on 11/1/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit

class PlanCell: UITableViewCell {
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notiSwitch: UISwitch!
}

class ActionCell: UITableViewCell {
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}
