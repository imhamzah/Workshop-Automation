//
//  ViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 25/03/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--------------------------Designing Sign up Button -------------------------//
        btnSignUp.layer.cornerRadius = 10
        btnSignUp.clipsToBounds = true
        btnSignIn.layer.cornerRadius = 10
        btnSignIn.clipsToBounds = true
    }
        //---------------Recieving value of Segmented control from prevoius storyboard ---------------//
    @IBAction func segmentControl(_ sender: Any) {
        if segControl.selectedSegmentIndex == 0
        {
            status = "Customer"
            print(status)
        }
        
        else if segControl.selectedSegmentIndex == 1
        {
            status = "Mechanic"
            print(status)
        }
    }
    //---------------------------------------Sign Up button------------------------------------------//
    @IBAction func btnSignUp(_ sender: Any) {
        
        let sec:SignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "sec") as! SignUpViewController
        sec.status = status
        self.navigationController?.pushViewController(sec, animated: true)
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        
    }
}

