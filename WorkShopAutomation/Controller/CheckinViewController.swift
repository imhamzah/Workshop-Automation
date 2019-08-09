//
//  CheckinViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 19/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class CheckinViewController: UIViewController {

    @IBOutlet weak var txtKilometers: UITextField!
    var RegNo = ""          //Recieving Data
    var phoneNumber = ""    //Recieving Data
    var CC = ""    //Recieving Data
    //-----------------------
    var dates = [String]()
    
    
    
    var selectedDate = ""
    
    var APIDates = [String]()
    var pickerViewSlots :[String] = ["Slot1","Slot2","Slot3","Slot4"]
    var APIDisabledDates :[String] = []
    
    
    
    var kilometers = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let CheckinImg = UIImage(named: "Tool2")
        imageToTextFields(txtField: txtKilometers, andImage: CheckinImg!)
        print(phoneNumber)
        print(RegNo)
    }
    @IBAction func btnAddKilometers(_ sender: Any) {
        kilometers = txtKilometers.text!
        performSegue(withIdentifier: "segCalender", sender: self)
    }
    
    @IBAction func btnGet(_ sender: Any) {
        Check()
    }
    
    func Check(){
        
        let todayx = NSDate()
        for i in 0...5 {
            let inFuture = Calendar.current.date(byAdding: .day, value: i, to: todayx as Date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dates.append(dateFormatter.string(from: inFuture!).capitalized)
        }
        
        for index1 in dates {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segCalender"{
            let destinationVC = segue.destination as! CustomAppointmentViewController
            destinationVC.RegNo = RegNo
            destinationVC.phoneNumber = phoneNumber
            destinationVC.kilometers = kilometers
            destinationVC.recievingDates = dates
            destinationVC.CC = CC
            destinationVC.APIDates = APIDates
            destinationVC.APIDisabledDates = APIDisabledDates
        }
    }
    
    func imageToTextFields(txtField: UITextField, andImage img: UIImage){
        let leftImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftImgView.image = img
        txtField.leftView = leftImgView
        txtField.leftViewMode = .always
    }
}
