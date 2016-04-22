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
    
    private let baseURL = "https://api.foursquare.com/v2/"
    private let xClientId = "ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G"
    private let xClientSecret = "YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL"
    
    private let session: NSURLSession
    
    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration)
    }
    
    func exploreVenues(coordinate: CLLocationCoordinate2D, section: String, complete: ([Venue]?, NSError?) -> () ) {
        let initialURL = urlForEndpoint(.VenuesExplore)
        guard let apiURL = initialURL else { return }
        
        // Create the API URL for exploring venues with given parameters
        let components = NSURLComponents(URL: apiURL, resolvingAgainstBaseURL: false)
        components?.queryItems?.append(NSURLQueryItem(name: "service", value: section))
        components?.queryItems?.append(NSURLQueryItem(name: "ll", value: coordinate.string))
        
        guard let url = components?.URL else { return }
        
        let task = session.dataTaskWithURL(url) { data, response, error in
            guard error == nil else {
                complete(nil, error)
                return
            }
            
            guard let data = data else {
                //TODO: handle not having data
                return
            }
            
            let venues = self.parse(data)
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
            
            NSURLQueryItem(name: "limit", value: "1")
        ]
        
        return components?.URL
    }
    
    func parse(data: NSData) -> [Venue]? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let reqCode: Int? = json["meta"].flatMap { m in
                return m["code"] as? Int
            }
            if reqCode != 200 {
                //TODO: handle the error
                print("not valid response")
                return nil
            }
            
            let items = json["response"]
                .flatMap { $0["groups"] as? [[String: AnyObject]] }?
                .filter { $0["name"] as? String == "recommended" }.first
                .flatMap { $0["items"] as? [[String: AnyObject]] }
            
            if let items = items {
                return items.flatMap { Venue($0) }
            }
            else {
                print("no item!")
            }
            
        } catch {
            //TODO: handle not having the json
            print(error)
        }
        
        return nil
    }
}
