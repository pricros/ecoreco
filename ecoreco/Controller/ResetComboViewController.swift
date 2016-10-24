//
//  ResetComboViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

@IBDesignable
class ResetComboViewController: CommonViewController, UITextFieldDelegate {

    @IBOutlet weak var btnLeft: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
    }
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func addLeft(sender: UIButton) {
   
    }
    @IBAction func addRight(sender: UIButton) {
    }
    
    @IBAction func addDown(sender: UIButton) {
        
    }
    @IBAction func confirm(sender: UIButton) {
        self.performSegueWithIdentifier("segueRstCmbToSetName", sender: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtPassword.resignFirstResponder()
        txtPasswordConfirm.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
