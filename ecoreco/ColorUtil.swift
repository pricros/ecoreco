//
//  ColorUtil.swift
//  ecoreco
//
//  Created by admin on 2016/10/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import UIKit

class ColorUtil {
    
    static let LABEL_INACTIVE_COLOR:UIColor = ColorUtil.hexStringToUIColor("0x8d8d8d")
    static let LABEL_ACTIVE_COLOR:UIColor = ColorUtil.hexStringToUIColor("0x91aa00")
    
    static let FONT_VDS_R1:UIFont = UIFont(name:"VDS", size:33.3)!
    static let FONT_VDS_R2:UIFont = UIFont(name:"VDS", size:21.3)!
    static let FONT_VDS_R3:UIFont = UIFont(name:"VDS", size:18.6)!
    static let FONT_VDS_R4:UIFont = UIFont(name:"VDS", size:16.0)!
    static let FONT_VDS_R5:UIFont = UIFont(name:"VDS", size:13.3)!
    
    static let FONT_VDS_T1:UIFont = UIFont(name:"VDS-Thin", size:33.3)!
    static let FONT_VDS_T2:UIFont = UIFont(name:"VDS-Thin", size:21.3)!
    static let FONT_VDS_T3:UIFont = UIFont(name:"VDS-Thin", size:18.6)!
    static let FONT_VDS_T4:UIFont = UIFont(name:"VDS-Thin", size:16.0)!
    static let FONT_VDS_T5:UIFont = UIFont(name:"VDS-Thin", size:13.3)!
    
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}