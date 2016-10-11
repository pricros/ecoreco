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
   
        
    }
    
    func tapIcon(){
         self.performSegueWithIdentifier("seguePairToLock", sender: nil)
    }


}