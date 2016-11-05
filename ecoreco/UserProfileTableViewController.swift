//
//  UserProfileTableViewController.swift
//  ecoreco
//
//  Created by TSAO EVA on 2016/10/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UITableViewController {

    
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUnit: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
//        print("###########TEST Core Data################")
//        let dc = UserDeviceSettingDC()
//        //dc.save(deviceId: "DEVICE_ID_AAAA", email: nil, emergencycall: "0937218247", emergencysms: "0937218247", sound: nil, speedLimit: nil, vibrate: nil)
//        var entity = dc.find(deviceId: "DEVICE_ID_AAAA")
//        dc.show()
//        print("###########END TEST Core Data################")
        
        
        
        
        //default show local data
        
        /*
        
        //refresh data & update
        
        let requestURL: NSURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    
                    if let stations = json["stations"] as? [[String: Any]] {
                        
                        for station in stations {
                            
                            if let name = station["stationName"] as? String {
                                
                                if let year = station["buildYear"] as? String {
                                    print(name,year)
                                    
                                    //self.txtName.text = name
                                    self.txtEmail.text = year
                                }
                                
                            }
                        }
                                     }
 
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        
        task.resume()
                 */
        
        
        
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//        
//        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
    
    
    
}
