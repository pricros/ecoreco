//
//  SafetyViewController.swift
//  ecoreco
//

import UIKit

class SafetyViewController: CommonViewController {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
    
    
}

