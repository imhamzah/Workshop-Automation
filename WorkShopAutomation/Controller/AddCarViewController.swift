//
//  AddCarViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 29/03/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class AddCarViewController: UIViewController {
    @IBOutlet weak var txtCarNo: UITextField!
    @IBOutlet weak var txtCarMaker: UITextField!
    @IBOutlet weak var txtCarCC: UITextField!
    @IBOutlet weak var txtCarYear: UITextField!
    @IBOutlet weak var txtCarColor: UITextField!
    
    var phoneNumber = ""         //logged in user phoneNumber recieved
    override func viewDidLoad() {
        super.viewDidLoad()
        print(phoneNumber)
        print("+_+_+_+_")
        
        let CarImg = UIImage(named: "Car1")
        imageToTextFields(txtField: txtCarNo, andImage: CarImg!)
        
        imageToTextFields(txtField: txtCarMaker, andImage: CarImg!)
        
        imageToTextFields(txtField: txtCarCC, andImage: CarImg!)
        
        imageToTextFields(txtField: txtCarYear, andImage: CarImg!)
        
        imageToTextFields(txtField: txtCarColor, andImage: CarImg!)
    }
    @IBAction func btnAddCar(_ sender: UIButton) {
        postCar()
    }
    
    func imageToTextFields(txtField: UITextField, andImage img: UIImage){
        let leftImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftImgView.image = img
        txtField.leftView = leftImgView
        txtField.leftViewMode = .always
    }
    
    func postCar()
    {
            let urlString = "\(AppDelegate.WcfUrl)addCar"
            let param =
                [
                    "CarRegNo":"\(txtCarNo.text!)",
                    "CarMaker":"\(txtCarMaker.text!)",
                    "CarCC":"\(txtCarCC.text!)",
                    "CarYear":"\(txtCarYear.text!)",
                    "CarColor":"\(txtCarColor.text!)",
                    "Owner_Id":"\(phoneNumber)"
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
