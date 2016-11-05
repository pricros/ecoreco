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
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        bShowPassword = false
        txtPassword.isSecureTextEntry = true
        txtPasswordConfirm.isSecureTextEntry = true
    }
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func addLeft(_ sender: UIButton) {
        let unicode:String = "\u{2190}"
        addTextToCurrentTextField(unicode)

    }
    
    var currentTextField: UITextField?
    
    @IBAction func addRight(_ sender: UIButton) {
        let unicode:String = "\u{2192}"
        addTextToCurrentTextField(unicode)
        
        print(currentTextField)
    }
    
    @IBAction func addDown(_ sender: UIButton) {
        let unicode:String = "\u{2193}"
        addTextToCurrentTextField(unicode)

        
    }
    
    func addTextToCurrentTextField(_ unicode:String){
        if (currentTextField != nil){
            let currentCharacterCount = (currentTextField?.text)!.characters.count ?? 0
            if (currentCharacterCount < kMaxLength){
                currentTextField?.text = (currentTextField?.text)!+unicode
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        textField.borderStyle = UITextBorderStyle.bezel
        currentTextField = textField
        // Additional code here
        return false
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        if ((bShowPassword) == true){ // not show
            sender.setImage(UIImage(named:"uncheck-rstCmb"), for: UIControlState())
            txtPassword.isSecureTextEntry = true
            txtPasswordConfirm.isSecureTextEntry = true
            bShowPassword = false
        } else { //  show
            sender.setImage(UIImage(named:"checked-rstCmb"), for: UIControlState())
            txtPassword.isSecureTextEntry = false
            txtPasswordConfirm.isSecureTextEntry = false
            bShowPassword = true
        }

    }

    @IBAction func clearText(_ sender: UIButton) {
        txtPassword.text = ""
        txtPasswordConfirm.text = ""
        password1 = ""
        password2 = ""
        
    }
    
    @IBAction func backSpace(_ sender: UIButton) {
        let currentCharacterCount = (currentTextField?.text)!.characters.count ?? 0
        //currentTextField!.text = currentTextField!.text?.substringToIndex(Index)
    
    }
    
    @IBAction func sendComboCommand(_ sender: UIButton) {
         //@todo: send the combo to target
        self.performSegue(withIdentifier: "segueRstCmbToSetName", sender: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
