//
//  ResetComboViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

@IBDesignable
class ResetComboViewController: CommonViewController {

    @IBOutlet weak var btnLeft: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func addLeft(sender: UIButton) {
   
    }
    
    @IBAction func confirm(sender: UIButton) {
        self.performSegueWithIdentifier("segueRstCmbToSetName", sender: nil)
    }
    
}
