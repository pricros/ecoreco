//
//  ShopViewController.swift
//  ecoreco
//

import UIKit

class ShopViewController: CommonViewController {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapGestureRecognizerImgBack = UITapGestureRecognizer(target: self, action:#selector(RideViewController.tappedBack))
        imgBack.userInteractionEnabled = true
        imgBack.addGestureRecognizer(tapGestureRecognizerImgBack)
        
        

        let url = NSURL (string: "https://ecorecoscooter.com/");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        webView.scalesPageToFit = true
        
        //webView.delegate = self
        //self.view.addSubview(webView)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources thatp can be recreated.
    }
    
    func tappedBack(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}

