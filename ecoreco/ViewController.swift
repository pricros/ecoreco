//
//  ViewController.swift
//  ecoreco
//
//  Created by apple on 2015/12/20.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var partitionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let image1  = UIImage(named: "p1")
        let imageLock  = UIImage(named: "lock")
        let imageHeader  = UIImage(named: "header")
        partitionImage.image = image1
        lockImage.image = imageLock
        headerImage.image = imageHeader
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle
        print("digit=\(digit)")
        
    }

}

