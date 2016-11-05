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
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapGestureRecognizerImgBack)
        
        

        let url = URL (string: "https://ecorecoscooter.com/");
        let requestObj = URLRequest(url: url!);
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
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

