//
//  RadarCanvas.swift
//  ecoreco
//
//  Created by admin on 2016/10/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class RadarCanvas: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let adjustDistance:CGFloat = 22
//
//        let path = CGPathCreateMutable()
//        
        let circleWidth = self.frame.height - adjustDistance
//        let smallCircleWidth:CGFloat = 5
//        let eclipseArea = CGRectMake((self.frame.width-circleWidth)/2, (self.frame.width-circleWidth)/2, circleWidth,circleWidth)
//        
//        let smallEclipseArea = CGRectMake(self.frame.width - smallCircleWidth, (self.frame.width-circleWidth)/2, circleWidth,circleWidth)
//        
//        CGPathAddEllipseInRect(path, nil, eclipseArea)
//        
//        let context = UIGraphicsGetCurrentContext()
//        
//        CGContextAddPath(context, path)
//        
//        CGContextSetLineWidth(context, 10)
//        
//        UIColor.grayColor().setStroke()
//        
//        UIColor.whiteColor().setFill()
//        
//        CGContextDrawPath(context, .EOFillStroke)
        
//        let color = UIColor.grayColor()
//        color.set()
//        let aPath = UIBezierPath(arcCenter: CGPointMake(self.frame.width/2, self.frame.height/2), radius:circleWidth,
//                                 startAngle:(CGFloat)(112.5*M_PI/180), endAngle:(CGFloat)(67.5*M_PI/180), clockwise:true)
//        aPath.lineWidth = 5.0
//        aPath.stroke()
        
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
        UIColor.grayColor().setStroke()
        path.stroke()
        
        drawEcorecoIcon()
        drawGreenEcorecoIcon()
        
    }
 
    func drawEcorecoIcon(){
        let image = UIImage(named: "r")
        image?.drawInRect(CGRectMake(0, 0, 50, 50))
        
    }
    
    func drawGreenEcorecoIcon(){
        let image = UIImage(named: "r-g")
        image?.drawInRect(CGRectMake(100, 100, 50, 50))
        
    }

}
