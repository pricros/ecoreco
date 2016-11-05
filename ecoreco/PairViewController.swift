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
       
        labelSearch!.textColor = UIColor.gray
        labelSearch!.textAlignment = NSTextAlignment.center
        labelSearch!.font = UIFont(name:"VDS", size:20.0)
        labelSearch.text = "Searching"
        labelSearch.backgroundColor = UIColor.white

        var radarEcorecoIconx : RadarEcorecoIcon?

        //do search BLE device number x

        //draw x ecoreco items
        drawEcorecoItem(100, y: 200, lableName: "A")
        drawEcorecoItem(100, y: 100, lableName: "B")
        drawEcorecoItem(300, y: 200, lableName: "C")



    }
    
    func tapIcon(){
         self.performSegue(withIdentifier: "seguePairToLock", sender: nil)
    }
    
    func drawEcorecoItem(_ x:CGFloat, y:CGFloat, lableName:String){
        //new a view
        let buttonView = UIView(frame: CGRect(x: x,y: y,width: 100,height: 100))
        
        //add button, lable to the view
        let lbEcoreco = UILabel(frame:CGRect(x: 0, y:0, width:44, height:15))
        lbEcoreco.text = lableName
        lbEcoreco.font = ColorUtil.FONT_VDS_T3
        lbEcoreco.textAlignment = NSTextAlignment.center
        
        let btnEcoreco = UIButton(frame:CGRect(x: 0, y:15, width:44, height:30))
        btnEcoreco.setBackgroundImage(UIImage(named:"iconEcoreco"), for: UIControlState())
        btnEcoreco.setBackgroundImage(UIImage(named:"iconEcoreco-g"), for: .selected)
        if #available(iOS 9.0, *) {
            btnEcoreco.setBackgroundImage(UIImage(named:"iconEcoreco-g"), for: .focused)
        } else {
            // Fallback on earlier versions
        }
        btnEcoreco.contentMode = UIViewContentMode.scaleAspectFit

        buttonView.addSubview(lbEcoreco)
        buttonView.addSubview(btnEcoreco)
        radarView.addSubview(buttonView)
    }


}
