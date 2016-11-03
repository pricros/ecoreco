//
//  CounterView.swift
//  ecoreco
//
//  Created by apple on 2016/6/7.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class CounterView: UIView {
    
    @IBInspectable var speed: Int = 5 {
        didSet {
            if speed <= 25 {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.greenColor()
    

    
    override func drawRect(rect: CGRect) {
        // 1
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // 2
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // 4
        let startAngle: CGFloat =  π
        let endAngle: CGFloat =  π * (1 + 1 / 25 * CGFloat(speed))
        
        // 5
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - Constants.kCGFloatAdjustWidth,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        // 6
        path.lineWidth = Constants.kCGFloatArcWidth
        counterColor.setStroke()
        path.stroke()
        
    }
}
