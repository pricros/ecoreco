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



class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class MapViewController: CommonViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet{
            self.mapView.mapType = .standard
            self.mapView.delegate = self
            self.mapView.showsUserLocation = false //to hide the blue dot
        }
    }
    
    @IBOutlet weak var imgViewDashBoard: UIImageView!
    
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set view bgcolor
        self.view.backgroundColor = UIColor(
            red: 0.33,
            green: 0.33,
            blue: 0.33,
            alpha: 0.4)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //show location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        //add tpa action to imageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapViewController.tappedImage))
        imgViewDashBoard.isUserInteractionEnabled = true
        imgViewDashBoard.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("remove mapVIew")
        self.mapView.showsUserLocation = false
        self.mapView.delegate = nil
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.mapView.removeFromSuperview()
    }
    
    
    
    
    func tappedImage(){
        print("back to dashboard")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error:Error) {
        print("Errors: " + error.localizedDescription)
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude:location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span:MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        self.mapView.setRegion(region, animated: true)
        
        
        // Add an annotation on Map View (pin)
        let currPoint = CustomPointAnnotation()
        currPoint.coordinate = location!.coordinate
        currPoint.imageName = "mapPoint.png"
        currPoint.title = "Your current location"
        currPoint.subtitle = "go live your adventure!"
        self.mapView.addAnnotation(currPoint)
        
        //stop updating location to save battery life
        //locationManager.stopUpdatingLocation()
        
    }
    
    
    
    func mapView(_ mapView: MKMapView!, viewFor annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    
}

