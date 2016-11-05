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
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawEcorecoIcon(32)

    }
 
    
    func drawEcorecoIcon(_ strength:Float){
        let image = UIImage(named: "ecorecoIcon")
        image?.draw(in: CGRect(x: 0, y: 0, width: 50, height: 30))
        
    }

}
