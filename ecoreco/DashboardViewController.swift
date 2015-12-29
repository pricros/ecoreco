//
//  Created by TSAO EVA on 2015/12/21.
//  Copyright © 2015年 TSAO EVA. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgPower: UIImageView!
    @IBOutlet weak var imgNavi: UIImageView!
    @IBOutlet weak var imgSetting: UIImageView!

    @IBOutlet weak var scrollMode: UIScrollView!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //add tpa action to imgSetting
        let tapGestureRecognizerImgSetting = UITapGestureRecognizer(target: self, action:Selector("tappedSetting"))
        imgSetting.userInteractionEnabled = true
        imgSetting.addGestureRecognizer(tapGestureRecognizerImgSetting)

        
        //add tpa action to imgPower
        let tapGestureRecognizerImgPower = UITapGestureRecognizer(target: self, action:Selector("tappedPower"))
        imgPower.userInteractionEnabled = true
        imgPower.addGestureRecognizer(tapGestureRecognizerImgPower)

        
        //add tpa action to imgProfile
        let tapGestureRecognizerImgProfile = UITapGestureRecognizer(target: self, action:Selector("tappedProfile"))
        imgProfile.userInteractionEnabled = true
        imgProfile.addGestureRecognizer(tapGestureRecognizerImgProfile)

        //add tpa action to imgNavi
        let tapGestureRecognizerImgNavi = UITapGestureRecognizer(target: self, action:Selector("tappedNavi"))
        imgNavi.userInteractionEnabled = true
        imgNavi.addGestureRecognizer(tapGestureRecognizerImgNavi)
        
        
        
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
    
    func tappedPower(){
        appDelegate.sendData("0")
        print("power off")
    }
    
    func tappedProfile(){
        appDelegate.sendData("1")
        print("go to profilt")
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
    
    
    func modeButtonsView() -> UIView {
        let images = [
            UIImage(named: "img_modeBoostOff.png") as UIImage!,
            UIImage(named: "img_modeRideOff.png") as UIImage!,
            UIImage(named: "img_modeEkickOff.png") as UIImage!,
            UIImage(named: "img_modeEkickOff.png") as UIImage!,
            UIImage(named: "img_modeEkickOff.png") as UIImage!,
            UIImage(named: "img_modeEkickOff.png") as UIImage!
        ]
        
        let buttonView = UIView()
 
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
            button.backgroundColor = UIColor.grayColor()
            button.addTarget(self, action: "modePressed:", forControlEvents: .TouchUpInside)
            
            buttonView.addSubview(button)
        }

        return buttonView
    }
    
    

}

