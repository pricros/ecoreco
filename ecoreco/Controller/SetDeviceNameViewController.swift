//
//  SetDeviceNameViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class SetDeviceNameViewController: CommonViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtDeviceName: UITextField!
    
    override func viewDidLoad() {
        txtDeviceName.delegate = self
    }

    @IBAction func confirmToNextPage(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueSetNameToDash", sender: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
