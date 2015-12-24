//
//  ViewController.swift
//  map
//
//  Created by TSAO EVA on 2015/12/21.
//  Copyright © 2015年 TSAO EVA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet{
            mapView.mapType = .Standard
            mapView.delegate = self
        }
        
    }
    
    
    @IBOutlet weak var imgDashBoard: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        
        //configureToolBar()
        
        
        //add tpa action to imageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("tappedImage"))
        imgDashBoard.userInteractionEnabled = true
        imgDashBoard.addGestureRecognizer(tapGestureRecognizer)
    }

    func tappedImage(){
        print("back to dash-board")
    }
    

    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude:location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span:MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error:NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    
    
//    @IBOutlet weak var toolBar: UIToolbar!
//    func configureToolBar(){
//        self.toolBar.barStyle = .BlackTranslucent
//        self.toolBar.translucent = true
//        self.toolBar.tintColor = UIColor.blueColor()
//    }
//    
//    @IBOutlet weak var buttonBattery: UIBarButtonItem! {
//        didSet{
//            buttonBattery.title = "Battery"
//            buttonBattery.target = self
//            buttonBattery.action = nil
//        }
//    }
//    
//    @IBOutlet weak var buttonRangeEst: UIBarButtonItem! {
//        didSet{
//            buttonRangeEst.title = "RangeEst."
//            buttonRangeEst.target = self
//            buttonRangeEst.action = nil
//        }
//    }
//
//    @IBOutlet weak var buttonTrip: UIBarButtonItem! {
//        didSet{
//            buttonTrip.title = "Trip"
//            buttonTrip.target = self
//            buttonTrip.action = nil
//        }
//    }
//    
//    @IBOutlet weak var buttonSpeed: UIBarButtonItem! {
//        didSet{
//            buttonSpeed.image = UIImage(contentsOfFile:"img_mapBottomRightBg")
//            buttonSpeed.target = self
//            buttonSpeed.action = nil
//        }
//    }
//
//    
 
    
    
    
}

