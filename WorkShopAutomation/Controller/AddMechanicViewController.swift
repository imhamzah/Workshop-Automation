//
//  AddMechanicViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 09/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class AddMechanicViewController: UIViewController {
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var lblPhone: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    @IBOutlet weak var lblPwd: UITextField!
    @IBOutlet weak var lblConfirmPwd: UITextField!
    
    override func viewDidLoad() {
        let NameImg = UIImage(named: "person")
        imageToTextFields(txtField: lblName, andImage: NameImg!)
        
        let phoneImg = UIImage(named: "phone")
        imageToTextFields(txtField: lblPhone, andImage: phoneImg!)
        
        let AddressImg = UIImage(named: "address")
        imageToTextFields(txtField: lblAddress, andImage: AddressImg!)
        
        let passwordImg = UIImage(named: "password")
        imageToTextFields(txtField: lblPwd, andImage: passwordImg!)
        
        imageToTextFields(txtField: lblConfirmPwd, andImage: passwordImg!)
        
        super.viewDidLoad()

    }
    @IBAction func postData(_ sender: Any) {
        userStatus()
        signUpUser()
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
                "status":"\("Mechanic")",
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
            let urlString = "\(AppDelegate.WcfUrl)signUpMechanic"
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
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
    }
}
