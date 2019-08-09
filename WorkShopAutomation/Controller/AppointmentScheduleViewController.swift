//
//  AppointmentScheduleViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 19/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class AppointmentScheduleViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    var phoneNumber = ""   //Recieving Data
    var RegNumbers = [String]()
    var value = ""
    
    var setDate = ""
    var setTime = ""
    var setDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(phoneNumber)
        getAllCarsofuser()
    }
    
    func getAllCarsofuser(){
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
    
    
    @IBAction func btnSearchDetails(_ sender: Any) {
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.style = UIActivityIndicatorView.Style.gray
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
        
        let urlString = "\(AppDelegate.WcfUrl)AppointmentDetails"
        let param =
            [
                "phoneNumber":"\(phoneNumber)",
                "RegNo":"\(value)"
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
                        let outPut = dlc.value(forKey: "AppointmentDetailsResult") as! NSArray
                        for item in outPut
                        {
                            let tempitem = item as! NSDictionary
                            print(tempitem)
                            self.setDate = (tempitem.value(forKey: "Date") as! String)
                            self.setTime = (tempitem.value(forKey: "Time") as! String)
                            self.setDay = (tempitem.value(forKey: "Day") as! String)
                        }
                        if((self.setDate == "") && (self.setTime == ""))
                        {
                            let alert = UIAlertController(title: "Appointment", message: "No Record Found", preferredStyle: .alert)
                            let btn = UIAlertAction(title: "Ok", style: .default)
                            alert.addAction(btn)
                            self.present (alert, animated: true, completion: nil)
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                    //self.activityIndicator.stopAnimating()
                                    //self.activityIndicator.isHidden = true
                                    print("\(self.setDate) and \(self.setTime) exists")
                                    self.lblDate.text = self.setDate
                                    self.lblTime.text = self.setTime
                                    self.lblDay.text = self.setDay
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
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
        self.pickerView.reloadAllComponents()
        value = RegNumbers[row]
    }
    
}
