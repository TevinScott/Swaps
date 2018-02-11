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
class PickupVC : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    // MARK: - Attributes
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toggleFollowBtn: UIButton!
    var locationManager = CLLocationManager()
    var algoliaHandle = AlgoliaSearchManager()
    var saleItem : SaleItem!
    var userLocCoord: CLLocationCoordinate2D!
    var meetupLocCoord : CLLocationCoordinate2D!

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
        if(self.meetupLocCoord != nil && saleItem != nil){
            //saleItem.requestedPickupDate = floor(datePicker.date.timeIntervalSince1970)
            saleItem.meetup = (longitude: meetupLocCoord.longitude, latitude: meetupLocCoord.latitude)
            algoliaHandle.addMeetupRequestInfo(toIndex: saleItem, by:"Buyer")
        }
        
        
    }
    
    /**
     adds a pin to the location the user last tapped on inside this class's mapView
    */
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        meetupLocCoord = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = meetupLocCoord
        annotation.title = "Meet Up Location"
        annotation.subtitle = "Initial Request"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        drawRoute()
    }
    
    /**
     Pans the current mapView to this user's GPS location
    */
    private func panToCurrentLocation(){
        let center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        userLocCoord = center
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
    
    /**
     Draws the route from the user location to the placed pin annotation on the map view.
     */
    func drawRoute(){
        let userLocationPlacemark = MKPlacemark(coordinate: userLocCoord, addressDictionary: nil)
        let meetupLocationPlacemark = MKPlacemark(coordinate: meetupLocCoord, addressDictionary: nil)
        let userLocationMapItem = MKMapItem(placemark: userLocationPlacemark)
        let meetupLocationMapItem = MKMapItem(placemark: meetupLocationPlacemark)
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = userLocationMapItem
        directionRequest.destination = meetupLocationMapItem
        directionRequest.transportType = .automobile
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        // 8.
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            print("drawing route: ", response.routes[0].distance)
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    
    //required function for MKMapViewDelegate
    internal func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red:66/255,green: 134/255,blue: 244/255, alpha:1.0)
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
