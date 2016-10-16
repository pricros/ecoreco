//
//  SearchTableViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class SearchTableViewController: CommonViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name = ["A-ID:", "B-ID:", "C-ID:"]
    var images = [UIImage(named: "bgDevice"), UIImage(named: "bgDevice"), UIImage(named: "bgDevice")]
    
    @IBOutlet var searchTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.searchTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.buttonDeviceListItem.userInteractionEnabled = true
       // cell.buttonDeviceListItem.setBackgroundImage(UIImage(named: "bgDevice"), forState: .Normal)
        cell.buttonDeviceListItem.setTitleColor(ColorUtil.hexStringToUIColor("0x8d8d8d"), forState: UIControlState.Normal)
        cell.buttonDeviceListItem.setTitleColor(ColorUtil.hexStringToUIColor("0x91aa00"), forState: UIControlState.Highlighted)
        cell.buttonDeviceListItem.setTitleColor(ColorUtil.hexStringToUIColor("0x91aa00"), forState:UIControlState.Focused)
        cell.buttonDeviceListItem.setTitle(name[indexPath.row], forState: .Normal)
        cell.buttonDeviceListItem.addTarget(self, action:  "deviceClicked:", forControlEvents: .TouchUpInside)
       
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var cell = self.searchTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.buttonDeviceListItem.sendActionsForControlEvents(.TouchUpInside)
    }
    
    
    func deviceClicked(sender:UIButton){
        print("item \(sender.titleLabel?.text) selected")
        scooter.connect()
      //  self.performSegueWithIdentifier("seguePairToDash", sender: nil)
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
