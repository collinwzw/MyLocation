//
//  ViewController.swift
//  Mylocation
//
//  Created by Ziwen Wang on 2019/3/20.
//  Copyright © 2019年 Ziwen Wang. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var coreLocationManger = CLLocationManager()
    var locationManager:LocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationinfo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        coreLocationManger.delegate = self
        
        locationManager = LocationManager.sharedInstance
        
        let anthorizationCode = CLLocationManager.authorizationStatus()
        
        if anthorizationCode == CLAuthorizationStatus.notDetermined && coreLocationManger.responds(to: "requestAlwaBundleization") || coreLocationManger.responds(to: "requestWhenInUseAuthorization"){
            if Bundle.main.object(forInfoDictionaryKey: "Privacy - Location Always Usage Description") != nil{
                coreLocationManger.requestAlwaysAuthorization()
            }else{
                //println("No description provided")
            }
        }else{
            getlocation()
        }
    }

    func getlocation(){
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) ->() in
            self.displayLocation(location: CLLocation(latitude:latitude,longitude: longitude))
        }
    }
    
    func displayLocation(location:CLLocation){
        mapView.setRegion(MKCoordinateRegion(center:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude),span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.notDetermined || status != CLAuthorizationStatus.denied || status != CLAuthorizationStatus.restricted{
            getlocation()
        }
    }
    @IBAction func updateLocation(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

