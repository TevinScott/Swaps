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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toggleFollowBtn: UIButton!
    var locationManager = CLLocationManager()
    var algoliaHandle = AlgoliaSearchManager()
    var saleItem : SaleItem!
    var locCoord : CLLocationCoordinate2D!
    
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
        panToCurrentLocation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        panToCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Button Actions

    /**
     This Button, when pressed will either cause the mapView to stay centered on the user's location or stop the fixed centering
    */
    @IBAction func followBtnPressed(_ sender: Any) {
        if(mapView.userTrackingMode.rawValue == 0){
            toggleFollowBtn.imageView?.image = UIImage(named: "currentLocationPanningEnabled")
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        } else if(mapView.userTrackingMode.rawValue == 1){
            toggleFollowBtn.imageView?.image = UIImage(named: "currentLocationPanningDisabled")
            mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
        }
    }
    
    /**
     this button currently sets the pick up location of the Sale Item in the algolia database
    */
    @IBAction func meetupBtnPressed(_ sender: Any) {
        //NEEDS: Dialog Box & Location needs to match the annotation/pin placed by user
        if(self.locCoord != nil && saleItem != nil){
            //saleItem.requestedPickupDate = floor(datePicker.date.timeIntervalSince1970)
            saleItem.meetup = (longitude: locCoord.longitude, latitude: locCoord.latitude)
            algoliaHandle.addPickupRequestLocation(toIndex: saleItem)
            algoliaHandle.addBuyerRequestedPickupDate(toIndex: saleItem)
        }
        
        
    }
    
    /**
     adds a pin to the location the user last tapped on inside this class's mapView
    */
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        locCoord = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        annotation.title = "Meet Up Location"
        annotation.subtitle = "Initial Request"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    /**
     Pans the current mapView to this user's GPS location
    */
    private func panToCurrentLocation(){
        let center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    // MARK: - Support Functions
    /**
     called once user allows location permissions. will move the map view to the user's current location should the move.
     */
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //should really only center once when the view is onpened, this locks the mapview to where the user is currently located
        if(mapView.userTrackingMode.rawValue == 0){
            if(!(toggleFollowBtn.imageView?.image?.isEqual(UIImage(named: "currentLocationPanningDisabled")))!) {
                toggleFollowBtn.imageView?.image = UIImage(named: "currentLocationPanningDisabled")
            }
        } else {
            if(!(toggleFollowBtn.imageView?.image?.isEqual(UIImage(named: "currentLocationPanningEnabled")))!) {
                toggleFollowBtn.imageView?.image = UIImage(named: "currentLocationPanningEnabled")
            }
        }
    }
    

}
