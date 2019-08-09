//
//  ProfileViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 10/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
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
        self.pickerView.reloadAllComponents()
        value = RegNumbers[row]
        self.getCarCC()
        print(CC)
    }
    @IBOutlet weak var pickerView: UIPickerView!
    var value = ""        //sending value to AddAppointmentViewController
    var phoneNumber = ""  //getting phone Number of logged in user
    var RegNumbers = [String]()
    
    var CC = ""
    override func viewDidLoad(){
        super.viewDidLoad()
        print(phoneNumber)
        self.getAllCarsofUser()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool){
        print(phoneNumber)
        print(RegNumbers)
    }
    @IBAction func btnAdd(_ sender: Any){
            self.getCarCC()
        
        performSegue(withIdentifier: "segSelectCar", sender: self)
    }
    
    //-----------------------------------------------------------------------------------------------
    func getCarCC()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getCarCCsForServices"
            let param =
                [
                    "Reg_No":"\(value)"
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
                            let outPut = dlc.value(forKey: "getCarCCsForServicesResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as! NSDictionary
                                print(tempitem)
                                self.CC = tempitem.value(forKey: "CC") as! String
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segSelectCar"{
            let destinationVC = segue.destination as! CheckinViewController
            destinationVC.RegNo = value
            destinationVC.phoneNumber = phoneNumber
            destinationVC.CC = CC
        }
    }
    func getAllCarsofUser(){
        do {
        let urlString = "\(AppDelegate.WcfUrl)getCar"
        let param =
            [
                "Owner_Id":"\(phoneNumber)"
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
}
