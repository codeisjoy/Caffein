//
//  ViewController.swift
//  Caffeine
//
//  Created by Emad A. on 22/04/2016.
//  Copyright © 2016 Code is joy!. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class ViewController: UIViewController {
    
    // MARK: IBoutlets
    
    @IBOutlet var mapView: MKMapView?
    @IBOutlet var searchButton: UIButton?
    
    // MARK: Private Variables
    private let locationManager = CLLocationManager()
    private var locationAccessGranted = false {
        didSet { searchButton?.hidden = !locationAccessGranted }
    }
    
    private let service = Service()
    private var venues: [Venue]?
    
    // MARK: Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        // Request permission to use location service
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        // Permission to use location service is already granted
        else {
            locationAccessGranted = true
            mapView?.showsUserLocation = true
            mapView?.setUserTrackingMode(.Follow, animated: true)
        }
        
        searchButton?.layer.cornerRadius = 3
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Continue sollowing user location if required access granted
        if locationAccessGranted {
            mapView?.setUserTrackingMode(.Follow, animated: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop following user location
        mapView?.setUserTrackingMode(.None, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.setUserTrackingMode(.None, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show detail" {
            let cafesViewController = (segue.destinationViewController as? UINavigationController).flatMap { nav in
                nav.viewControllers.first as? CafesViewController
            }
            cafesViewController?.venues = venues
        }
    }
    
    // MARK: Action Methods
    
    @IBAction func updateCafesList() {
        // Can not send a request if user location is not determined
        guard let coordinate = mapView?.userLocation.coordinate else {
            print("Can't determine your location to update cofes list.")
            return
        }
        
        service.exploreVenues(coordinate, section: "cafe") { [unowned self] venues, error in
            guard error == nil else {
                print(error)
                return
            }
            
            // Go to main thread and show given data
            dispatch_async(dispatch_get_main_queue()) {
                self.venues = venues?.sort { $0.location.distance < $1.location.distance }
                self.performSegueWithIdentifier("show detail", sender: self)
            }
        }
    }
    
}

// MARK: CLLocationManagerDelegate Extension

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        locationAccessGranted = (status == .AuthorizedAlways || status == .AuthorizedWhenInUse)
        
        // Set map view properties to show user location and follow it depend on authorization status
        mapView?.showsUserLocation = locationAccessGranted
        mapView?.setUserTrackingMode(locationAccessGranted ? .Follow : .None, animated: true)
    }
    
}

// MARK: MKMapViewDelegate Extension

extension ViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        // Show an error alert
        let msg = error.code == 0 ? "Can't determine your location." : error.localizedDescription
        let alertController = UIAlertController(title: "Error Occured", message: msg, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

