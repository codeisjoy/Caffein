//
//  Venue.swift
//  Caffeine
//
//  Created by Emad A. on 22/04/2016.
//  Copyright © 2016 Code is joy!. All rights reserved.
//

import Foundation
import CoreLocation

struct Venue {
    
    let id: String
    let name: String
    let isOpen: Bool?
    let rating: Float?
    let ratingColor: String?
    let location: VenueLocation
    
    init?(_ item: [String: AnyObject]) {
        guard let
            venue = item["venue"] as? [String: AnyObject],
            id = venue["id"] as? String,
            name = venue["name"] as? String,
            location = venue["location"] as? [String: AnyObject]
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.location = VenueLocation(location)
        
        isOpen = venue["hours"].flatMap { $0["isOpen"] as? Bool }
        rating = venue["rating"] as? Float
        ratingColor = venue["ratingColor"] as? String
    }
    
}

struct VenueLocation {
    
    let address: String?
    let crossStreet: String?
    let city: String?
    let state: String?
    let country: String?
    let postalCode: String?
    
    let distance: Float?
    let coordinate: CLLocationCoordinate2D?
    
    init(_ location: [String: AnyObject]) {
        address = location["address"] as? String
        crossStreet = location["crossStreet"] as? String
        city = location["city"] as? String
        state = location["state"] as? String
        country = location["country"] as? String
        postalCode = location["postalCode"] as? String
        
        distance = location["distance"] as? Float
        if let lat = location["lat"] as? Double, lng = location["lng"] as? Double {
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        } else {
            coordinate = kCLLocationCoordinate2DInvalid
        }
    }
    
}