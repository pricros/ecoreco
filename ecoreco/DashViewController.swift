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

}
