//
//  PickupVC.swift
//  Swaps
//
//  Created by Tevin Scott on 1/27/18.
//  Copyright © 2018 Tevin Scott. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//NEEDS: - Zoom out to fit both the meet up location pin & user location in mapView
//NEEDS: - route drawn from user location to meet up location in mapView
//NEEDS: - estimated travel time by vehicle & foot in mapView
//NEEDS: - Display a link to the buyer's profile/account

/// This Class Manages the Pickup View and its attributes and delegate behaviors
class PendingMeetupVC : UIViewController, CLLocationManagerDelegate{
    
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
        datePicker.date =  Date(timeIntervalSince1970: saleItem.jsonBuyerReqTime) 
        setupLocationManager()
        placeMeetupPin()
        panToMeetupLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        panToMeetupLocation()
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
            saleItem.requestedPickupDate = floor(datePicker.date.timeIntervalSince1970)
            saleItem.meetup = (longitude: locCoord.longitude, latitude: locCoord.latitude)
            algoliaHandle.addPickupRequestLocation(toIndex: saleItem)
            algoliaHandle.addBuyerRequestedPickupDate(toIndex: saleItem)
        }
    }
    
    /**
     adds a pin to the location the user last tapped on inside this class's mapView
     */
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        if(mapView.isScrollEnabled){
            print("add new location called")
            let location = sender.location(in: mapView)
            locCoord = mapView.convert(location, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locCoord
            annotation.title = "Meet Up Location"
            annotation.subtitle = "Initial Request"
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)
        }
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
    
    /**
     Enables user location functionality within this Views MapView
     */
    func setupLocationManager(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
    }
    
    /**
     places a red pin (annotation) at the Buyer's requested meetup location in the mapView
     */
    private func placeMeetupPin(){
        let meetupLoc = CLLocationCoordinate2D(latitude : saleItem.meetup.latitude,
                                               longitude: saleItem.meetup.longitude)
        let RequestedMeetupPin = MKPointAnnotation()
        RequestedMeetupPin.coordinate = meetupLoc
        RequestedMeetupPin.title = "Meet Up Location"
        RequestedMeetupPin.subtitle = "Request For Approval"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(RequestedMeetupPin)
    }
    
    /**
     Pans the current mapView to this user's GPS location
     */
    private func panToMeetupLocation(){
        let center = CLLocationCoordinate2D(latitude: saleItem.meetup.latitude, longitude: saleItem.meetup.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
}

