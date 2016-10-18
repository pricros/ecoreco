//
//  SetDeviceNameViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class SetDeviceNameViewController: CommonViewController {

    @IBAction func confirmToNextPage(sender: UIButton) {
        self.performSegueWithIdentifier("segueSetNameToDash", sender: nil)
    }

}
