//
//  ServicesViewController.swift
//  WorkShopAutomation
//
//  Created by Apple on 12/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ServicesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var segOut: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var carRegNo: UILabel!
    @IBOutlet weak var carColor: UILabel!
    @IBOutlet weak var carMaker: UILabel!
    @IBOutlet weak var carCC: UILabel!
    var Color = ""
    var Maker = ""
    var CC = ""
    
    var Mechanic = ""
    
    //Recieving Data
    var DatetoBe = ""
    var SlottoBe = ""
    var phoneNumber = ""
    var RegNumber = ""
    var kilometers = ""
    var AppointmentDay = ""
    
    //Mechanical Variables of Core Data
    var OilChange = false
    var filterchange = false
    var brake = false
    var breakpad = false
    var Injector = false
    var throttle = false
    
    //Electrical Variables of Core Data
    var fogLight = false
    var indicator = false
    var motor = false
    var window = false
    var carIgnition = false
    var airBags = false
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value = 0
        switch segOut.selectedSegmentIndex{
        case 0:
            value = Mechanical.count
            break
        case 1:
            value = Electrical.count
            break
        case 2:
            value = Suggested.count
            break
        default:
            break
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! ServicesTableViewCell
        
        switch segOut.selectedSegmentIndex
        {
            case 0:
            cell.lblServices.text = Mechanical[indexPath.row]
            cell.btnSwitch.isOn = false
            cell.btnSwitch.tag = indexPath.row // for detect which row switch Changed
            cell.btnSwitch.addTarget(self, action: #selector(switchStatus(_:)), for: .valueChanged)
            
            if cell.btnSwitch!.tag == 0
            {
                print(cell.btnSwitch!.tag)
                cell.btnSwitch.isOn = self.OilChange
            }
            else if cell.btnSwitch!.tag == 1
            {
                cell.btnSwitch.isOn = self.filterchange
            }
            else if cell.btnSwitch!.tag == 2
            {
                cell.btnSwitch.isOn = self.breakpad
            }
            else if cell.btnSwitch!.tag == 3
            {
                cell.btnSwitch.isOn = self.brake
            }
            else if cell.btnSwitch!.tag == 4
            {
                cell.btnSwitch.isOn = self.throttle
            }
            else if cell.btnSwitch!.tag == 5
            {
                cell.btnSwitch.isOn = self.Injector
            }
            DispatchQueue.main.async
            {
                self.validate_today()
            }
            
            break
        case 1:
            cell.lblServices.text = Electrical[indexPath.row]
            cell.btnSwitch.isOn = false
            cell.btnSwitch.tag = indexPath.row // for detect which row switch Changed
            cell.btnSwitch.addTarget(self, action: #selector(switchStatus(_:)), for: .valueChanged)
            if cell.btnSwitch!.tag == 0
            {
                print(cell.btnSwitch!.tag)
                cell.btnSwitch.isOn = self.fogLight
            }
            else if cell.btnSwitch!.tag == 1
            {
                cell.btnSwitch.isOn = self.indicator
            }
            else if cell.btnSwitch!.tag == 2
            {
                cell.btnSwitch.isOn = self.motor
            }
            else if cell.btnSwitch!.tag == 3
            {
                cell.btnSwitch.isOn = self.window
            }
            else if cell.btnSwitch!.tag == 4
            {
                cell.btnSwitch.isOn = self.carIgnition
            }
            else if cell.btnSwitch!.tag == 5
            {
                cell.btnSwitch.isOn = self.airBags
            }
            DispatchQueue.main.async
            {
                self.validate_today()
            }
            break
        case 2:
            cell.lblServices.text = Suggested[indexPath.row]
            //cell.btnSwitch.isOn = true
            break
        default:
            break
        }
        return cell
    }
    
    @objc func switchStatus(_ sender:switches)
    {
        if segOut.selectedSegmentIndex == 0
        {
            if !AddMechanical.contains(Mechanical[sender.tag])
            {
                AddMechanical.append(Mechanical[sender.tag])
                if Mechanical[sender.tag] == "Oil Change"
                {
                    if sender.isOn == true
                    {
                        Data(Switches: "oilChange", States: true)
                    }
                    else
                    {
                        Data(Switches: "oilChange", States: false)
                    }
                   
                }
                else if Mechanical[sender.tag] == "Filter Change"
                {
                    
                    if sender.isOn == true
                    {
                        Data(Switches: "filterchange", States: true)
                    }
                    else
                    {
                        Data(Switches: "filterchange", States: false)
                    }
                }
                else if Mechanical[sender.tag] == "Brakepad Disc Replacement"
                {
                    if sender.isOn == true
                    {
                        Data(Switches: "breakpad", States: true)
                    }
                    else
                    {
                        Data(Switches: "breakpad", States: false)
                    }
                }
                else if Mechanical[sender.tag] == "Brake Fluid"
                {
    
                    if sender.isOn == true
                    {
                        Data(Switches: "brake", States: true)
                    }
                    else
                    {
                        Data(Switches: "brake", States: false)
                    }
                }
                else if Mechanical[sender.tag] == "Throttle Check"
                {
                    if sender.isOn == true
                    {
                        Data(Switches: "throttle", States: true)
                    }
                    else
                    {
                        Data(Switches: "throttle", States: false)
                    }
                }
                else if Mechanical[sender.tag] == "Leaky Fuel Injector"
                {
                    if sender.isOn == true
                    {
                        Data(Switches: "injector", States: true)
                    }
                    else
                    {
                        Data(Switches: "injector", States: false)
                    }
                }
                
            }
            else if AddMechanical.contains(Mechanical[sender.tag]){
                if !sender.isOn {
                    if let index = AddMechanical.index(of: Mechanical[sender.tag]) {
                        AddMechanical.remove(at: index)
                    }
                }
            }
        }
        //---------------------------------------------------------------------------
        if segOut.selectedSegmentIndex == 1
        {
            if !AddElectrical.contains(Electrical[sender.tag])
            {
                AddElectrical.append(Electrical[sender.tag])
               
                if Electrical[sender.tag] == "Foglights"
                {
                    
                    if sender.isOn == true
                    {
                        Data(Switches: "foglights", States: true)
                    }
                    else
                    {
                        Data(Switches: "foglights", States: false)
                    }
                    
                }
                else if Electrical[sender.tag] == "Indicator"
                {
                    
                    if sender.isOn == true
                    {
                        Data(Switches: "indicator", States: true)
                    }
                    else
                    {
                        Data(Switches: "indicator", States: false)
                    }
                }
                else if Electrical[sender.tag] == "Car Starter Motor"
                {
                    if sender.isOn == true
                    {
                        Data(Switches: "motor", States: true)
                    }
                    else
                    {
                        Data(Switches: "motor", States: false)
                    }
                }
                else if Electrical[sender.tag] == "Car Electric Window"
                {
                    
                    if sender.isOn == true
                    {
                        Data(Switches: "window", States: true)
                    }
                    else
                    {
                        Data(Switches: "window", States: false)
                    }
                }
                else if Electrical[sender.tag] == "Car Ignition"
                {
                    if sender.isOn == true
                    {
                        Data(Switches: "carignition", States: true)
                    }
                    else
                    {
                        Data(Switches: "carignition", States: false)
                    }
                }
                else if Electrical[sender.tag] == "Air Bags"
                {
                    if sender.isOn == true
                    {
                        Data(Switches: "airbags", States: true)
                    }
                    else
                    {
                        Data(Switches: "airbags", States: false)
                    }
                }
            }
            else if AddElectrical.contains(Electrical[sender.tag]){
                if !sender.isOn {
                    if let index = AddElectrical.index(of: Electrical[sender.tag]) {
                        AddElectrical.remove(at: index)
                    }
                }
            }
        }
        //---------------------------------------------------------------------------
        if segOut.selectedSegmentIndex == 2
        {
            if !AddSuggested.contains(Suggested[sender.tag]){
                AddSuggested.append(Suggested[sender.tag])
            }
            else if AddSuggested.contains(Suggested[sender.tag]){
                if !sender.isOn {
                    if let index = AddSuggested.index(of: Suggested[sender.tag]) {
                        AddSuggested.remove(at: index)
                    }
                }
            }
        }
    }
    var Electrical = [String]()
    var Mechanical = [String]()
    var Suggested = [String]()
    var Other = [String]()
    //----------------------------
    var AddElectrical = [String]()
    var AddMechanical = [String]()
    var AddSuggested = [String]()
    var AddOther = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        getElectricalServices()
        getMechanicalServices()
        getSuggestedServices()
        getCarDetails()
        carRegNo.text = RegNumber
        carColor.text = self.Color
        carCC.text = self.CC

        print ("RegNo is \(RegNumber).")
        print ("phone is \(phoneNumber).")
        print ("kilometer is \(kilometers).")
        print ("Date is \(DatetoBe).")
        print ("Slot is \(SlottoBe).")
        print ("Day is \(AppointmentDay).")
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        DispatchQueue.main.async
        {
            self.validate_today()
        }
    }

    @IBAction func segmentedControlSelected(_ sender: Any) {
        self.tableView.reloadData()
    }
    @IBAction func btnAddServices(_ sender: Any) {
        saveServicestoDB()
        
        UserDefaults.standard.setValue(self.RegNumber, forKey: "RegNo")
        UserDefaults.standard.setValue(self.DatetoBe, forKey: "DateToday")
    }
    func saveServicestoDB()
    {
        let urlString = "\(AppDelegate.WcfUrl)saveServices"
        for index in AddMechanical{
        let param =
            [
                "S_Name":"\(index)",
                "Reg_No":"\(RegNumber)",
                "Phone_Number":"\(phoneNumber)",
                "Date":"\(DatetoBe)",
                "Slot":"\(SlottoBe)",
                "Day":"\(AppointmentDay)"
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
//------------------------------------------------------------------------------------------
        for index in AddElectrical{
            let param =
                [
                    "S_Name":"\(index)",
                    "Reg_No":"\(RegNumber)",
                    "Phone_Number":"\(phoneNumber)",
                    "Date":"\(DatetoBe)",
                    "Slot":"\(SlottoBe)",
                    "Day":"\(AppointmentDay)"
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
//---------------------------------------------------------------------------------------------
        for index in AddSuggested{
            let param =
                [
                    "S_Name":"\(index)",
                    "Reg_No":"\(RegNumber)",
                    "Phone_Number":"\(phoneNumber)",
                    "Date":"\(DatetoBe)",
                    "Slot":"\(SlottoBe)",
                    "Day":"\(AppointmentDay)"
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
//-----------------------------------------------------------------------------------------------
    func getElectricalServices()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getElectricalService"
            let hearder = ["Content-Type":"application/json"]
            Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: hearder).responseJSON
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
                            let outPut = dlc.value(forKey: "getElectricalServiceResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.Electrical.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
//-----------------------------------------------------------------------------------------------
    func getMechanicalServices()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getMechanicalService"
            let hearder = ["Content-Type":"application/json"]
            Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: hearder).responseJSON
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
                            let outPut = dlc.value(forKey: "getMechanicalServiceResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.Mechanical.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
//-----------------------------------------------------------------------------------------------
    func getSuggestedServices()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getSuggestedService"
            let param =
                [
                    "kilometer":"\(kilometers)",
                    "CC":"\(CC)"
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
                            let outPut = dlc.value(forKey: "getSuggestedServiceResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as AnyObject
                                self.Suggested.append(tempitem as! String)
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
//-----------------------------------------------------------------------------------------------
    func getCarDetails()
    {
        do {
            let urlString = "\(AppDelegate.WcfUrl)getCarColor"
            let param =
                [
                    "Owner_Id":"\(phoneNumber)",
                    "Reg_No":"\(RegNumber)"
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
                            let outPut = dlc.value(forKey: "getCarColorResult") as! NSArray
                            for item in outPut
                            {
                                let tempitem = item as! NSDictionary
                                print(tempitem)
                                self.Color = tempitem.value(forKey: "color") as! String
                                self.Maker = tempitem.value(forKey: "Maker") as! String
                                self.carColor.text = self.Color
                                self.carMaker.text = self.Maker
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
}

extension ServicesViewController
{
    func validate_today()
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MachenicalData> = MachenicalData.fetchRequest()
        let predicate1 = NSPredicate(format: "phnno = %@", "\(phoneNumber)")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1])
        do
        {
            let test = try context.fetch(fetchRequest)
            if test.count == 0
            {
                let State = Save()
                print(State)
            }
            else
            {
                Search()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func Data(Switches:String,States:Bool)
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MachenicalData> = MachenicalData.fetchRequest()
        let predicate1 = NSPredicate(format: "phnno = %@", "\(phoneNumber)")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1])
        do
        {
            let test = try context.fetch(fetchRequest)
            if test.count == 0
            {
                let State = Save()
                print(State)
            }
            else
            {
                updateRecords(switchess: Switches,state:States)
            }
        }
        catch
        {
            print(error)
        }
    }

//For Saving records False on first run
    func Save() -> Bool
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let _Machenical = MachenicalData(context: context)
//Mechanical
        
        _Machenical.phnno = phoneNumber
        _Machenical.oilChange = false
        _Machenical.filterchange = false
        _Machenical.breakpad = false
        _Machenical.brake = false
        _Machenical.throttle = false
        _Machenical.injector = false
//Electrical
        
        _Machenical.foglights = false
        _Machenical.indicator = false
        _Machenical.motor = false
        _Machenical.window = false
        _Machenical.carignition = false
        _Machenical.airbags = false
        appdelegate.saveContext()
        return true
    }
    
    func updateRecords(switchess:String,state:Bool)
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MachenicalData> = MachenicalData.fetchRequest()
        let predicate1 = NSPredicate(format: "phnno = %@", "\(phoneNumber)")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1])
        do
        {
            let test = try context.fetch(fetchRequest)
            if test.count == 1
            {
                let objectUpdate = test[0] as NSManagedObject
                objectUpdate.setValue(state, forKey: "\(switchess)")
                do
                {
                    try context.save()
                    print("Successful")
                }
                catch let error
                {
                    print(error)
                }
            }
            else
            {
                print("Not Found")
            }
        }
        catch
        {
            print(error)
        }
    }

    func Search()
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MachenicalData> = MachenicalData.fetchRequest()
        let predicate1 = NSPredicate(format: "phnno = %@", "\(phoneNumber)")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1])
        do
        {
            let test = try context.fetch(fetchRequest)
            if test.count == 1
            {
                for a in test
                {
                    OilChange =  a.oilChange
                    filterchange =  a.filterchange
                    brake =  a.brake
                    breakpad =  a.breakpad
                    throttle =  a.throttle
                    Injector =  a.injector
                    
                    fogLight = a.foglights
                    indicator = a.indicator
                    motor = a.motor
                    window = a.window
                    carIgnition = a.carignition
                    airBags = a.airbags
                    
                    
                    
                    print(a.oilChange)
                    print(a.filterchange)
                    print(a.brake)
                    print(a.breakpad)
                    print(a.throttle)
                    print(a.injector)
                    
                    print(a.airbags)
                    print(a.foglights)
                    print(a.indicator)
                    print(a.motor)
                    print(a.window)
                    print(a.carignition)
                }
            }
            else
            {
                print("Not Found")
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func Delete()
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MachenicalData> = MachenicalData.fetchRequest()
        let predicate1 = NSPredicate(format: "phnno = %@", "\(phoneNumber)")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1])
        do
        {
            let test = try context.fetch(fetchRequest)
           
            let del = test[0] as NSManagedObject
            
            context.delete(del)
            
            print("Successful")
        }
        catch
        {
            print(error)
        }
    }
}
