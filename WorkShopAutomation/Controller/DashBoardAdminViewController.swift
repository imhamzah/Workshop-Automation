//
//  DashBoardAdminViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 09/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class DashBoardAdminViewController: UIViewController {

    var RegNo = [String]()
    var Model = [String]()
    var Color = [String]()
    var todayDate = ""
    var adminName = ""
    var phoneNo = ""
    
    @IBOutlet weak var lblAdminName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adminName = UserDefaults.standard.string(forKey: "AdminName")!
        phoneNo = UserDefaults.standard.string(forKey: "AdminphoneNo")!
        print("+_)()()_+")
        print(phoneNo)
        print(todayDate)
        lblAdminName.text = adminName
        
        getModel()
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    @IBAction func btnReviewCars(_ sender: Any) {
        performSegue(withIdentifier: "segReviewCars", sender: self)
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "AdminLoggedIn")
        self.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segReviewCars"{
            let destinationVC = segue.destination as! ReviewCarsViewController
            destinationVC.RegNum = RegNo
            destinationVC.Model = Model
            destinationVC.Color = Color
        }
    }

    func getModel()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getCarDetails"
            let param =
                [
                    "Date":"\(todayDate)"
                    //today date is being forwarded from signinviewcontroller as param
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
                            let outPut = dlc.value(forKey: "getCarDetailsResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as Any
                                self.RegNo.append((tempitem as AnyObject).value(forKey: "regNo") as! String)
                                self.Model.append((tempitem as AnyObject).value(forKey: "Model") as! String)
                                self.Color.append((tempitem as AnyObject).value(forKey: "Color") as! String)
                                
                                //self.Model = [(tempitem as AnyObject).value(forKey: "Model") as! String]
                            }
                            print(self.RegNo)
                            print("------")
                            print(self.Model)
                            print("------")
                            print(self.Color)
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }

}
