//
//  DetailsViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 27/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class DetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var Date = ""
    var phoneNumber = ""
    
    var Services = [String]()
    var AddServices = [String]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtComplaints: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        getServicesOfCustomerOnDate()
        print(Date)
        print(phoneNumber)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailsTableViewCell
        cell.lblSerName.text = Services[indexPath.row]
        
        cell.btnSwitch.isOn = false
        cell.btnSwitch.tag = indexPath.row // for detect which row switch Changed
        cell.btnSwitch.addTarget(self, action: #selector(switchStatus(_:)), for: .valueChanged)
        return cell
    }
    
    @objc func switchStatus(_ sender:switches){
        
        //---------------------------
            if !AddServices.contains(Services[sender.tag])
            {
                AddServices.append(Services[sender.tag])
            }
            else if AddServices.contains(Services[sender.tag]){
                if !sender.isOn {
                    if let index = AddServices.index(of: Services[sender.tag]) {
                        AddServices.remove(at: index)
                    }
                }
            }
        //--------------------------
    }
    
    @IBAction func btnAddComplaint(_ sender: Any) {
        //print(AddServices)
        saveComplaints()
    }
    
    func saveComplaints(){
        let urlString = "\(AppDelegate.WcfUrl)Complaints"
        for index in AddServices{
            let param =
                [
                    "Owner_Id":"\(phoneNumber)",
                    "Comp_Name":"\(index)",
                    "Comp_Details":"\(String(describing: txtComplaints.text!))"
            ]
            let header = ["Content-Type":"application/json"]
            Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers:header).responseJSON
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
                            print("Data Saved Successfully")
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func getServicesOfCustomerOnDate()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getServicesOfCustomerOnDate"
            let param =
                [
                    "Owner_Id":"\(phoneNumber)",
                    "Date":"\(self.Date)"
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
                            let outPut = dlc.value(forKey: "getServicesOfCustomerOnDateResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.Services.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
}
