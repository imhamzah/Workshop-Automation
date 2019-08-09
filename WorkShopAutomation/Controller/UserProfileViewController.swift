//
//  UserProfileViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 10/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class UserProfileViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
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
    }
    

    @IBOutlet weak var pickerView: UIPickerView!
    var phoneNumber = ""   //recieving data
    var RegNumbers = [String]()
    var value = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(phoneNumber)
        getAllCarsofUser()
    }
    //Deleting selected car (from uipickerview) of user
    @IBAction func btnRemoveCar(_ sender: Any){
        do {
            let urlString = "\(AppDelegate.WcfUrl)deleteCar"
            let param =
                [
                    "Owner_Id":"\(phoneNumber)",
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
                            let outPut = dlc.value(forKey: "deleteCarResult") as! Bool
                            if(outPut == true){
                                
                                let alert = UIAlertController(title: "Profile", message: "Vehicle Removed!", preferredStyle: .alert)
                                let btn = UIAlertAction(title: "Ok", style: .default)
                                alert.addAction(btn)
                                self.present (alert, animated: true, completion: nil)
                                
                                self.pickerView.reloadAllComponents()
                            }
                            else{
                                let alert = UIAlertController(title: "Profile", message: "Something went wrong! Try Again.", preferredStyle: .alert)
                                let btn = UIAlertAction(title: "Ok", style: .default)
                                alert.addAction(btn)
                                self.present (alert, animated: true, completion: nil)
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
    
}
