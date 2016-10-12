//
//  SearchTableViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name = ["A---", "B---", "C---"]
    var images = [UIImage(named: "lineMiddle"), UIImage(named: "lineMiddle"), UIImage(named: "lineMiddle")]
    
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
        
        cell.bgImageView.image = images[indexPath.row]
        cell.labelName.text = name[indexPath.row]
        
        return cell
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
