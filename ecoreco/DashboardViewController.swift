//
//  Created by TSAO EVA on 2015/12/21.
//  Copyright © 2015年 TSAO EVA. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imgViewSetting: UIImageView!
    @IBOutlet weak var imgViewPower: UIImageView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewNavi: UIImageView!
    
    @IBOutlet weak var scrollViewMode: UIScrollView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //set view bgcolor
        self.view.backgroundColor = UIColor(
            red: 0.33,
            green: 0.33,
            blue: 0.33,
            alpha: 0.4)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //add tpa action to [Setting]
        let tapGestureRecognizerSetting = UITapGestureRecognizer(target: self, action:Selector("tappedSetting"))
        imgViewSetting.userInteractionEnabled = true
        imgViewSetting.addGestureRecognizer(tapGestureRecognizerSetting)

        
        //add tpa action to [Power]
        let tapGestureRecognizerPower = UITapGestureRecognizer(target: self, action:Selector("tappedPower"))
        imgViewPower.userInteractionEnabled = true
        imgViewPower.addGestureRecognizer(tapGestureRecognizerPower)

        
        //add tpa action to [Profile]
        let tapGestureRecognizerProfile = UITapGestureRecognizer(target: self, action:Selector("tappedProfile"))
        imgViewProfile.userInteractionEnabled = true
        imgViewProfile.addGestureRecognizer(tapGestureRecognizerProfile)

        //add tpa action to [Navi]
        let tapGestureRecognizerNavi = UITapGestureRecognizer(target: self, action:Selector("tappedNavi"))
        imgViewNavi.userInteractionEnabled = true
        imgViewNavi.addGestureRecognizer(tapGestureRecognizerNavi)
        
        
        
        //scroll view
        let scrollingView = modeButtonsView()
        scrollViewMode.addSubview(scrollingView)
        scrollViewMode.contentSize = scrollingView.frame.size
        scrollViewMode.scrollEnabled = true
        scrollViewMode.showsHorizontalScrollIndicator = true
        scrollViewMode.indicatorStyle = .Default
        
    }

    func tappedSetting(){
        self.performSegueWithIdentifier("segueDashToSetting", sender: nil)
        // self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("SettingView") as! SettingViewController, animated: true)
    }
    
    var isPowerOn = true
    let imgPowerOn = UIImage(named: "iconPowerOn.png") as UIImage!
    let imgPowerOff = UIImage(named: "iconPowerOff.png") as UIImage!
    func tappedPower(){
        print("power off")
        
        if (isPowerOn == true) {
            appDelegate.sendData("L1")
            self.imgViewPower.image = imgPowerOff
            isPowerOn = false
            clearAll()
        }else{
            appDelegate.sendData("L0")
            self.imgViewPower.image = imgPowerOn
            isPowerOn = true
        }
    }
    
    func tappedProfile(){
        print("go to profilt")
        appDelegate.sendData("1")
    }
    
    func tappedNavi(){
        self.performSegueWithIdentifier("segueDashToMap", sender: nil)
        
       // self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("MapView") as! MapViewController, animated: true)
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
        //lastMode?.backgroundColor = UIColor.grayColor()
        //sender.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 1.0, alpha: 1.0)
        
        if(self.lastMode != nil){
            self.lastMode!.setImage(imagesModeOff[(lastMode!.tag)], forState: .Normal)
        }
        
        sender.setImage(imagesModeOn[sender.tag], forState: .Normal)
        self.lastMode = sender
        self.lastMode!.tag = sender.tag
        
        switch(sender.tag){
            case 0: //boost
                appDelegate.sendData("M0")
                break
            case 1:
                appDelegate.sendData("M1")
                break
            case 2:
                appDelegate.sendData("M2")
                break
            case 3:
                appDelegate.sendData("M3")
                break
            case 4:
                appDelegate.sendData("M4")
                break
            default:break
        }
    }


    func modeButtonsView() -> UIView {
 
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.blackColor()
        buttonView.frame.origin = CGPointMake(0,0)
        
        let padding = CGSizeMake(10, 0)
        let buttonSize = CGSizeMake(109.0,75.0)//same with image size
        buttonView.frame.size.width = (buttonSize.width + padding.width) * CGFloat(imagesModeOff.count)
        buttonView.frame.size.height = 75
        
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
            button.addTarget(self, action: "modePressed:", forControlEvents: .TouchUpInside)
            
            buttonView.addSubview(button)
        }

        return buttonView
    }
    
    
    
    
    

}

