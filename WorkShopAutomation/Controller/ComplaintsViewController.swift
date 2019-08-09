//
//  ComplaintsViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 27/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ComplaintsViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    var phoneNumber = ""
    var value = ""
    var Dates = [String]()
    
   
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(phoneNumber)
        getDatesOfCustomerVisits()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Dates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Dates[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.pickerView.reloadAllComponents()
        value = Dates[row]
    }
    
    @IBAction func btnGetDetails(_ sender: Any) {
        print(value)
        performSegue(withIdentifier: "segDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segDetails"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.Date = value
            destinationVC.phoneNumber = phoneNumber
        }
        
    }
    
    func getDatesOfCustomerVisits()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getDatesOfCustomerVisits"
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
                            let outPut = dlc.value(forKey: "getDatesOfCustomerVisitsResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.Dates.append(tempitem as! String)
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
