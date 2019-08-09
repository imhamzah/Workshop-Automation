//
//  AddAppointmentTableViewCell.swift
//  WorkShopAutomation
//
//  Created by Apple on 02/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AddAppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var Slot1: UIButton!
    @IBOutlet weak var Slot2: UIButton!
    @IBOutlet weak var Slot3: UIButton!
    @IBOutlet weak var Slot4: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
