//
//  DetailsTableViewCell.swift
//  WorkShopAutomation
//
//  Created by Apple on 27/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSerName: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
