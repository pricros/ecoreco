//
//  RadarCanvas.swift
//  ecoreco
//
//  Created by admin on 2016/10/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

@IBDesignable
class RadarCanvas: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let adjustDistance:CGFloat = 22
        let circleWidth = self.frame.height - adjustDistance
        // 1
        let π:CGFloat = CGFloat(M_PI)
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        // 3
        let arcWidth: CGFloat = 5
        // 2
        let radius: CGFloat = max(bounds.width, bounds.height) - arcWidth
        // 4
        let startAngle: CGFloat =  π*5/8
        let endAngle: CGFloat =  π*3/8
        // 5
        var path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - 24,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        // 6
        path.lineWidth = arcWidth
        let lineColor = ColorUtil.hexStringToUIColor("#dbdbdb")
        lineColor.setStroke()
        path.stroke()

    }


}
