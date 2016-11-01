//
//  Created by TSAO EVA on 2015/12/21.
//  Copyright © 2015年 TSAO EVA. All rights reserved.
//

import UIKit
import QuartzCore

class DashboardViewController: CommonViewController, UIScrollViewDelegate {

    @IBOutlet weak var imgViewSetting: UIImageView!
    @IBOutlet weak var imgViewProfile: UIImageView!
//    @IBOutlet weak var imgViewNavi: UIImageView!

    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var imgViewSpeedMeter: UIImageView!
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var scrollViewMode: UIScrollView!
    @IBOutlet weak var btnBattery: UIButton!
    @IBOutlet weak var btnEstimateRange: UIButton!
    @IBOutlet weak var btnTrip: UIButton!
    @IBOutlet weak var btnOdo: UIButton!
    @IBOutlet weak var labelDeviceName: UILabel!
    @IBOutlet weak var btnLock: UIButton!

    var layer:CALayer?
    var bDemoThreadStart:Bool = false
    var bDemoEnable:Bool = false
    var bLockStatus:Bool = false
    let SLEEPINTERVAL:UInt32 = 50000 //micro second
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //set view bgcolor
//        self.view.backgroundColor = UIColor(
//            red: 250/255,
//            green: 250/255,
//            blue: 250/255,
//            alpha: 1.0)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //add tpa action to [Setting]
        let tapGestureRecognizerSetting = UITapGestureRecognizer(target: self, action:#selector(DashboardViewController.tappedSetting))
        imgViewSetting.userInteractionEnabled = true
        imgViewSetting.addGestureRecognizer(tapGestureRecognizerSetting)

        
        //add tpa action to [Profile]
        let tapGestureRecognizerProfile = UITapGestureRecognizer(target: self, action:#selector(DashboardViewController.tappedProfile))
        imgViewProfile.userInteractionEnabled = true
        imgViewProfile.addGestureRecognizer(tapGestureRecognizerProfile)

//        //add tpa action to [Navi]
//        let tapGestureRecognizerNavi = UITapGestureRecognizer(target: self, action:Selector("tappedNavi"))
//        imgViewNavi.userInteractionEnabled = true
//        imgViewNavi.addGestureRecognizer(tapGestureRecognizerNavi)
        
        //add tpa action to [lableSpeed]
 //       let tapGestureRecognizerSpeed = UITapGestureRecognizer(target: self, action:Selector("tappedSpeed"))
//        labelSpeed.userInteractionEnabled = true
//        labelSpeed.addGestureRecognizer(tapGestureRecognizerSpeed)
        
        let font = UIFont(name: (self.labelSpeed.font?.familyName)!, size:150)
        labelSpeed.font = font
        
        
        //scroll view
        let scrollingView = modeButtonsView()
        scrollViewMode.addSubview(scrollingView)
        scrollViewMode.contentSize = scrollingView.frame.size
        scrollViewMode.scrollEnabled = true
        scrollViewMode.showsHorizontalScrollIndicator = true
        scrollViewMode.indicatorStyle = .Default
        
        //set lable size, font, color
        
        btnBattery.setTitle("\(scooter.bat.get())", forState: UIControlState.Normal)
        btnBattery.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnBattery.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnEstimateRange.setTitle("\(scooter.rmm.get())", forState: UIControlState.Normal)
        btnEstimateRange.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnEstimateRange.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnTrip.setTitle("\(scooter.odkA.get())", forState: UIControlState.Normal)
        btnTrip.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnTrip.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnOdo.setTitle("\(scooter.odkTotal.get())", forState: UIControlState.Normal)
        btnOdo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnOdo.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        labelDeviceName.text = "My Scooter"
        labelDeviceName.textColor = ColorUtil.LABEL_INACTIVE_COLOR
        labelDeviceName.font = ColorUtil.FONT_VDS_T4
        
        bLockStatus = scooter.getLockStatus()
        
        if (bLockStatus){
            btnLock.setImage(UIImage(named: "unlock"), forState: UIControlState.Normal)
        } else {
            btnLock.setImage(UIImage(named: "lock"), forState: UIControlState.Normal)
        }
        

        scooter.speed.didChange.addHandler(self, handler: DashboardViewController.speedDidChange)
        scooter.bat.didChange.addHandler(self, handler: DashboardViewController.batteryDidChange)
        scooter.falStatus.didChange.addHandler(self, handler: DashboardViewController.falStatusDidChange)
        scooter.lockStatus.didChange.addHandler(self, handler: DashboardViewController.lockStatusDidChange)
        scooter.odkTotal.didChange.addHandler(self, handler: DashboardViewController.odkTotalDidChange)
        scooter.odkA.didChange.addHandler(self, handler: DashboardViewController.odkADidChange)
        scooter.rmm.didChange.addHandler(self, handler: DashboardViewController.rmmDidChange)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let sizeRect = UIScreen.mainScreen().applicationFrame
        
        // create init pointer image
        let pointerImage = UIImage(named: "pointer.png") as UIImage!
        let pointerWidth   = pointerImage.size.width/1920 * sizeRect.size.width
        let pointerHeight   = pointerImage.size.height/1920 * sizeRect.size.height
        layer = CALayer()
        let speedMeterStartX = imgViewSpeedMeter.frame.origin.x
        let speedMeterStartY = imgViewSpeedMeter.frame.origin.y + imgViewSpeedMeter.frame.height/2 - pointerHeight/2
        layer?.frame = CGRectMake(speedMeterStartX,speedMeterStartY, imgViewSpeedMeter.frame.width , pointerHeight)
        layer?.contents = pointerImage.CGImage as? AnyObject
        self.imgViewSpeedMeter.layer.addSublayer(layer!)
        self.imgViewSpeedMeter.sendSubviewToBack(counterView)
        scooter.enterStandby()
        
    }
    
    func speedToDegree(speed:Int)->Float{
        var degree:Float = 0.0
        degree = Float(speed)/25 * 180
        return degree
    }
    
    func speedToRotation(speed:Int)->CGAffineTransform?{
        var degree:Float = 0
        var rad:Float = 0
        var rotation:CGAffineTransform?
        degree = Float(speed)/25 * 180
        rad = degree/180.0 * Float(M_PI)
        rotation = CGAffineTransformMakeRotation(CGFloat(rad))
        return rotation
    }

    func tappedSetting(){
        self.performSegueWithIdentifier("segueDashToSetting", sender: nil)
        
    }

 


    
    
    func tappedProfile(){
        print("go to diagnose")
        self.performSegueWithIdentifier("segueDashToDiagnose", sender: nil)
    }
    
    func tappedNavi(){
        self.performSegueWithIdentifier("segueDashToMap", sender: nil)
        
       // self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("MapView") as! MapViewController, animated: true)
    }
    
    func tappedSpeed(){
        scooter.lock()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        scooter.exitStandby()
    }
    

    let imagesModeOn = [
        UIImage(named: "modeBoostOn.png") as UIImage!,
        UIImage(named: "modeRideOn.png") as UIImage!,
        UIImage(named: "modeEkickExtendOn.png") as UIImage!,
        UIImage(named: "modeEkickAmplifiedOn.png") as UIImage!,
        UIImage(named: "modeEcoOn.png") as UIImage!
    ]
    let imagesModeOff = [
        UIImage(named: "modeBoostOff.png") as UIImage!,
        UIImage(named: "modeRideOff.png") as UIImage!,
        UIImage(named: "modeEkickExtendOff.png") as UIImage!,
        UIImage(named: "modeEkickAmplifiedOff.png") as UIImage!,
        UIImage(named: "modeEcoOff.png") as UIImage!
    ]
    var modeButtons = [
        UIButton(type: .Custom) as UIButton!,
        UIButton(type: .Custom) as UIButton!,
        UIButton(type: .Custom) as UIButton!,
        UIButton(type: .Custom) as UIButton!,
        UIButton(type: .Custom) as UIButton!
    ]

    func clearAll(){
        for i in 0 ... (modeButtons.count-1) {
            modeButtons[i].setImage(imagesModeOff[i], forState: .Normal)
        }
    }
    
    
    
    var lastMode: UIButton?
    func modePressed(sender:UIButton){
        
        if(self.lastMode != nil){
            self.lastMode!.setImage(imagesModeOff[(lastMode!.tag)], forState: .Normal)
        }
        
        sender.setImage(imagesModeOn[sender.tag], forState: .Normal)
        self.lastMode = sender
        self.lastMode!.tag = sender.tag
        
        switch(sender.tag){
            case 0: //boost
                scooter.setMode(.Ride_1_1)
                break
            case 1:
                scooter.setMode(.Ride)
                break
            case 2:
                scooter.setMode(.Ekick_extend)
                break
            case 3:
                scooter.setMode(.Ekick_amplified)
            case 4:
                scooter.setMode(.ECO)
                break
            default:break
        }
    }


    func modeButtonsView() -> UIView {
 
        let buttonView = UIView()
        //buttonView.backgroundColor = UIColor.blackColor()
        buttonView.frame.origin = CGPointMake(0,0)
        
        let padding = CGSizeMake(10, 10)
        let buttonSize = CGSizeMake(UIScreen.mainScreen().applicationFrame
            .size.width/3.3,UIScreen.mainScreen().applicationFrame
            .size.height/8)//same with image size
        buttonView.frame.size.width = (buttonSize.width + padding.width) * CGFloat(imagesModeOff.count)
        buttonView.frame.size.height = UIScreen.mainScreen().applicationFrame
            .size.height/8
        
        var buttonPosition = CGPointMake(padding.width * 0.5, padding.height)
        let buttonIncrement = buttonSize.width + padding.width

        for i in 0 ... (imagesModeOff.count-1)  {
            let button = modeButtons[i]  //UIButton(type: .Custom) as UIButton
            button.setImage(imagesModeOff[i], forState: .Normal)
            
            button.frame.size = buttonSize
            button.frame.origin = buttonPosition
            buttonPosition.x = buttonPosition.x + buttonIncrement
            //button.layer.cornerRadius = 2;
            //button.layer.borderWidth = 1;
            //button.layer.borderColor = UIColor.whiteColor().CGColor
            //button.backgroundColor = UIColor.grayColor()
            
            button.tag = i
            button.addTarget(self, action: #selector(DashboardViewController.modePressed(_:)), forControlEvents: .TouchUpInside)
            
            buttonView.addSubview(button)
        }

        return buttonView
    }
    
    
    func nrfReceivedData(nrfManager:NRFManager, data:NSData?, string:String?) {
        print(string)
        
    }
    
    func speedDidChange(oldSpeed:Int, newSpeed:Int) {
        
        var rotation:CGAffineTransform?
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0))
        {
            
                rotation = self.speedToRotation(newSpeed)
                
                dispatch_async(dispatch_get_main_queue())
                {
                    self.layer?.setAffineTransform(rotation!)
                    self.labelSpeed.text = "\(newSpeed)"
                    self.counterView.speed = newSpeed
                }
        }
        
    }
    
