//
//  CarInShopTableViewCell.swift
//  WorkShopAutomation
//
//  Created by Apple on 29/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CarInShopTableViewCell: UITableViewCell {

    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var switchServices: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
