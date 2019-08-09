//
//  CustomAppointmentViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 01/07/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import FSCalendar

class CustomAppointmentViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,UIPickerViewDataSource,UIPickerViewDelegate {

    var RegNo = ""     //recieving RegNo from CheckinViewController
    var phoneNumber = ""    //recieving phoneNo from CheckinViewController
    var kilometers = ""    //recieving kilometers from CheckinViewController
    var CC = ""     //recieving CC from CheckinViewController
    var recievingDates = [String]() //recieving Date from CheckinViewController
    
    @IBOutlet weak var FSCal: FSCalendar!
    
    var selectedDate = ""
    
    var APIDates = [String]()
    //var APIDisabledDates = [String]()
    var pickerViewSlots :[String] = ["Slot1","Slot2","Slot3","Slot4"]
    var pickerViewPickedValue = ""
    var APIDisabledDates :[String] = []
    var datesss :[String] = ["03-07-2019","10-07-2019","17-07-2019","25-07-2019"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FSCal.delegate = self
        //----------------
        print(RegNo)
        print(phoneNumber)
        print(kilometers)
        print(CC)
        print(recievingDates)
        print("+_+_+_+_+_")
        print(APIDates)
        print("+_+_+_+_+_")
        print(APIDisabledDates)
        print("+_+_+_+_+_")
        //---------------
        
        DispatchQueue.main.async {
            //self.CheckIndexes()
        }
    }
    
    @IBAction func btnAddAppointmentDetails(_ sender: Any) {
        updateSlotsintDB()
        performSegue(withIdentifier: "segAppointmentDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segAppointmentDetails"{
            let destinationVC = segue.destination as! ServicesViewController
            destinationVC.DatetoBe = selectedDate
            destinationVC.SlottoBe = pickerViewPickedValue
            destinationVC.phoneNumber = phoneNumber
            destinationVC.RegNumber = RegNo
            destinationVC.kilometers = kilometers
            destinationVC.AppointmentDay = ""
            destinationVC.CC = CC
        }
    }
    
    func updateSlotsintDB()
    {
        let urlString = "\(AppDelegate.WcfUrl)UpdateSlots"
        let param =
            [
                "date":"\(selectedDate)",
                "slot":"\(pickerViewPickedValue)"
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
    
    //-------------------------------------------Pickerview---------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewSlots.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewSlots[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewPickedValue = pickerViewSlots[row]
        print(pickerViewPickedValue)
    }
    
    //-------------------------------------------Pickerview---------------------------------------
    
    
    //-------------------------------------------FSCalender---------------------------------------
    //disabling
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool
    {
        var signal = false
        var result = Date()
        for index in APIDisabledDates{
            let datex = index
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            result = formatter.date(from: datex)!
        }
            if(date == result){
                signal = false
            }
            else{
                signal = true
            }
        return signal
    }
    
    //selected date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        print(dateFormatter.string(from: date).capitalized)
        selectedDate = dateFormatter.string(from: date).capitalized
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let  dates = dateFormatter.string(from: date).capitalized
        let da =  returnDateEvent(date:dates)
        return da
    }
    
    func returnDateEvent(date:String) -> Int
    {
        let a = APIDisabledDates.contains { (String) -> Bool in
            if String == date
            {
                return true
            }
            else
            {
                return false
            }
        }
        
        if a == true
        {
            return 1
        }
        else
        {
            return 0
        }
    }
    
    //-------------------------------------------FSCalender---------------------------------------
    
    
    
    func CheckIndexes (){
        var datex = [String]()
        
        let today = NSDate()
        for i in 0...5 {
            let inFuture = Calendar.current.date(byAdding: .day, value: i, to: today as Date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            datex.append(dateFormatter.string(from: inFuture!).capitalized)
        }
        
        for index1 in datex {
            for index2 in pickerViewSlots {
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
                                    print("\(index2) is Available on \(index1)")
                                    self.APIDates.append(index1)
                                    //self.FSCal.reloadData()
                                }
                                else
                                {
                                    print("\(index2) isnt Available on \(index1)")
                                    self.APIDisabledDates.append(index1)
                                    //self.FSCal.reloadData()
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                }
            }
        }
    }
}
