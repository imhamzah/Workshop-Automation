//
//  ArrivingCarTableViewCell.swift
//  WorkShopAutomation
//
//  Created by Apple on 21/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ArrivingCarTableViewCell: UITableViewCell {
    @IBOutlet weak var lblRegNo: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
