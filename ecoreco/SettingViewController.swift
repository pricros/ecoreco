//
//  SettingViewController.swift
//  ecoreco
//
//  Created by apple on 2015/12/22.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

class SettingViewController: CommonViewController {
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    @IBOutlet weak var labelVer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //add tpa action to imgBack
        let tapGestureRecognizerImgBack = UITapGestureRecognizer(target: self, action:#selector(SettingViewController.tappedBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapGestureRecognizerImgBack)
    
        
        //add tpa action to imgUserProfile
        let tapGestureRecognizerImgUserProfile = UITapGestureRecognizer(target: self, action:#selector(SettingViewController.tappedUserProfile))
        imgUserProfile.isUserInteractionEnabled = true
        imgUserProfile.addGestureRecognizer(tapGestureRecognizerImgUserProfile)

        
        let imageSettings  = UIImage(named: "settings")
        //        partitionImage.image = image1
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.labelVer.text = version
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources thatp can be recreated.
    }
    
    func tappedBack(){
        let sbSettings:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        self.navigationController?.pushViewController(sbSettings.instantiateViewController(withIdentifier: "DashboardView") as! DashboardViewController, animated: true)
    }
    
    //add by eva
    func tappedUserProfile()
    {
        self.performSegue(withIdentifier: "segueToUserProfile", sender: nil)
    }

}

