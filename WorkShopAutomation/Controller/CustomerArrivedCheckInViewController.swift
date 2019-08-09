//
//  CustomerArrivedCheckInViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 31/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class CustomerArrivedCheckInViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lblResponsetoCustomer: UILabel!
    @IBOutlet weak var lblMechanicName: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
    
    var phoneNo = ""    // Recieving Data
    var value = ""      // Selecting UIPickerView value
    var Mechanic = ""
    var MechanicName = ""
    var RegNumbers = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCarsofUser()
        getMechanicForCar()
        print(phoneNo)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RegNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RegNumbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        value = RegNumbers[row]
        print(value)
    }
    
    
    @IBAction func btnCustomerCheckedIn(_ sender: Any) {
        //update mechanic for car here
        print(Mechanic)
        print("You're Checked In")
        print(phoneNo)
        print(value)
        lblResponsetoCustomer.text = "Pls sit in waiting area until your car is ready!"
        lblRemarks.text = "Available!"
        getMechanicName()
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let DateforCheckin = dateFormatter.string(from: today as Date).capitalized
        print(DateforCheckin)
        
        let urlString = "\(AppDelegate.WcfUrl)UpdateMechanic"
        let param =
            [
                "MecID":"\(Mechanic)",
                "phoneNo":"\(phoneNo)",
                "RegNo":"\(value)",
                "Date":"\(DateforCheckin)"
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
                        let outPut = dlc.value(forKey: "UpdateMechanicResult") as! Bool
                        if(outPut == true)
                        {
                            print("Mechanic Assigned")
                        }
                        else
                        {
                            print("Mechanic isn't Assigned")
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    //Getting Mechanic Name
    func getMechanicName(){
        do {
            let urlString = "\(AppDelegate.WcfUrl)getMechanicName"
            let param =
                [
                    "Mec_Id":"\(Mechanic)"
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
                            let outPut = dlc.value(forKey: "getMechanicNameResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as! NSDictionary
                                print(tempitem)
                                self.MechanicName = tempitem.value(forKey: "Name") as! String
                                self.lblMechanicName.text = self.MechanicName
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    //Getting registered Cars of logged in user
    func getAllCarsofUser(){
        do {
            let urlString = "\(AppDelegate.WcfUrl)getCar"
            let param =
                [
                    "Owner_Id":"\(phoneNo)"
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
                            let outPut = dlc.value(forKey: "getCarResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                
                                print("------")
                                print(tempitem)
                                print("------")
                                self.RegNumbers.append(tempitem as! String)
                            }
                            self.pickerView.reloadAllComponents()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    //Getting Mechanic for Car to Work on it
    func getMechanicForCar()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getMechanicForCar"
            
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
                            let outPut = dlc.value(forKey: "getMechanicForCarResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as! NSDictionary
                                print(tempitem)
                                self.Mechanic = tempitem.value(forKey: "Mec_Id") as! String
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
}
