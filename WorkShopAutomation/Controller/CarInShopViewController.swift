//
//  CarInShopViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 28/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class CarInShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segOut: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblRegNo: UILabel!
    @IBOutlet weak var carColor: UILabel!
    //Recieving Data
    var regNum = ""
    var phoneNumber = ""
    var Date = ""
    //--------------
    var Color = ""
    var Electrical = [String]()
    var Mechanical = [String]()
    var CustomerSelected = [String]()
    //--------------
    var AddElectrical = [String]()
    var AddMechanical = [String]()
    var AddCustomerSelected = [String]()
    
    var todayDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(regNum)
        print(phoneNumber)
        print(Date)
        lblRegNo.text = regNum
        getCarColor()
        getElectricalServices()
        getMechanicalServices()
        getCustomerSelected()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value = 0
        switch segOut.selectedSegmentIndex{
        case 0:
            value = Mechanical.count
            break
        case 1:
            value = Electrical.count
            break
        case 2:
            value = CustomerSelected.count
            break
        default:
            break
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CarInShopTableViewCell
        
        switch segOut.selectedSegmentIndex{
        case 0:
            cell.lblServices.text = Mechanical[indexPath.row]
            cell.switchServices.isOn = false
            break
        case 1:
            cell.lblServices.text = Electrical[indexPath.row]
            cell.switchServices.isOn = false
            break
        case 2:
            cell.lblServices.text = CustomerSelected[indexPath.row]
            cell.switchServices.isOn = true
            break
        default:
            break
        }
        
        cell.switchServices.tag = indexPath.row // for detect which row switch Changed
        cell.switchServices.addTarget(self, action: #selector(switchStatus(_:)), for: .valueChanged)
        return cell
    }
    
    @objc func switchStatus(_ sender:switches){
        if segOut.selectedSegmentIndex == 0
        {
            if !AddMechanical.contains(Mechanical[sender.tag]){
                AddMechanical.append(Mechanical[sender.tag])
            }
            else if AddMechanical.contains(Mechanical[sender.tag]){
                if !sender.isOn {
                    if let index = AddMechanical.index(of: Mechanical[sender.tag]) {
                        AddMechanical.remove(at: index)
                    }
                }
            }
        }
        //--------------------------------------------------------------------------
        
        if segOut.selectedSegmentIndex == 1
        {
            if !AddElectrical.contains(Electrical[sender.tag]){
                AddElectrical.append(Electrical[sender.tag])
            }
            else if AddElectrical.contains(Electrical[sender.tag]){
                if !sender.isOn {
                    if let index = AddElectrical.index(of: Electrical[sender.tag]) {
                        AddElectrical.remove(at: index)
                    }
                }
            }
        }
        //--------------------------------------------------------------------------
        
        if segOut.selectedSegmentIndex == 2
        {
//            if sender.isOn{
//                AddCustomerSelected.append(CustomerSelected[sender.tag])
//            }
//            else if !sender.isOn{
//                if !sender.isOn {
//                    if let index = AddCustomerSelected.index(of: CustomerSelected[sender.tag]) {
//                        CustomerSelected.remove(at: index)
//                    }
//                }
//            }
        }
        //--------------------------------------------------------------------------
    }
    
    @IBAction func btnDone(_ sender: Any) {
        saveServicestoDB()
        print(AddMechanical)
        print(AddElectrical)
        //AddCustomerSelected = CustomerSelected
        print(CustomerSelected)
    }
    
    func saveServicestoDB()
    {
        let urlString = "\(AppDelegate.WcfUrl)saveDoneServices"
        for index in AddMechanical{
            let param =
                [
                    "S_Name":"\(index)",
                    "Reg_No":"\(regNum)",
                    "Date":"\(todayDate)"
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
        //------------------------------------------------------------------------------------------
        for index in AddElectrical{
            let param =
                [
                    "S_Name":"\(index)",
                    "Reg_No":"\(regNum)",
                    "Date":"\(todayDate)"

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
        //---------------------------------------------------------------------------------------------
        for index in CustomerSelected{
            let param =
                [
                    "S_Name":"\(index)",
                    "Reg_No":"\(regNum)",
                    "Date":"\(todayDate)"
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
    
    @IBAction func segmentedControlClicked(_ sender: Any) {
        self.tableView.reloadData()
    }
    func getElectricalServices()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getElectricalService"
            let hearder = ["Content-Type":"application/json"]
            Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: hearder).responseJSON
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
                            let outPut = dlc.value(forKey: "getElectricalServiceResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.Electrical.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    //----------------------------------------------------------------------------
    
    func getMechanicalServices()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getMechanicalService"
            let hearder = ["Content-Type":"application/json"]
            Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: hearder).responseJSON
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
                            let outPut = dlc.value(forKey: "getMechanicalServiceResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.Mechanical.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    //----------------------------------------------------------------------------
    
    func getCustomerSelected()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getCustomerSelectedServices"
            let param =
                [
                    "RegNo":"\(regNum)",
                    "Date":"\(todayDate)"
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
                            let outPut = dlc.value(forKey: "getCustomerSelectedServicesResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.CustomerSelected.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    //--------------------------------------------------------------------------
    func getCarColor()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getCarColorForMec"
            let param =
                [
                    "Reg_No":"\(regNum)"
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
                            let outPut = dlc.value(forKey: "getCarColorForMecResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as! NSDictionary
                                print(tempitem)
                                self.Color = tempitem.value(forKey: "color") as! String
                                self.carColor.text = self.Color
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
}
