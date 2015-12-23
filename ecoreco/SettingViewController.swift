//
//  SettingViewController.swift
//  ecoreco
//
//  Created by apple on 2015/12/22.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var p41Image: UIImageView!
    
    @IBOutlet weak var p42Image: UIImageView!
    
    @IBOutlet weak var p43Image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imagep41  = UIImage(named: "p_4_1")
        let imagep42  = UIImage(named: "p_4_2")
        let imagep43  = UIImage(named: "p_4_3")
        //        partitionImage.image = image1
        p41Image.image = imagep41
        p42Image.image = imagep42
        p43Image.image = imagep43
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

