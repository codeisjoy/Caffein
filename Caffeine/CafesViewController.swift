//
//  CafesViewController.swift
//  Caffeine
//
//  Created by Emad A. on 22/04/2016.
//  Copyright © 2016 Code is joy!. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class CafesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    
    var venues: [Venue]? {
        didSet { tableView?.reloadData() }
    }
    
}

extension CafesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let venue = venues?[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cafe") as! CafeTableViewCell
        
        cell.nameLable?.text = venue?.name
        if var address = venue?.location.address {
            if let cstreet = venue?.location.crossStreet {
                address += " (\(cstreet))"
            }
            cell.addressLable?.text = address
        }
        if let dist = venue?.location.distance {
            cell.distanceLabel?.text = "\(dist) m"
        }
        if let open = venue?.isOpen where open == false {
            var distance = cell.distanceLabel?.text
            distance = distance?.characters.count > 0 ? distance?.stringByAppendingString("・") : ""
            cell.distanceLabel?.text = distance?.stringByAppendingString("CLOSE")
        }
        
        if let rating = venue?.rating,
            ratingColor = venue?.ratingColor
        {
            cell.ratingLabel?.text = "\(rating)"
            cell.ratingLabel?.hidden = false
            
            cell.ratingLabel?.backgroundColor = UIColor(hex: ratingColor, alpha: 1)
        }
        else {
            cell.ratingLabel?.hidden = true
        }
        
        return cell
    }
    
}

extension CafesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let venue = venues?[indexPath.row]
        if let coordinate = venue?.location.coordinate {
            let actionSheetController = UIAlertController(title: "Open in Maps?", message: nil, preferredStyle: .Alert)
            let openInMapsAction = UIAlertAction(title: "Yes", style: .Default) { action in
                let address = [
                    CNPostalAddressCountryKey: venue?.location.country ?? "",
                    CNPostalAddressStateKey: venue?.location.state ?? "",
                    CNPostalAddressCityKey: venue?.location.city ?? "",
                    CNPostalAddressStreetKey: venue?.location.address ?? ""
                ]
                let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: address)
                let mapItem = MKMapItem(placemark: placeMark)
                mapItem.name = venue?.name
                mapItem.openInMapsWithLaunchOptions(nil)
            }
            actionSheetController.addAction(openInMapsAction)
            actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat) {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            self.init(white: 0.5, alpha: 1)
            return
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
}