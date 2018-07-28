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
    let southCoords = [30.274053, -97.752729, 0.04]
    let northCoords = [30.299027, -97.732822, 0.04]
    let westCoords = [30.278906, -97.758396, 0.04]
    let shoalCreekCoords = [30.303036, -97.742863, 0.04]
    
    // Picker that gives regions for the map to zoom into
    @IBOutlet weak var regionsField: UITextField!
    var regionsPicker = UIPickerView()
    var regions: [String: [Double]] = [:]
    var selectedRegion = "South"
    
    // Shows the regions dropdown when you click the arrow
    @IBAction func showRegions(_ sender: UIButton) {
        regionsField.becomeFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initializing the regions picker
        regions = ["South": southCoords,
                   "North": northCoords,
                   "West": westCoords,
                   "Shoal Creek": shoalCreekCoords]
        regionsPicker.delegate = self
        regionsField.inputView = regionsPicker
        
        initializeMap()
    }
    
    // Map zooms into South Route by default
    func initializeMap() {
        let coordsSelected = CLLocationCoordinate2DMake(southCoords[0], southCoords[1])
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: coordsSelected, span: span)
        map.setRegion(region, animated: true)
    }
    
    //MARK: - Data for Regions Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let keys = Array(regions.keys)
        return keys[row]
    }
    
    // Zooms the map into a new region when you select a new route
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key = Array(regions.keys)[row]
        regionsField.text = key
        selectedRegion = key
        let sourceCoordinates = CLLocationCoordinate2DMake(regions[key]![0], regions[key]![1])
        let span = MKCoordinateSpanMake(regions[key]![2], regions[key]![2])
        let region = MKCoordinateRegion(center: sourceCoordinates, span: span)
        map.setRegion(region, animated: true)
        self.view.endEditing(false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

