//
//  PickupVC.swift
//  Swaps
//
//  Created by Tevin Scott on 1/6/18.
//  Copyright © 2018 Tevin Scott. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// This Class Manages the Pickup View and its attributes and delegate behaviors
class PickupVC : UIViewController, CLLocationManagerDelegate{
    
    // MARK: - Attributes
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.layer.cornerRadius = 4.0;
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
    }
    
    /**
     called once user allows location permissions. will move the map view to the user's current location should the move.
    */
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //should really only center once when the view is onpened, this locks the mapview to where the user is currently located
        panToCurrentLocation()
    }
    
    /**
     Pans the current mapView to this user's GPS location
    */
    private func panToCurrentLocation(){
        let center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
  
}
