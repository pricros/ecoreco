//
//  DiagnoseViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class DiagnoseViewController: CommonViewController {

    @IBOutlet weak var btnTrip: UIButton!
    @IBOutlet weak var btnBattery: UIButton!
    @IBOutlet weak var btnRmm: UIButton!
    @IBOutlet weak var btnOdo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set lable size, font, color
        
        btnBattery.setTitle("\(scooter.bat.get())", forState: UIControlState.Normal)
        btnBattery.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnBattery.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnRmm.setTitle("\(scooter.rmm.get())", forState: UIControlState.Normal)
        btnRmm.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnRmm.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnTrip.setTitle("\(scooter.odkA.get())", forState: UIControlState.Normal)
        btnTrip.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnTrip.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnOdo.setTitle("\(scooter.odkTotal.get())", forState: UIControlState.Normal)
        btnOdo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnOdo.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        
        scooter.bat.didChange.addHandler(self, handler: DiagnoseViewController.batteryDidChange)

        
        scooter.odkTotal.didChange.addHandler(self, handler: DiagnoseViewController.odkTotalDidChange)
        scooter.odkA.didChange.addHandler(self, handler: DiagnoseViewController.odkADidChange)
        scooter.rmm.didChange.addHandler(self, handler: DiagnoseViewController.rmmDidChange)
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
            self.btnRmm.setTitle( "\(newValue)",forState: UIControlState.Normal)
        }
    }
    
}
