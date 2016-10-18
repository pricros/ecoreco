//
//  PairViewController.swift
//  ecoreco
//
//  Created by admin on 2016/8/15.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import Foundation

class PairViewController: CommonViewController {
    @IBOutlet weak var labelSearch: UILabel!
    @IBOutlet weak var radarView: UIView!
    @IBOutlet weak var radarEcorecoIcon: RadarEcorecoIcon!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        labelSearch!.textColor = UIColor.grayColor()
        labelSearch!.textAlignment = NSTextAlignment.Center
        labelSearch!.font = UIFont(name:"VDS", size:20.0)
        labelSearch.text = "Searching"
        labelSearch.backgroundColor = UIColor.whiteColor()

        var radarEcorecoIconx : RadarEcorecoIcon?

        //do search BLE device number x

        //draw x ecoreco items


    }
    
    func tapIcon(){
         self.performSegueWithIdentifier("seguePairToLock", sender: nil)
    }


}