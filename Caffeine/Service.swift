//
//  Service.swift
//  Caffeine
//
//  Created by Emad A. on 22/04/2016.
//  Copyright © 2016 Code is joy!. All rights reserved.
//

import Foundation
import CoreLocation

enum APIEndpoint: String {
    case VenuesExplore = "venues/explore"
}

extension CLLocationCoordinate2D {
    var string: String {
        return "\(latitude),\(longitude)"
    }
}

struct Service {
    
    // MARK: API Constants
    
    private let baseURL = "https://api.foursquare.com/v2/"
    private let xClientId = "ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G"
    private let xClientSecret = "YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL"
    
    // Mark: Private Properties
    
    private let session: NSURLSession
    
    // MARK: Public Methods
    
    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration)
    }
    
    /// Starts sending a request to get venues close to given coordinate in given section
    func exploreVenues(coordinate: CLLocationCoordinate2D, section: String, complete: ([Venue]?, NSError?) -> () ) {
        guard let apiURL = urlForEndpoint(.VenuesExplore) else {
            complete(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil))
            return
        }
        
        // Create the API URL for exploring venues with given parameters
        let components = NSURLComponents(URL: apiURL, resolvingAgainstBaseURL: false)
        components?.queryItems?.append(NSURLQueryItem(name: "service", value: section))
        components?.queryItems?.append(NSURLQueryItem(name: "ll", value: coordinate.string))
        
        guard let url = components?.URL else {
            complete(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil))
            return
        }
        
        // Start sending the request to created API URL
        let task = session.dataTaskWithURL(url) { data, response, error in
            // Return error if there is any
            guard error == nil else {
                complete(nil, error)
                return
            }
            // Can not continue if there is no data returned
            guard let data = data else {
                complete(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil))
                return
            }
            
            let venues = self.parseVenusResponse(data)
            complete(venues, nil)
        }
        task.resume()
    }
    
    // MARK: Private Methods
    
    /// Returns the base url of any API request
    private func urlForEndpoint(endpoint: APIEndpoint) -> NSURL? {
        let url = NSURL(string: baseURL)?
            .URLByAppendingPathComponent(endpoint.rawValue)
        
        guard let apiURL = url else { return nil }
        
        // We need the current date in special format in url
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        
        // Create the API URL with parameters
        let components = NSURLComponents(URL: apiURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            NSURLQueryItem(name: "client_id", value: xClientId),
            NSURLQueryItem(name: "client_secret", value: xClientSecret),
            NSURLQueryItem(name: "v", value: dateFormatter.stringFromDate(NSDate())),
        ]
        
        return components?.URL
    }
    
    /// Parse the given data and retuens an array of venues or nil
    private func parseVenusResponse(data: NSData) -> [Venue]? {
        do {
            // Turn the response to a JSON
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            // Get the response code
            let responseCode: Int? = json["meta"].flatMap { m in
                return m["code"] as? Int
            }
            // Check to see if the code says the response is valid
            // Stop if it is not valid
            guard responseCode == 200 else {
                print("No valid response ...")
                return nil
            }
            
            // Parse the response and get the items inside
            let items = json["response"]
                .flatMap { $0["groups"] as? [[String: AnyObject]] }?
                .filter { $0["name"] as? String == "recommended" }.first
                .flatMap { $0["items"] as? [[String: AnyObject]] }
            
            // Convert fetched items to venue model and return
            if let items = items {
                return items.flatMap { Venue($0) }
            }
        }
        // If response is not a valid json ...
        catch { print(error) }
        
        return nil
    }
}
