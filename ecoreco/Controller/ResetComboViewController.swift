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
    
    var password1:String?
    var password2:String?
    var bShowPassword:Bool?
    let kMaxLength = 6

    @IBOutlet weak var btnLeft: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        bShowPassword = false
        txtPassword.secureTextEntry = true
        txtPasswordConfirm.secureTextEntry = true
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
    
    func addTextToCurrentTextField(unicode:String){
        if (currentTextField != nil){
            let currentCharacterCount = (currentTextField?.text)!.characters.count ?? 0
            if (currentCharacterCount < kMaxLength){
                currentTextField?.text = (currentTextField?.text)!+unicode
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

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

    @IBAction func clearText(sender: UIButton) {
        txtPassword.text = ""
        txtPasswordConfirm.text = ""
        password1 = ""
        password2 = ""
        
    }
    
    @IBAction func backSpace(sender: UIButton) {
        let currentCharacterCount = (currentTextField?.text)!.characters.count ?? 0
        //currentTextField!.text = currentTextField!.text?.substringToIndex(Index)
    
    }
    
    @IBAction func sendComboCommand(sender: UIButton) {
         //@todo: send the combo to target
        self.performSegueWithIdentifier("segueRstCmbToSetName", sender: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
