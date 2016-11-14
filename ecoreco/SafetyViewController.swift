//
//  SafetyViewController.swift
//  ecoreco
//

import UIKit

class SafetyViewController: CommonViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var txtEmergencyCall: UITextField!
    @IBOutlet weak var txtEmergencySMS: UITextField!
    
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
        
        //get setting view from db
        if ((userDefaults.value(forKey: Constants.kUserDefaultEmergencyCall)) != nil)
        {
            txtEmergencyCall.text = userDefaults.value(forKey: Constants.kUserDefaultEmergencyCall) as! String?
        }
        
        if ((userDefaults.value(forKey: Constants.kUserDefaultEmergencySMSNo)) != nil)
        {
            txtEmergencySMS.text = userDefaults.value(forKey: Constants.kUserDefaultEmergencySMSNo) as! String?
        }

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources thatp can be recreated.
    }
    
    func tappedBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
                userDefaults.setValue(textField.text, forKey: Constants.kUserDefaultEmergencySMSNo)
            }
            
        } else {
            
            
        }
        
        resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
        
    }
    
    func checkInputValue(inputText:String)->Bool{
        return true
    }
    
    
    
}

