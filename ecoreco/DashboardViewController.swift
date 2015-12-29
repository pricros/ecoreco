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
    
    
    @IBOutlet weak var scrollMode: UIScrollView!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        scrollMode.addSubview(scrollingView)
        scrollMode.contentSize = scrollingView.frame.size
        scrollMode.scrollEnabled = true
        scrollMode.showsHorizontalScrollIndicator = true
        scrollMode.indicatorStyle = .Default
        
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
            appDelegate.sendData("0")
            self.imgViewPower.image = imgPowerOff
            isPowerOn = false
        }else{
            appDelegate.sendData("0")
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
    

    var lastMode: UIButton?
    func modePressed(sender:UIButton){
        lastMode?.backgroundColor = UIColor.grayColor()
        sender.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 1.0, alpha: 1.0)
        self.lastMode = sender
    }
    
    
    
    
    
    
    let images = [
        UIImage(named: "modeBoostOff.png") as UIImage!,
        UIImage(named: "modeRideOff.png") as UIImage!,
        UIImage(named: "modeEkickExtendOff.png") as UIImage!,
        UIImage(named: "modeEkickAmplifiedOff.png") as UIImage!,
        UIImage(named: "modeEcoOff.png") as UIImage!
    ]

    let buttonView = UIView()

    func modeButtonsView() -> UIView {
 
        buttonView.backgroundColor = UIColor.blackColor()
        buttonView.frame.origin = CGPointMake(0,0)
        
        let padding = CGSizeMake(10, 0)
        let buttonSize = CGSizeMake(109.0,75.0)//same with image size
        buttonView.frame.size.width = (buttonSize.width + padding.width) * CGFloat(images.count)
        buttonView.frame.size.height = 75
        
        var buttonPosition = CGPointMake(padding.width * 0.5, padding.height)
        let buttonIncrement = buttonSize.width + padding.width

        for i in 0 ... (images.count-1)  {
            let button = UIButton(type: .Custom) as UIButton
            button.setImage(images[i], forState: .Normal)
            
            button.frame.size = buttonSize
            button.frame.origin = buttonPosition
            buttonPosition.x = buttonPosition.x + buttonIncrement
            button.layer.cornerRadius = 2;
            button.layer.borderWidth = 1;
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.backgroundColor = UIColor.grayColor()
            button.addTarget(self, action: "modePressed:", forControlEvents: .TouchUpInside)
            
            buttonView.addSubview(button)
        }

        return buttonView
    }
    
    
    
    
    

}

