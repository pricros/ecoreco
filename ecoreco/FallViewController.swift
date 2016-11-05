//
//  SettingViewController.swift
//  ecoreco
//
//  Created by apple on 2015/12/22.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

class FallViewController: CommonViewController {
    
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var imgCall: UIImageView!

    @IBOutlet weak var imgBack: UIButton!
    
    var limitSec : Int = 60
    var counter : Int = 0
    var isCalled : Bool = false
    var callTimer : Timer?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //===============setting sample
       
        userDefaults.set(30, forKey: "ecoreco_fall_limitSec")
        //===============end setting sample
        
        
        
        
        self.modalPresentationStyle = .custom
        
        //add tpa action to imgReset
        let tapGestureRecognizerImgBack = UITapGestureRecognizer(target: self, action:#selector(FallViewController.tappedBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapGestureRecognizerImgBack)
        
        //add tpa action to imgCall
        let tapGestureRecognizerImgCall = UITapGestureRecognizer(target: self, action:#selector(FallViewController.tappedCall))
        imgCall.isUserInteractionEnabled = true
        imgCall.addGestureRecognizer(tapGestureRecognizerImgCall)
        
        
        //counter
        self.limitSec = userDefaults.integer(forKey: "ecoreco_fall_limitSec")
        print("limitSec=\(limitSec)")
        self.callTimer = Timer.scheduledTimer(
            timeInterval: 1, target : self, selector : #selector(FallViewController.showCounter), userInfo : nil, repeats : true)
        
        //        let limitSec = userDefaults.integerForKey("ecoreco_fall_limitSec")
        //        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        //        dispatch_async(dispatch_get_global_queue(priority, 0)){
        //            for i in 0...limitSec {
        //                usleep(10000)
        //                dispatch_async(dispatch_get_main_queue()){
        //                    self.labelCount.text = "in \(limitSec-i) sec"
        //                }
        //            }
        //        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources thatp can be recreated.
    }
    
    func tappedBack(){
        self.scooter.resetFallStatus()
        self.callTimer!.invalidate()
        self.callTimer = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tappedCall(){
        //stop counter
        self.isCalled = true
        
        let phoneNo = userDefaults.object(forKey: Constants.kUserDefaultEmergencyCall) as! String
        
        print("phoneNo: \(phoneNo)")
        
        if !phoneNo.isEmpty{
            let url = URL(string: "tel://\(phoneNo)")
            UIApplication.shared.openURL(url!)
        }
    }
    
    
    func showCounter(){
        
        let sec : Int = self.limitSec - self.counter
        
        if sec >= 0 {
            self.labelCount.text = "in \(sec) sec"
            if !self.isCalled {
                self.counter += 1
            }
        }else{
            if !self.isCalled {
                self.labelCount.text = "Calling..."
                tappedCall()
                //tappedBack()
            }
        }
    }
    
    
}

