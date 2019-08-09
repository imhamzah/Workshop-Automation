//
//  SignUpViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 25/03/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var lblPhone: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    @IBOutlet weak var lblPwd: UITextField!
    @IBOutlet weak var lblConfirmPwd: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var segControl: UISegmentedControl!
    var status:String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let NameImg = UIImage(named: "person")
        imageToTextFields(txtField: lblName, andImage: NameImg!)
        
        let phoneImg = UIImage(named: "phone")
        imageToTextFields(txtField: lblPhone, andImage: phoneImg!)
        
        let AddressImg = UIImage(named: "address")
        imageToTextFields(txtField: lblAddress, andImage: AddressImg!)
        
        let passwordImg = UIImage(named: "password")
        imageToTextFields(txtField: lblPwd, andImage: passwordImg!)
        
        imageToTextFields(txtField: lblConfirmPwd, andImage: passwordImg!)
        
        }
    //-----------------Taking value of segmented Control and updating status ------------------//
    @IBAction func segmentedControl(_ sender: Any)  {
        if segControl.selectedSegmentIndex == 0
        {
            status = "Customer"
            print(status!)
        }
        else if segControl.selectedSegmentIndex == 1
        {
            status = "Admin"
            print(status!)
        }
    }
    //------------------------------Sign up Button Action ----------------------------//
    @IBAction func btnSignUp(_ sender: UIButton) {
        //------------------------------Function for validation ----------------------------//
        if validation()
        {
            signUpUser()
            userStatus()
        }
        else
        {
            print("Validation Error")
        }
    }
    
    func imageToTextFields(txtField: UITextField, andImage img: UIImage){
        let leftImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftImgView.image = img
        txtField.leftView = leftImgView
        txtField.leftViewMode = .always
    }
    
    func userStatus()
    {
        let phone = lblPhone.text!
        let password = lblPwd.text!
        let name = lblName.text!
        
        let urlString = "\(AppDelegate.WcfUrl)userStatus"
        let param =
            [
                "phone":"\(phone)",
                "password":"\(password)",
                "status":"\(status!)",
                "name":"\(name)"
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
                        print(dlc)
                        print("Data Saved Successfully")
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    func signUpUser()
    {
        let name = lblName.text!
        let phone = lblPhone.text!
        let email = lblAddress.text!
        let password = lblPwd.text!
        //let cPassword = lblConfirmPwd.text!
        //if status == Admin -- > data should be saved in Admin Entity in DB.
        if status! == "Admin"
        {
            let urlString = "\(AppDelegate.WcfUrl)signUpAdmin"
            let param =
                [
                    "name":"\(name)",
                    "phone":"\(phone)",
                    "email":"\(email)",
                    "password":"\(password)"
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
                            print(dlc)
                            print("Data Saved Successfully")
                            let ac = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardAdminViewController") as! DashBoardAdminViewController
                            self.navigationController?.pushViewController(ac, animated: true)
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
        //if status == Customer -- > data should be saved in Customer Entity in DB.
        if status! == "Customer"
        {
            let urlString = "\(AppDelegate.WcfUrl)signUpCustomer"
            let param =
                [
                    "name":"\(name)",
                    "phone":"\(phone)",
                    "email":"\(email)",
                    "password":"\(password)"
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
                            print(dlc)
                            print("Data Saved Successfully")
                            
                            let ac = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardCustomerViewController") as! DashBoardCustomerViewController
                            self.navigationController?.pushViewController(ac, animated: true)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
    func showAlert(title:String,message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let btn = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(btn)
        present (alert, animated: true, completion: nil)
    }
    
    func validation() -> Bool
    {
        //if Phone No doesn't matches criteria(ten digits),then show alert to user
        if   !(lblPhone.text?.isPhoneNumberValid)!
        {
            showAlert(title: "Signup", message: "Please enter valid phone number! Length(10) ")
            return false
        }
        //if Email doesn't matches criteria(a@bc.com),then show alert to user
        else if !(lblAddress.text?.isEmailValid)!
        {
            showAlert(title: "Signup", message: "Please enter valid Email!")
            return false
        }
        //if password doesn't matches criteria(1 special character and minimum 8 letters),then show alert to user
        else if !(lblPwd.text?.isPwdValid)!
        {
            showAlert(title: "Signup", message: "Password Length should be greater then 8 incl. special char & Alphabets!")
            return false
        }
        //if password doesn't equals(checking using extension),then show alert to user
        else if !(lblPwd.text == lblConfirmPwd.text)
        {
            showAlert(title: "Signup", message: "Password doesn't match! ")
            return false
        }
        else
        {
          return  true
        }
    }
}

//Extension used for validating Phone Number,Email and Password of Signup form.
extension String{
    //validating Phone Number
    var isPhoneNumberValid: Bool{
        do{
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            
           if let res = matches.first
           {
            //SQL DB accepting only upto 10 digits number for Int type--Check it
            return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
           } else
           {
                return false
           }
         }
        catch {
            return false
        }
}
    //validating Password
    var isPwdValid : Bool{
        let pwdTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return pwdTest.evaluate(with: self)
    }
    //validating Email
    var isEmailValid : Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
}


