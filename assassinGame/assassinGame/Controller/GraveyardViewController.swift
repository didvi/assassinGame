//
//  GraveyardViewController.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/30/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GraveyardViewController: UIViewController, CLLocationManagerDelegate {
    let manager = CLLocationManager();
    
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0];
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span);
        
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true;
    }
   
    func addAnnotation(_ location:CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation();
        annotation.coordinate = location;
        annotation.title = "death";
        annotation.subtitle = "david was assassinated here"
        map.addAnnotation(annotation);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
