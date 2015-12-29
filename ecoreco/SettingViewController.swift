//
//  SettingViewController.swift
//  ecoreco
//
//  Created by apple on 2015/12/22.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var settingsImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //add tpa action to imgSetting
        let tapGestureRecognizerImgBack = UITapGestureRecognizer(target: self, action:Selector("tappedBack"))
        imgBack.userInteractionEnabled = true
        imgBack.addGestureRecognizer(tapGestureRecognizerImgBack)
        
        let imageSettings  = UIImage(named: "settings")
        //        partitionImage.image = image1
        settingsImage.image = imageSettings
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources thatp can be recreated.
    }
    
    func tappedBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}

