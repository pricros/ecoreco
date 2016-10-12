//
//  RideViewController.swift
//  ecoreco
//

import UIKit

class ScooterInfoViewController: CommonViewController {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapGestureRecognizerImgBack = UITapGestureRecognizer(target: self, action:#selector(RideViewController.tappedBack))
        imgBack.userInteractionEnabled = true
        imgBack.addGestureRecognizer(tapGestureRecognizerImgBack)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources thatp can be recreated.
    }
    
    func tappedBack(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}

