//
//  CafeTableViewCell.swift
//  Caffeine
//
//  Created by Emad A. on 22/04/2016.
//  Copyright © 2016 Code is joy!. All rights reserved.
//

import UIKit

class CafeTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLable: UILabel?
    @IBOutlet var addressLable: UILabel?
    @IBOutlet var distanceLabel: UILabel?
    @IBOutlet var ratingLabel: UILabel?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressLable?.text = "Unknown address"
        distanceLabel?.text = "No provided distance"
        
        ratingLabel?.hidden = true
        ratingLabel?.layer.cornerRadius = 4
    }
    
}
