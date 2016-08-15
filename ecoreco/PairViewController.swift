//
//  PairViewController.swift
//  ecoreco
//
//  Created by admin on 2016/8/15.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class PairViewController: CommonViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "雷达扫描"
        let KMainWidth:CGFloat  = UIScreen.mainScreen().bounds.size.width
        let KMainHeight:CGFloat  = UIScreen.mainScreen().bounds.size.height
        
        self.view.backgroundColor = UIColor.blackColor()
        
        let radarView:WKFRadarView = WKFRadarView.init(frame: CGRectMake(0, (KMainHeight-KMainWidth)/2, KMainWidth, KMainWidth) , andThumbnail: "logo")
        self.view.addSubview(radarView)
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: radarView, selector:Selector("addOrReplaceItem"), userInfo: nil, repeats: true)
        
    }
    
    func tapIcon(){
         self.performSegueWithIdentifier("seguePairToLock", sender: nil)
    }


}