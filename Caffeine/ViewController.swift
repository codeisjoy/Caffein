//
//  ViewController.swift
//  Caffeine
//
//  Created by Emad A. on 22/04/2016.
//  Copyright © 2016 Code is joy!. All rights reserved.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    
    @IBOutlet var searchButton: UIButton?
    
    let service = Service()
    private var venues: [Venue]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton?.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show detail" {
            let cafesViewController = (segue.destinationViewController as? UINavigationController).flatMap { nav in
                nav.viewControllers.first as? CafesViewController
            }
            cafesViewController?.venues = venues
        }
    }
    
    @IBAction func updateCafesList() {
        service.exploreVenues(CLLocationCoordinate2D(latitude: 40.7,longitude: -74), section: "cafe") { [unowned self] venues, error in
            guard error == nil else {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.venues = venues?.sort { $0.location.distance < $1.location.distance }
                self.performSegueWithIdentifier("show detail", sender: self)
            }
        }
    }
}

