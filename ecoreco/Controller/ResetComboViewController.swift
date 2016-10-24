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
    
    var password1:Int32?
    var password2:Int32?
    var bShowPassword:Bool?

    @IBOutlet weak var btnLeft: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        bShowPassword = false
        txtPassword.secureTextEntry = false
        txtPasswordConfirm.secureTextEntry = false
    }
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func addLeft(sender: UIButton) {
        let unicode:String = "\u{2190}"
        addTextToCurrentTextField(unicode)

    }
    
    var currentTextField: UITextField?
    
    @IBAction func addRight(sender: UIButton) {
        let unicode:String = "\u{2192}"
        addTextToCurrentTextField(unicode)
        
        print(currentTextField)
    }
    
    @IBAction func addDown(sender: UIButton) {
        let unicode:String = "\u{2193}"
        addTextToCurrentTextField(unicode)

        
    }
    @IBAction func confirm(sender: UIButton) {
        self.performSegueWithIdentifier("segueRstCmbToSetName", sender: nil)
    }
    
    func addTextToCurrentTextField(unicode:String){
        currentTextField?.text = (currentTextField?.text)!+unicode
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        txtPassword.resignFirstResponder()
//        txtPasswordConfirm.resignFirstResponder()
//        self.view.endEditing(true)
//    }
//    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        textField.borderStyle = UITextBorderStyle.Bezel
        currentTextField = textField
        // Additional code here
        return false
    }
    
    @IBAction func showPassword(sender: UIButton) {
        if ((bShowPassword) == true){ // not show
            sender.setImage(UIImage(named:"uncheck-rstCmb"), forState: UIControlState.Normal)
            txtPassword.secureTextEntry = true
            txtPasswordConfirm.secureTextEntry = true
            bShowPassword = false
        } else { //  show
            sender.setImage(UIImage(named:"checked-rstCmb"), forState: UIControlState.Normal)
            txtPassword.secureTextEntry = false
            txtPasswordConfirm.secureTextEntry = false
            bShowPassword = true
        }

    }
//    func textFieldDidEndEditing(textField: UITextField) {
//        textField.borderStyle = UITextBorderStyle.None
//        // Additional code here
//    }
//
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        currentTextField = textField
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
