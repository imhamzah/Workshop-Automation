//
//  ServicesTableViewCell.swift
//  WorkShopAutomation
//
//  Created by Apple on 13/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
