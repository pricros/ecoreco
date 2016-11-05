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
        
        btnBattery.setTitle("\(scooter.bat.get())", for: UIControlState())
        btnBattery.setTitleColor(UIColor.white, for: UIControlState())
        btnBattery.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnRmm.setTitle("\(scooter.rmm.get())", for: UIControlState())
        btnRmm.setTitleColor(UIColor.white, for: UIControlState())
        btnRmm.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnTrip.setTitle("\(scooter.odkA.get())", for: UIControlState())
        btnTrip.setTitleColor(UIColor.white, for: UIControlState())
        btnTrip.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        btnOdo.setTitle("\(scooter.odkTotal.get())", for: UIControlState())
        btnOdo.setTitleColor(UIColor.white, for: UIControlState())
        btnOdo.titleLabel!.font = ColorUtil.FONT_VDS_R1
        
        
        scooter.bat.didChange.addHandler(self, handler: DiagnoseViewController.batteryDidChange)

        
        scooter.odkTotal.didChange.addHandler(self, handler: DiagnoseViewController.odkTotalDidChange)
        scooter.odkA.didChange.addHandler(self, handler: DiagnoseViewController.odkADidChange)
        scooter.rmm.didChange.addHandler(self, handler: DiagnoseViewController.rmmDidChange)
    }
    
    
    func batteryDidChange(_ oldValue:Int, newValue:Int) {
        DispatchQueue.main.async {
            self.btnBattery.setTitle("\(newValue)",for: UIControlState())
            //self.labelHeaderBattery.text = "\(newValue)%"
        }
    }
    
    func odkADidChange(_ oldValue:Int, newValue:Int) {
        DispatchQueue.main.async {
            self.btnTrip.setTitle("\(newValue)",for: UIControlState())
        }
    }
    
    func odkTotalDidChange(_ oldValue:Int, newValue:Int) {
        DispatchQueue.main.async {
            self.btnOdo.setTitle("\(newValue)",for: UIControlState())
        }
    }
    
    func rmmDidChange(_ oldValue:Int, newValue:Int) {
        DispatchQueue.main.async {
            self.btnRmm.setTitle( "\(newValue)",for: UIControlState())
        }
    }
    
}
