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
    
    var phoneNo: String?
    let limitSec : Int = 30
    var counter : Int = 0
    var isCalled : Bool = false
    var callTimer : Timer?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //===============setting sample

        userDefaults.set("DEVICE_ID_AAAA", forKey: Constants.kUserDefaultDeviceId)

        //===============end setting sample
        print("##### GET SMS CALL IN CORE DATA")
        if(phoneNo==nil){
            let dc = UserDeviceSettingDC()
            var entity = dc.find(
                deviceId: userDefaults.object(forKey: Constants.kUserDefaultDeviceId) as! String)

            if(entity==nil){
                dc.save(deviceId: "DEVICE_ID_AAAA", email: nil, emergencycall: "0937218247", emergencysms: "0937218247", sound: nil, speedLimit: nil, vibrate: nil)
                entity = dc.find(
                    deviceId: userDefaults.object(forKey: Constants.kUserDefaultDeviceId) as! String)
            }
            
            phoneNo = entity?.emergencycall
        }
        print("phoneNo is \(phoneNo)")
        print("##### END OF GET SMS CALL IN CORE DATA")

        
        

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
        self.callTimer = Timer.scheduledTimer(
            timeInterval: 1, target : self, selector : #selector(FallViewController.showCounter), userInfo : nil, repeats : true)

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
        

        if (phoneNo != nil){
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

