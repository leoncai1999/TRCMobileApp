//
//  SecondViewController.swift
//  Texas Running
//
//  Created by Leon Cai on 7/24/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate, UIPickerViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var map: MKMapView!
    
    // Regions for the map to zoom into
    // Format: latitude, longitude, zoom
    let southCoords = [30.274053, -97.752729, 0.05]
    let northCoords = [30.299027, -97.732822, 0.05]
    let westCoords = [30.278906, -97.758396, 0.05]
    let shoalCreekCoords = [30.303036, -97.742863, 0.05]
    
    // The map will zoom into the region of the route you pick
    @IBOutlet weak var regionsField: UITextField!
    var regionsPicker = UIPickerView()
    var regions: [String] = ["South", "North", "West", "Shoal Creek"]
    var selectedRegion = "South"
    
    // Shows the regions dropdown when you click the arrow
    @IBAction func showRegions(_ sender: UIButton) {
        regionsField.becomeFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initializing the regions picker
        regionsPicker.delegate = self
        regionsField.inputView = regionsPicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

