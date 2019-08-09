//
//  AddAppointmentViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 02/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class AddAppointmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
// FOr Slots and Date
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AddAppointmentTableViewCell
      
        cell.Day.text = dates[indexPath.row]
        
        cell.Slot1.tag = indexPath.row
        cell.Slot1.addTarget(self, action: #selector(monslot1(_:)), for: .touchUpInside)
        
        cell.Slot2.tag = indexPath.row
        cell.Slot2.addTarget(self, action: #selector(monslot2(_:)), for: .touchUpInside)
        
        cell.Slot3.tag = indexPath.row
        cell.Slot3.addTarget(self, action: #selector(monslot3(_:)), for: .touchUpInside)
        
        cell.Slot4.tag = indexPath.row
        cell.Slot4.addTarget(self, action: #selector(monslot4(_:)), for: .touchUpInside)
        return cell
    }
    
    var RegNo = ""     //recieving RegNo from CheckinViewController
    var phoneNumber = ""    //recieving phoneNo from CheckinViewController
    var kilometers = ""    //recieving kilometers from CheckinViewController
    var CC = ""     //recieving
    var dates = [String]()
    var slots = ["Slot1","Slot2","Slot3","Slot4"]

    var Day = ""
    
    var DateToDB = ""
    var SlotToDB = ""
    
    var selectedDateforAppointment = ""
    var SlotforAppointment = ""
    var selectedDate = ""

    @IBAction func btnAddAppointmentDetails(_ sender: Any) {
        updateSlotsintDB()
        performSegue(withIdentifier: "segAppointmentDetails", sender: self)
    }
    
    func updateSlotsintDB()
    {
        let urlString = "\(AppDelegate.WcfUrl)UpdateSlots"
        let param =
            [
                "date":"\(selectedDate)",
                "slot":"\(SlotforAppointment)"
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
                        let outPut = dlc.value(forKey: "UpdateSlotsResult") as! Bool
                        if(outPut == true)
                        {
                            print("Slot Updated")
                        }
                        else
                        {
                            print("Failed")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segAppointmentDetails"{
            let destinationVC = segue.destination as! ServicesViewController
            destinationVC.DatetoBe = selectedDate
            destinationVC.SlottoBe = SlotforAppointment
            destinationVC.phoneNumber = phoneNumber
            destinationVC.RegNumber = RegNo
            destinationVC.kilometers = kilometers
            destinationVC.AppointmentDay = Day
            destinationVC.CC = CC
        }
    }
        
    @objc func monslot1(_ sender:UIButton)
    {
        selectedDate = dates[sender.tag]
        SlotforAppointment = "Slot1"
        let urlString = "\(AppDelegate.WcfUrl)CheckStatus"
        let param =
            [
                "date":"\(dates[sender.tag])",
                "slot":"\(SlotforAppointment)",
                "day":"\("")"
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
                        let outPut = dlc.value(forKey: "CheckStatusResult") as! Bool
                        if(outPut == true)
                        {
                            print("Slot is Available")
                            //sender.backgroundColor = UIColor.green
                            let alert = UIAlertController(title: "Appointment", message: "Slot is Available!", preferredStyle: .alert)
                            let btn = UIAlertAction(title: "Ok", style: .default)
                            alert.addAction(btn)
                            self.present (alert, animated: true, completion: nil)
                        }
                        else
                        {
                            print("Full")
                            //sender.backgroundColor = UIColor.red
                            let alert = UIAlertController(title: "Appointment", message: "Slot is already Full!", preferredStyle: .alert)
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
    @objc func monslot2(_ sender:UIButton)
    {
        selectedDate = dates[sender.tag]
        SlotforAppointment = "Slot2"
        
        let urlString = "\(AppDelegate.WcfUrl)CheckStatus"
        let param =
            [
                "date":"\(dates[sender.tag])",
                "slot":"\(SlotforAppointment)",
                "day":"\("")"
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
                        let outPut = dlc.value(forKey: "CheckStatusResult") as! Bool
                        if(outPut == true)
                        {
                            print("Slot is Available")
                            //sender.backgroundColor = UIColor.green
                            let alert = UIAlertController(title: "Appointment", message: "Slot is Available!", preferredStyle: .alert)
                            let btn = UIAlertAction(title: "Ok", style: .default)
                            alert.addAction(btn)
                            self.present (alert, animated: true, completion: nil)
                            
                        }
                        else
                        {
                            print("Full")
                            //sender.backgroundColor = UIColor.red
                            let alert = UIAlertController(title: "Appointment", message: "Slot is already Full!", preferredStyle: .alert)
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
    @objc func monslot3(_ sender:UIButton)
    {
        selectedDate = dates[sender.tag]
        SlotforAppointment = "Slot3"
        
        let urlString = "\(AppDelegate.WcfUrl)CheckStatus"
        let param =
            [
                "date":"\(dates[sender.tag])",
                "slot":"\(SlotforAppointment)",
                "day":"\("")"
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
                        let outPut = dlc.value(forKey: "CheckStatusResult") as! Bool
                        if(outPut == true)
                        {
                            print("Slot is Available")
                            //sender.backgroundColor = UIColor.green
                            let alert = UIAlertController(title: "Appointment", message: "Slot is Available!", preferredStyle: .alert)
                            let btn = UIAlertAction(title: "Ok", style: .default)
                            alert.addAction(btn)
                            self.present (alert, animated: true, completion: nil)
                            
                        }
                        else
                        {
                            print("Full")
                            //sender.backgroundColor = UIColor.red
                            let alert = UIAlertController(title: "Appointment", message: "Slot is already Full!", preferredStyle: .alert)
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
    @objc func monslot4(_ sender:UIButton)
    {
        selectedDate = dates[sender.tag]
        SlotforAppointment = "Slot4"
        
        let urlString = "\(AppDelegate.WcfUrl)CheckStatus"
        let param =
            [
                "date":"\(dates[sender.tag])",
                "slot":"\(SlotforAppointment)",
                "day":"\("")"
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
                        let outPut = dlc.value(forKey: "CheckStatusResult") as! Bool
                        if(outPut == true)
                        {
                            print("Slot is Available")
                            sender.backgroundColor = UIColor.green
                            let alert = UIAlertController(title: "Appointment", message: "Slot is Available!", preferredStyle: .alert)
                            let btn = UIAlertAction(title: "Ok", style: .default)
                            alert.addAction(btn)
                            self.present (alert, animated: true, completion: nil)
                            
                        }
                        else
                        {
                            print("Full")
                            sender.backgroundColor = UIColor.red
                            let alert = UIAlertController(title: "Appointment", message: "Slot is already Full!", preferredStyle: .alert)
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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Phone")
        print(phoneNumber)
        print("Reg")
        print(RegNo)
        print("Kilo")
        print(kilometers)
        
        //--------------------------------------------------------
        for index1 in dates {
            for index2 in slots {
                let urlString = "\(AppDelegate.WcfUrl)CheckStatus"
                let param =
                    [
                        "date":"\(index1)",
                        "slot":"\(index2)",
                        "day":"\("")"
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
                                let outPut = dlc.value(forKey: "CheckStatusResult") as! Bool
                                if(outPut == true)
                                {
                                    print("Slot \(index2) is Available on \(index1)")
                                }
                                else
                                {
                                    print("\(index2) isnt available on \(index1)")
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                }
            }
        }
        //-----------------------------------------------------------
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
