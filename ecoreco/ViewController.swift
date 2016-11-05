//
//  ViewController.swift
//  ecoreco
//
//  Created by apple on 2015/12/20.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

class ViewController: CommonViewController {
    
    @IBOutlet weak var headerImage: UIImageView!

    @IBOutlet weak var imageDigit1: UIButton!
    @IBOutlet weak var imageDigit3: UIButton!
    @IBOutlet weak var imageDigit2: UIButton!
    @IBOutlet weak var imageDigit4: UIButton!
    @IBOutlet weak var imageDigit5: UIButton!
    @IBOutlet weak var imageDigit6: UIButton!
    @IBOutlet weak var imageDigit7: UIButton!
    @IBOutlet weak var imageDigit8: UIButton!
    @IBOutlet weak var imageDigit9: UIButton!
    @IBOutlet weak var imageDigit0: UIButton!
    @IBOutlet weak var imageClear: UIButton!
    
    var digitImages:[UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set view bgcolor
        self.view.backgroundColor = UIColor(
            red: 0.33,
            green: 0.33,
            blue: 0.33,
            alpha: 0.4)
        // Do any additional setup after loading the view, typically from a nib.

        var fileName:String
        self.digitImages = [self.imageDigit0,self.imageDigit1,self.imageDigit2,self.imageDigit3,self.imageDigit4,self.imageDigit5,self.imageDigit6,self.imageDigit7,self.imageDigit8,self.imageDigit9,self.imageClear]
        
        for index in 0...10 {
            if (index < 10)
            {
                fileName = "digit_\(index)"
            }
            else
            {
                fileName = "digit_clear"
            }
            
            let image_digit = UIImage(named: fileName)! as UIImage
            digitImages[index].setBackgroundImage(image_digit, for: UIControlState())
            digitImages[index].setTitle("", for: UIControlState())
        }

        scooter.alrStatus.didChange.addHandler(self, handler: ViewController.alarmStatusDidChange)
        
        if (scooter.getStatus() == .connected){
            let priority = DispatchQueue.GlobalQueuePriority.default
            DispatchQueue.global(priority: priority).async
            {

                while(self.scooter.getStatus() == .connected){
                    self.scooter.getAlarmStatus()
                    usleep(1000000)
                }

            DispatchQueue.main.async {
            }
            }

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func appendDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle
        print("digit=\(digit)")
        scooter.connect()
        scooter.unlock()
        
    }
    
    func alarmStatusDidChange(_ oldValue:Int, newValue:Int) {
        if (scooter.getStatus() == .connected){
            if (newValue == 1){
                let myAlert = UIAlertController(title: "Thief Detected!",
                                                message:"Watch your scooter!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Fine", style: .default,
                                             handler:{
                                                (action:UIAlertAction)->() in
                                                print("fine")
                                                self.dismiss(animated: true, completion: nil)
                })
                
                let cancelAction = UIAlertAction(title: "So So", style: .default,
                                             handler:{
                                                (action:UIAlertAction)->() in
                                                print("soso")
                                                self.dismiss(animated: true, completion: nil)
                })
                
                myAlert.addAction(okAction)
                myAlert.addAction(cancelAction)
                
                self.present(myAlert, animated: true, completion: nil)
            }
            else
            {
                
            }
        }
    }


}

