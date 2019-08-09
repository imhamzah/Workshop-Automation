//
//  ServiceViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 03/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
class ServiceViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {
    @IBOutlet weak var segOut: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var Service1 = ["Brakepad Disc Replacement","Brake Cylinder","Brake Caliper Overhaul","Brake Fluid","Brake Adjustment","Brake Pipe Replacement","Computer Fault Scaning","Car Starter Motor","Oil Change","Filter Change","Leaky Fuel Injector","Shock Absorber","Wheel Alignment","Belt & Hose Replacement","Fuel Injection Service","Exhaust Check","Throttle Check"]
    var Service2 = ["Car Electric Window","Charging System Testing","Car Small Wiring","Car Head Light","Car Ignition","Car Battery Testing","Alternators/Starters","Computerized sensors","Engine light","Window regulators","Wiring issues","Fuses","Air bag systems","Air Conditioning","Immobilisers & Alarms","Windshield Wiper Blades","Trip metre Inspection","Parking Lights & Sensors"]
    var Service3 = ["1","2"]
    var ser0 = [String]()
    var ser1 = [String]()
    var ser2 = [String]()
    var DatetoBe = ""
    var SlottoBe = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value = 0
        switch segOut.selectedSegmentIndex{
        case 0:
            value = Service1.count
            break
        case 1:
            value = Service2.count
            break
        case 2:
            value = Service3.count
            break
        default:
            break
        }
        return value
    }
    @IBAction func btnSegClick(_ sender: Any) {
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! TableViewCell
        
        switch segOut.selectedSegmentIndex{
        case 0:
            cell.titleLbl.text = Service1[indexPath.row]
            break
        case 1:
            cell.titleLbl.text = Service2[indexPath.row]
            break
        case 2:
            cell.titleLbl.text = Service3[indexPath.row]
            break
        default:
            break
        }
        cell.switchBtn.isOn = false
        cell.switchBtn.tag = indexPath.row // for detect which row switch Changed
        cell.switchBtn.addTarget(self, action: #selector(switchStatus(_:)), for: .valueChanged)
        return cell
    }
    @objc func switchStatus(_ sender:switches)
    {
        if segOut.selectedSegmentIndex == 0
        {
            if !ser0.contains(Service1[sender.tag]){
                ser0.append(Service1[sender.tag])
            }
            else if ser0.contains(Service1[sender.tag]){
                if !sender.isOn {
                    if let index = ser0.index(of: Service1[sender.tag]) {
                        ser0.remove(at: index)
                    }
                }
            }
        }
    }
    @IBAction func test(_ sender: Any) {
        
        if segOut.selectedSegmentIndex == 0
        {
            for index in ser0{
                print(index)
                print("----")
            }
        }
    }
}
class switches:UISwitch
{
    var indexpath:IndexPath?
}
