//
//  ViewController.swift
//  Caffeine
//
//  Created by Emad A. on 22/04/2016.
//  Copyright © 2016 Code is joy!. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet var searchButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton?.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateCafesList() {
        print("Update Cafés ...")
    }
}

