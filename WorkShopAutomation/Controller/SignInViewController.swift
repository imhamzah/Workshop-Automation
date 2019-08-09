//
//  SignInViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 27/03/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblPhone: UITextField!
    @IBOutlet weak var lblPwd: UITextField!
    var phoneNo = ""
    var userStatus = ""
    var password = ""
    var name = ""
    var status = ""
    
    var todayDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        todayDate = dateFormatter.string(from: today as Date).capitalized
        print(todayDate)
        
        let phoneImg = UIImage(named: "phone")
        imageToTextFields(txtField: lblPhone, andImage: phoneImg!)
        
        let passwordImg = UIImage(named: "password")
        imageToTextFields(txtField: lblPwd, andImage: passwordImg!)
        
        if UserDefaults.standard.bool(forKey: "UserLoggedIn") == true{
            let ac = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardCustomerViewController") as! DashBoardCustomerViewController
            ac.customerName = self.name
            ac.phoneNumber = self.phoneNo
            self.navigationController?.pushViewController(ac, animated: false)
        }
        
        if UserDefaults.standard.bool(forKey: "AdminLoggedIn") == true{
            let ac = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardAdminViewController") as! DashBoardAdminViewController
            ac.adminName = self.name
            ac.phoneNo = self.phoneNo
            self.navigationController?.pushViewController(ac, animated: false)
        }
        
        if UserDefaults.standard.bool(forKey: "MecLoggedIn") == true{
            let ac = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardMechanicViewController") as! DashBoardMechanicViewController
            //ac.adminName = self.name
            //ac.phoneNo = self.phoneNo
            self.navigationController?.pushViewController(ac, animated: false)
        }
        }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        loginUser()
    }
    func imageToTextFields(txtField: UITextField, andImage img: UIImage){
        let leftImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImgView.image = img
        txtField.leftView = leftImgView
        txtField.leftViewMode = .always
    }
    
    func loginUser()
    {
        let urlString = "\(AppDelegate.WcfUrl)loggingInUser"
        let param =
            [
                "phone":"\(lblPhone.text!)",
                "password":"\(lblPwd.text!)"
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
                        let outPut = dlc.value(forKey: "loggingInUserResult") as! NSArray
                        for item in outPut
                        {
                            let tempitem = item as! NSDictionary
                            print(tempitem)
                            self.phoneNo = tempitem.value(forKey: "phoneNumber") as! String
                            self.password = tempitem.value(forKey: "password") as! String
                            self.userStatus = tempitem.value(forKey: "status") as! String
                            self.name = tempitem.value(forKey: "name") as! String
                        }
                        if((self.phoneNo == "") && (self.password == ""))
                        {
                            let alert = UIAlertController(title: "Sign in", message: "No Record Found", preferredStyle: .alert)
                            let btn = UIAlertAction(title: "Ok", style: .default)
                            alert.addAction(btn)
                            self.present (alert, animated: true, completion: nil)
                        }
                        else
                        {
                            DispatchQueue.main.async
                                {
                                    print("\(self.phoneNo) and \(self.password) exists")
                                    //----------------------Checking status and navigating to relevant storyboard------------------------//
                                    if self.userStatus == "Customer"
                                    {
                                        UserDefaults.standard.set(true, forKey: "UserLoggedIn")
                                        UserDefaults.standard.setValue(self.name, forKey: "Name")
                                        UserDefaults.standard.setValue(self.phoneNo, forKey: "phoneNo")
                                        let ac = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardCustomerViewController") as! DashBoardCustomerViewController
                                        ac.customerName = self.name
                                        ac.phoneNumber = self.phoneNo
                                        self.navigationController?.pushViewController(ac, animated: true)
                                    }
                                    else if self.userStatus == "Admin"
                                    {
                                        UserDefaults.standard.set(true, forKey: "AdminLoggedIn")
                                        UserDefaults.standard.setValue(self.name, forKey: "AdminName")
                                        UserDefaults.standard.setValue(self.phoneNo, forKey: "AdminphoneNo")
                                        let ac = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardAdminViewController") as! DashBoardAdminViewController
                                        ac.adminName = self.name
                                        ac.phoneNo = self.phoneNo
                                        ac.todayDate = self.todayDate
                                        self.navigationController?.pushViewController(ac, animated: true)
                                    }
                                    else if self.userStatus == "Mechanic"
                                    {
                                        UserDefaults.standard.set(true, forKey: "MecLoggedIn")
                                        UserDefaults.standard.setValue(self.name, forKey: "MecName")
                                        UserDefaults.standard.setValue(self.phoneNo, forKey: "MecphoneNo")
                                        let ac = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardMechanicViewController") as! DashBoardMechanicViewController
                                        ac.MechanicName = self.name
                                        ac.phoneNumber = self.phoneNo
                                        self.navigationController?.pushViewController(ac, animated: true)
                                    }
                                }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
        //lblPhone.text = ""
        //lblPwd.text = ""
    }
}
