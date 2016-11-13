//
//  LoginViewController.swift
//  ecoreco
//
//  Created by admin on 2016/10/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class LoginViewController: CommonViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtCaptcha: UITextField!
    
    override func viewDidLoad() {
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtCaptcha.delegate = self
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
