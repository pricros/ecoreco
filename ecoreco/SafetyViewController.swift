//
//  RideViewController.swift
//  ecoreco
//

import UIKit

class SafetyViewController: CommonViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var txtEmergencyCall: UITextField!
    @IBOutlet weak var txtEmergencySMS: UITextField!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtEmergencyCall.delegate = self
        txtEmergencyCall.keyboardType = .numberPad
        
        
        txtEmergencySMS.delegate = self
        txtEmergencySMS.keyboardType = .numberPad
        
        let tapGestureRecognizerImgBack = UITapGestureRecognizer(target: self, action:#selector(RideViewController.tappedBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapGestureRecognizerImgBack)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources thatp can be recreated.
    }
    
    func tappedBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let checkValue = checkInputValue(inputText: textField.text!)
        
        if (checkValue) == true {
            if (textField)==txtEmergencyCall
            {
            //@save data to user default
                userDefaults.setValue(textField.text, forKey: Constants.kUserDefaultEmergencyCall)
            }
            else if (textField)==txtEmergencySMS
            {
                userDefaults.setValue(textField.text, forKey: Constants.kUserDefaultEmergencySMS)
            }
            
        } else {
            
            
        }
        
        resignFirstResponder()
        
        
        
        return true
        
    }
    
    func checkInputValue(inputText:String)->Bool{
        return true
    }
    
    
    
}

