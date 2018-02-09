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
import SwiftyButton
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
    @IBOutlet weak var acceptBtn: PressableButton!
    @IBOutlet weak var changeMeetupBtn: PressableButton!
    private var locationManager = CLLocationManager()
    private var algoliaHandle = AlgoliaSearchManager()
    private var locCoord : CLLocationCoordinate2D!
    private var changeMeetupEnabled = false;
    public var saleItem : SaleItem!
    
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
     This button cancels the meetup request with the potential buyer and returns to the user's listings view
    */
    @IBAction func cancelBtnPressed(_ sender: Any) {
        algoliaHandle.clearMeetupRequest(atIndex: self.saleItem)
        _ = navigationController?.popViewController(animated: true)
    }
    
    /**
     confirms the user accepts the specified time and place displayed in the mapView and datepicker
    */
    @IBAction func confirmBtnPressed(_ sender: Any) {
        if(changeMeetupEnabled != true){
            algoliaHandle.confirmMeetup(atIndex: saleItem)
            _ = navigationController?.popViewController(animated: true)
        } else if(changeMeetupEnabled){
            
            print("currently no action for this button while performing a counter request")
        }
    }
    
    /**
     toggles the ability to interact with the mapview and date picker to later send a counter meet up request to the buyer.
    */
    @IBAction func changeBtnPressed(_ sender: Any) {
        toggleChangeMeetup()
    }
    
    /**
     adds a pin to the location the user last tapped on inside this class's mapView
     */
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        if(changeMeetupEnabled){
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
     checks this sale item's requested meetup time and determine's if it is after the current time.
     
     - returns: a boolean answer to if the sale item is after the current date & time when this function is called.
    */
    private func isInDate() -> Bool {
        var answer = false
        if(saleItem.requestedPickupDate >= NSDate().timeIntervalSince1970){
            answer = true
        }
        return answer
    }
    
    /**
     shows a dialogbox prompting the user that they are about to replaces there currently set image. They have the choice to cancel the action or proceed.
     
     - Returns
     answer: a string stating the answer either a camera, library, or none
     */
    func showMeetupOutOfDateDialogAlert(){
        let alertController = UIAlertController(title: "Out Of Date Meet up",
                                                message: "The Meet up Date that was chosen has passed. Your item status will return to \"Listed\"",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    /**
     
     *FUNCTION IN PROGRESS*
    private func sendNewMeetupRequest(){
        if(mapView.annotations.count > 1 && changeMeetupEnabled){
            saleItem.meetup = (longitude: locCoord.longitude, latitude: locCoord.latitude)
            algoliaHandle.addPickupRequestLocation(toIndex: saleItem)
        }
    }
    */
    
    
    /**
     toggles the iteractability of the map View & date picker and changes the UI buttons accordingly
    */
    private func toggleChangeMeetup() {
        if(changeMeetupEnabled != true){
            changeMeetupEnabled = true
            mapView.isZoomEnabled = true
            mapView.isRotateEnabled = true
            mapView.isScrollEnabled = true
            datePicker.isUserInteractionEnabled = true
            acceptBtn.setTitle("Send Request", for: .normal)
            changeMeetupBtn.setTitle("Cancel Changes", for: .normal)
            mapView.removeAnnotations(mapView.annotations)
        }
        else if(changeMeetupEnabled){
            changeMeetupEnabled = false
            mapView.isZoomEnabled = false
            mapView.isRotateEnabled = false
            mapView.isScrollEnabled = false
            datePicker.isUserInteractionEnabled = false
            acceptBtn.setTitle("Accept", for: .normal)
            changeMeetupBtn.setTitle("Change Meet up", for: .normal)
            setSubviewsToSaleItemVariables()
        }
    }
    
    /**
     sets the mapview to display the pin for the requested meet up location in this view's sale item attribute. also sets the date picker to the corresponding sale item attribute's requested meet up date & time.
     */
    private func setSubviewsToSaleItemVariables(){
        datePicker.date =  Date(timeIntervalSince1970: saleItem.requestedPickupDate)
        setupLocationManager()
        placeMeetupPin()
        panToMeetupLocation()
    }
    
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
    private func setupLocationManager(){
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
        let meetupLoc = CLLocationCoordinate2D(latitude : saleItem.meetup.latitude!,
                                               longitude: saleItem.meetup.longitude!)
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
        let center = CLLocationCoordinate2D(latitude: saleItem.meetup.latitude!, longitude: saleItem.meetup.longitude!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.layer.cornerRadius = 4.0;
        setSubviewsToSaleItemVariables()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        panToMeetupLocation()
        if( !isInDate() ) {
            self.algoliaHandle.clearMeetupRequest(atIndex: self.saleItem)
            showMeetupOutOfDateDialogAlert()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

