//
//  SearchTableViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class SearchTableViewController: CommonViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name = ["A-ID:ECORECO1", "B-ID:ECORECO2", "C-ID:ECORECO3"]
    var images = [UIImage(named: "bgDevice"), UIImage(named: "bgDevice"), UIImage(named: "bgDevice")]
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var searchTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.buttonDeviceListItem.isUserInteractionEnabled = true
       // cell.buttonDeviceListItem.setBackgroundImage(UIImage(named: "bgDevice"), forState: .Normal)
        cell.buttonDeviceListItem.setTitleColor(ColorUtil.LABEL_INACTIVE_COLOR, for: UIControlState())
        cell.buttonDeviceListItem.setTitleColor(ColorUtil.LABEL_ACTIVE_COLOR, for: UIControlState.highlighted)
        cell.buttonDeviceListItem.setTitleColor(ColorUtil.LABEL_ACTIVE_COLOR, for:UIControlState.selected)
        cell.buttonDeviceListItem.setTitle(name[indexPath.row], for: UIControlState())
        cell.buttonDeviceListItem.setTitle(name[indexPath.row], for: .highlighted)
        cell.buttonDeviceListItem.addTarget(self, action:  #selector(SearchTableViewController.deviceClicked(_:)), for: .touchUpInside)
       
        
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        var cell = self.searchTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SearchTableViewCell
//        cell.buttonDeviceListItem.sendActionsForControlEvents(.TouchUpInside)
//    }
    
    
    func deviceClicked(_ sender:UIButton){
        NSLog("item \(sender.titleLabel?.text) selected")
        //search device and user email in db, 
        //if exist, get data
        //@todo: get data by email, deviceId
        let email = userDefaults.string(forKey: Constants.kUserDefaultAccount)
        let deviceId = sender.currentTitle
        userDefaults.set(deviceId, forKey: Constants.kUserDefaultAccount)

        
        //===============setting sample
        
        userDefaults.set(deviceId, forKey: Constants.kUserDefaultDeviceId)
        
        //===============end setting sample
        print("##### GET SMS CALL IN CORE DATA")
        
        let dc = UserDeviceSettingDC()
        var entity = dc.find(
                deviceId: userDefaults.object(forKey: Constants.kUserDefaultDeviceId) as! String)
            
        //else create data
        if(entity==nil){
            dc.save(deviceId: deviceId, email: nil, emergencycall: Constants.kDefaultSettingEmergencyCall, emergencysms: "", sound: nil, speedLimit: nil, vibrate: nil)
            NSLog("create core data : \(deviceId!)")
        }else{
            NSLog("found core data : \(deviceId!)")
        }

        scooter.connect()
        self.performSegue(withIdentifier: "seguePairToRstCmb", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