    func batteryDidChange(oldValue:Int, newValue:Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.btnBattery.setTitle("\(newValue)",forState: UIControlState.Normal)
            //self.labelHeaderBattery.text = "\(newValue)%"
        }
    }
    
    func odkADidChange(oldValue:Int, newValue:Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.btnTrip.setTitle("\(newValue)",forState: UIControlState.Normal)
        }
    }

    func odkTotalDidChange(oldValue:Int, newValue:Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.btnOdo.setTitle("\(newValue)",forState: UIControlState.Normal)
        }
    }

    func rmmDidChange(oldValue:Int, newValue:Int) {
        dispatch_async(dispatch_get_main_queue()) {
            self.btnEstimateRange.setTitle( "\(newValue)",forState: UIControlState.Normal)
        }
    }

    
    func falStatusDidChange(oldValue:Int, newValue:Int) {
        if (newValue == 1 && scooter.getStatus() != ScooterStatus.Fall){
          
            scooter.setStatus(ScooterStatus.Fall)
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FallView") as! FallViewController
            vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func lockStatusDidChange(oldValue:Int, newValue:Int) {
        if (newValue == 1){
            btnLock.setImage(UIImage(named: "unlock"), forState: UIControlState.Normal)
        } else {
            btnLock.setImage(UIImage(named: "lock"), forState: UIControlState.Normal)
        }
        
    }

    @IBAction func lockUnlockScooter(sender: UIButton) {
        if (bLockStatus){
            scooter.unlock()
        }else{
            scooter.lock()
        }
    }

}

