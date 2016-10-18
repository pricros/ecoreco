//
//  RadarEcorecoIcon.swift
//  ecoreco
//
//  Created by admin on 2016/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class RadarEcorecoIcon: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        drawEcorecoIcon(32)

    }
 
    
    func drawEcorecoIcon(strength:Float){
        let image = UIImage(named: "ecorecoIcon")
        image?.drawInRect(CGRectMake(0, 0, 50, 30))
        
    }

}
