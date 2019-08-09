//
//  BillViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class BillViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalBillView: UIView!
    @IBOutlet weak var lblTotalCost: UILabel!
    
    //Recieving Data
    var phoneNumber = ""
    var todayDate = ""
    var status = ""
    
    
    //--------------
    var totalCost = ""
    
    var RegNo = ""
    var DateToday = ""
    
    var servicesName = [String]()
    var servicesCost = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        RegNo = UserDefaults.standard.string(forKey: "RegNo")!
        DateToday = UserDefaults.standard.string(forKey: "DateToday")!
        
        if (status == "Active"){
            getServicesCost()
            getServicesName()
            getTotalCost()
        }
        
        else{
            tableView.isHidden = true
            totalBillView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if status == "Active"{
            return servicesName.count
        }
        else{
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BillTableViewCell
        cell.lblServiceName.text = servicesName[indexPath.row]
        cell.lblServiceCost.text = servicesCost[indexPath.row]
        return cell
    }
    
    func getServicesName()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getServicesName"
            let param =
                [
                    "Reg_No":"\(RegNo)",
                    "Date":"\(DateToday)"
            ]
            let hearder = ["Content-Type":"application/json"]
            
            Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearder).responseJSON
                {
                    response in
                    print(response.request as Any)
                    print(response.response as Any)
                    print(response.data as Any)
                    print(response.result as Any)
                    switch response.result
                    {
                    case .success:
                        if let JSON = response.result.value
                        {
                            let dlc = (JSON as! NSDictionary)
                            print(dlc)
                            let outPut = dlc.value(forKey: "getServicesNameResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.servicesName.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    //---------------------------------------------------------------------------
    
    func getServicesCost()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getServicesCost"
            let param =
                [
                    "Reg_No":"\(RegNo)",
                    "Date":"\(DateToday)"
            ]
            let hearder = ["Content-Type":"application/json"]
            Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearder).responseJSON
                {
                    response in
                    print(response.request as Any)
                    print(response.response as Any)
                    print(response.data as Any)
                    print(response.result as Any)
                    switch response.result
                    {
                    case .success:
                        if let JSON = response.result.value
                        {
                            let dlc = (JSON as! NSDictionary)
                            print(dlc)
                            let outPut = dlc.value(forKey: "getServicesCostResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.servicesCost.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    //---------------------------------------------------------------------------
    
    func getTotalCost()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getTotalCost"
            let param =
                [
                    "Reg_No":"\(RegNo)",
                    "Date":"\(DateToday)"
            ]
            let hearder = ["Content-Type":"application/json"]
            Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearder).responseJSON
                {
                    response in
                    print(response.request as Any)
                    print(response.response as Any)
                    print(response.data as Any)
                    print(response.result as Any)
                    switch response.result
                    {
                    case .success:
                        if let JSON = response.result.value
                        {
                            let dlc = (JSON as! NSDictionary)
                            print(dlc)
                            let outPut = dlc.value(forKey: "getTotalCostResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as! NSDictionary
                                print(tempitem)
                                self.totalCost = tempitem.value(forKey: "Cost") as! String
                            }
                            self.lblTotalCost.text = self.totalCost
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
}
