//
//  ReviewCarsViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 22/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ReviewCarsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegNum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewCarsTableViewCell
        
        cell.lblReg.text = RegNum[indexPath.row]
        //cell.lblReg.textColor = UIColor.blue
        cell.lblModel.text = Model[indexPath.row]
        cell.lblColor.text = Color[indexPath.row]
        return cell
    }
    
    var RegNum = [String]()
    var Model = [String]()
    var Color = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(RegNum)
        print("------")
        print(Model)
        print("------")
        print(Color)
    }
}
