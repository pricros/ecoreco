//
//  DashViewController.swift
//  ecoreco
//
//  Created by apple on 2015/12/21.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

class DashViewController: UIViewController {
    
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var speedImage: UIImageView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBAction func goSetting(sender: AnyObject) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("SettingView") as! SettingViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imageSpeed  = UIImage(named: "speed")
        let imageHeader  = UIImage(named: "header_2")
//        partitionImage.image = image1
        speedImage.image = imageSpeed
        headerImage.image = imageHeader
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mode2(sender: UIButton) {
        appDelegate.sendData("M2")
    }
    
    @IBAction func mode1(sender: UIButton) {
        appDelegate.sendData("M1")
    }
    
    
    @IBAction func light(sender: UIButton) {
        appDelegate.sendData("1")
    }
    
    @IBAction func turnoff(sender: AnyObject) {
        appDelegate.sendData("0")
    }
}
