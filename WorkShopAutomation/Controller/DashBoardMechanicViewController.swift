//
//  mechinic_VC.swift
//  WorkShopAutomation
//
//  Created by Apple on 29/03/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class DashBoardMechanicViewController: UIViewController {
    @IBOutlet weak var MecName: UILabel!

    //Recieving Data
    var phoneNumber = ""
    var MechanicName = ""
    //-------------
    var MechName = ""
    var phoneNo = ""
    var todayDate = ""
    var Mec_Id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        MechName = UserDefaults.standard.string(forKey: "MecName")!
        phoneNo = UserDefaults.standard.string(forKey: "MecphoneNo")!
        getMechanicId()
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        todayDate = dateFormatter.string(from: today as Date).capitalized
        print(todayDate)
        MecName.text = MechName
        print(phoneNumber)
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    @IBAction func btnArrivingCar(_ sender: Any) {
        //getCarsforMechanic()
        performSegue(withIdentifier: "segArrivingCar", sender: self)
    }
    
    @IBAction func btnCarInShop(_ sender: Any) {
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "MecLoggedIn")
        self.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segArrivingCar"{
            let destinationVC = segue.destination as! ArrivingCarViewController
            destinationVC.todayDate = todayDate
            destinationVC.MecID = Mec_Id
            destinationVC.phoneNumber = phoneNo
        }
    }
    func getMechanicId()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getLoggedInMechanicID"
            let param =
                [
                    "phoneNumber":"\(phoneNo)"
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
                            let outPut = dlc.value(forKey: "getLoggedInMechanicIDResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as! NSDictionary
                                self.Mec_Id = tempitem.value(forKey: "Mec_ID") as! String
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
}
