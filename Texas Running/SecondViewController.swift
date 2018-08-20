//
//  SecondViewController.swift
//  Texas Running
//
//  Created by Leon Cai on 7/24/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var map: MKMapView!
    
    // Regions for the map to zoom into
    // Format: latitude, longitude, zoom
    let southCoords = [30.274053, -97.752729, 0.04]
    let northCoords = [30.299027, -97.732822, 0.04]
    let westCoords = [30.278906, -97.758396, 0.04]
    let shoalCreekCoords = [30.303036, -97.742863, 0.04]
    
    let gregGymCoords = [30.284033, -97.736999]
    
    // coordinates to plot out the routes
    let southLats = [30.284033, 30.280716, 30.276424, 30.274474, 30.272723, 30.259739, 30.260671, 30.261385, 30.262734, 30.263981, 30.263817, 30.264576, 30.266136, 30.265545, 30.264688, 30.264215, 30.264591, 30.263679, 30.262846]
    let southLongs = [-97.736999, -97.738102, -97.739654, -97.739253, -97.741045, -97.745705, -97.745343, -97.747755, -97.749660, -97.753002, -97.754880, -97.756371, -97.755268, -97.752593, -97.751614, -97.750262, -97.750047, -97.746971, -97.744799]
    
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
        regionsPicker.dataSource = self
        regionsField.inputView = regionsPicker
        
        map.delegate = self
        initializeMap()
        
    }
    
    // Map zooms into South Route by default
    func initializeMap() {
        regionsField.text = selectedRegion
        let coordsSelected = CLLocationCoordinate2DMake(southCoords[0], southCoords[1])
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: coordsSelected, span: span)
        map.setRegion(region, animated: true)
        
        // plot point at Greg Gym where all routes start
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2DMake(Double(gregGymCoords[0]), Double(gregGymCoords[1]))
        annotation.coordinate = location
        annotation.title = "Gregory Gym"
        annotation.subtitle = "Starting point for all routes"
        map.addAnnotation(annotation)
        plotRoute(region: selectedRegion)
    }
    
    func plotRoute(region: String) {
        if (region == "South") {
            var coords: [CLLocationCoordinate2D] = []
            // appends all the points for the line to go through
            for index in 0...southLats.count-1 {
                let point = CLLocationCoordinate2D(latitude: southLats[index], longitude: southLongs[index])
                coords.append(point)
            }
            
            let polyline = MKPolyline(coordinates: &coords, count: coords.count)
            map.add(polyline)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3
        return renderer
    }
    
    // plots an individual point
    func plotPoint(lat: Double, long: Double) {
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2DMake(lat, long)
        annotation.coordinate = location
        map.addAnnotation(annotation)
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
        // plots the selected route
        plotRoute(region: selectedRegion)
        self.view.endEditing(false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

