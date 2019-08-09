//
//  ArrivingCarViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 21/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ArrivingCarViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var selectedCar = ""
    //Recieving Data
    var todayDate = ""
    var phoneNumber = ""
    var MecID = ""
    //--------------
    var CarRegNum = [String]()
    var CarModel = [String]()
    var CarColor = [String]()
    var CarTime = [String]()
    
    @IBOutlet weak var carTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CarRegNum.count
    }
    override func viewDidAppear(_ animated: Bool) {
        carTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ArrivingCarTableViewCell
        cell.lblRegNo.text = CarRegNum[indexPath.row]
        cell.lblModel.text = CarModel[indexPath.row]
        cell.lblColor.text = CarColor[indexPath.row]
        cell.lblTime.text = CarTime[indexPath.row]
        
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(btnSelectClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnSelectClicked(_ sender:UIButton)
    {
        selectedCar = CarRegNum[sender.tag]
        performSegue(withIdentifier: "segPickCar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segPickCar"{
            let destinationVC = segue.destination as! CarInShopViewController
            destinationVC.regNum = selectedCar
            destinationVC.phoneNumber = phoneNumber
            destinationVC.todayDate = todayDate
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(phoneNumber)
        print(MecID)
        print(todayDate)
        DispatchQueue.main.async {
            self.getCarsforMechanic()
        }
        
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        todayDate = dateFormatter.string(from: today as Date).capitalized
        carTableView.reloadData()
    }
    
    
    //------------------------------------------------------------------------------------------
    
    func getCarsforMechanic()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getCarForLoggedInMechanic"
            let param =
                [
                    "Mec_Id":"\(MecID)",
                    "Date":"\(todayDate)"
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
                            let outPut = dlc.value(forKey: "getCarForLoggedInMechanicResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as Any
                                self.CarRegNum.append((tempitem as AnyObject).value(forKey: "regNo") as! String)
                                self.CarModel.append((tempitem as AnyObject).value(forKey: "Model") as! String)
                                self.CarColor.append((tempitem as AnyObject).value(forKey: "Color") as! String)
                                self.CarTime.append((tempitem as AnyObject).value(forKey: "Slot") as! String)
                            }
                            self.carTableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
}

