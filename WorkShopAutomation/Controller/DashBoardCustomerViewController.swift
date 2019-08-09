//
//  DashBoardCustomerViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 28/03/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications

class DashBoardCustomerViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet weak var btnAddVehicle: UIButton!
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnCheckin: UIButton!
    @IBOutlet weak var btnInvoice: UIButton!
    @IBOutlet weak var btnChkAppointment: UIButton!
    @IBOutlet weak var lblCustomerName: UILabel!
    
    var RegNo = ""
    var DateToday = ""
    
    var customerName = ""
    var phoneNumber = ""
    
    var name = ""
    var phoneNo = ""
    
    var todayDate = ""
    
    var status = ""
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        name = UserDefaults.standard.string(forKey: "Name")!
        phoneNo = UserDefaults.standard.string(forKey: "phoneNo")!
       
        checkStatus()
        
        print(phoneNumber)
        lblCustomerName.text = name
        print(name)
        print(phoneNo)
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        todayDate = dateFormatter.string(from: today as Date).capitalized
        print(todayDate)
    }

    @IBAction func btnAddCar(_ sender: Any) {
        performSegue(withIdentifier: "segAddCar", sender: self)
    }
    @IBAction func btnAppointmentProfile(_ sender: Any) {
        performSegue(withIdentifier: "segAppointmentProfile", sender: self)
    }
    @IBAction func btnUserProfile(_ sender: Any) {
        performSegue(withIdentifier: "segUserProfile", sender: self)
    }
    @IBAction func btnAppointmentSchedule(_ sender: Any) {
        performSegue(withIdentifier: "segAppointmentSchedule", sender: self)
    }
    @IBAction func btnCheckIn(_ sender: Any) {
        performSegue(withIdentifier: "segCheckin", sender: self)
    }
    @IBAction func btnBill(_ sender: Any) {
        performSegue(withIdentifier: "segBill", sender: self)
    }
    @IBAction func btnLogOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "UserLoggedIn")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnComplaints(_ sender: Any) {
        performSegue(withIdentifier: "segComplaints", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segAddCar"{
           let destinationVC = segue.destination as! AddCarViewController
            destinationVC.phoneNumber = phoneNo
        }
        if segue.identifier == "segAppointmentProfile"{
            let destinationVC = segue.destination as! ProfileViewController
            destinationVC.phoneNumber = phoneNo
        }
        if segue.identifier == "segUserProfile"{
            let destinationVC = segue.destination as! UserProfileViewController
            destinationVC.phoneNumber = phoneNo
        }
        if segue.identifier == "segAppointmentSchedule"{
            let destinationVC = segue.destination as! AppointmentScheduleViewController
            destinationVC.phoneNumber = phoneNo
        }
        if segue.identifier == "segCheckin"{
            let destinationVC = segue.destination as! CustomerArrivedCheckInViewController
            destinationVC.phoneNo = phoneNo
        }
        if segue.identifier == "segBill"{
            let destinationVC = segue.destination as! BillViewController
            destinationVC.phoneNumber = phoneNo
            destinationVC.todayDate = todayDate
            destinationVC.status = status
            
        }
        if segue.identifier == "segComplaints"{
            let destinationVC = segue.destination as! ComplaintsViewController
            destinationVC.phoneNumber = phoneNo
        }

    }
    
    func checkStatus(){
        print(RegNo)
        print(DateToday)
        
        RegNo = UserDefaults.standard.string(forKey: "RegNo")!
        DateToday = UserDefaults.standard.string(forKey: "DateToday")!
        
        let urlString = "\(AppDelegate.WcfUrl)CheckBillStatus"
        let param =
            [
                "Reg_No":"\(RegNo)",
                "Date":"\(DateToday)"
        ]
        let header = ["Content-Type":"application/json"]
        
        Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON
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
                        let outPut = dlc.value(forKey: "CheckBillStatusResult") as! NSArray
                        
                        for item in outPut
                        {
                            let tempitem = item as! NSDictionary
                            print(tempitem)
                            self.status = tempitem.value(forKey: "Status") as! String
                        }
                        
                        if(self.status == "Active")
                        {
                            self.createNotif()
                        }
                        else if(self.status == "Inactive")
                        {
                            self.createNotif1()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    
    func createNotif(){
        let content = UNMutableNotificationContent()
        content.title = "Attention!"
        //content.subtitle = "Sub-Title"
        content.body = "Your car \(RegNo) has been ready! Please pay the bill and enjoy ride."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {
            (error) in
            print(error as Any)
        }
    }
    
    
    func createNotif1(){
        let content = UNMutableNotificationContent()
        content.title = "Attention!"
        //content.subtitle = "Sub-Title"
        content.body = "Your car isn't ready yet! Please wait."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {
            (error) in
            print(error as Any)
        }
    }
    
    
}
