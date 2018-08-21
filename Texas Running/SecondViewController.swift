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
    var polyline: MKPolyline = MKPolyline()
    @IBOutlet weak var fiveMiles: UIButton!
    @IBOutlet weak var threeMiles: UIButton!
    
    // 5 mile route is default
    var distanceSelected = "5"
    
    // Regions for the map to zoom into
    // Format: latitude, longitude, zoom
    let southCoords = [30.274053, -97.752729, 0.04]
    let northCoords = [30.299027, -97.732822, 0.04]
    let westCoords = [30.278906, -97.758396, 0.05]
    let shoalCreekCoords = [30.303036, -97.742863, 0.04]
    
    let gregGymCoords = [30.284033, -97.736999]
    
    // arrays of latitutdes and longitudes to plot out a polyline for each route
    let southLats = [30.284033, 30.280716, 30.276424, 30.274474, 30.272723, 30.259739, 30.260671, 30.261385, 30.262734, 30.263981, 30.263817, 30.264576, 30.266136, 30.265545, 30.264688, 30.264215, 30.264591, 30.263679, 30.262846, 30.272723, 30.274981, 30.276424, 30.280716, 30.284033]
    let southLongs = [-97.736999, -97.738102, -97.739654, -97.739253, -97.741045, -97.745705, -97.745343, -97.747755, -97.749660, -97.753002, -97.754880, -97.756371, -97.755268, -97.752593, -97.751614, -97.750262, -97.750047, -97.746971, -97.744799, -97.741045, -97.741372, -97.739654, -97.738102, -97.736999]
    
    let northLats = [30.284033, 30.292570, 30.293913, 30.295330, 30.308649, 30.307102, 30.307011, 30.304816, 30.302711, 30.299747, 30.295650, 30.291873, 30.291030, 30.290348, 30.288152, 30.287272, 30.283205, 30.282380, 30.279795, 30.279045, 30.280722, 30.282540, 30.284033]
    let northLongs = [-97.736999, -97.736556, -97.735189, -97.736873, -97.728334, -97.725131, -97.724283, -97.719659, -97.720965, -97.722392, -97.723377, -97.726605, -97.727141, -97.727223, -97.726579, -97.726729, -97.727930, -97.728595, -97.730730, -97.732050, -97.738219, -97.737499, -97.736999]
    
    let westLats = [30.284033, 30.284200, 30.287333, 30.288516, 30.289056, 30.289037, 30.289417, 30.290909, 30.292604, 30.293837, 30.296681, 30.290568, 30.286826, 30.285482, 30.283567, 30.282535, 30.280255, 30.279810, 30.276957, 30.280700, 30.282516, 30.284033]
    let westLongs = [-97.736999, -97.737333, -97.737036, -97.752731, -97.754545, -97.755554, -97.756166, -97.757378, -97.761026, -97.765241, -97.768215, -97.772021, -97.765758, -97.763030, -97.760328, -97.756604, -97.753349, -97.749622, -97.739500, -97.738156, -97.737504, -97.736999]
    
    let shoalLats = [30.284033, 30.284192, 30.287325, 30.288528, 30.288708, 30.288607, 30.291998, 30.292341, 30.292461, 30.292998, 30.295595, 30.296489, 30.297832, 30.298777, 30.298879, 30.299268, 30.300278, 30.300741, 30.301195, 30.301806, 30.303038, 30.304687, 30.305002, 30.305521, 30.305661, 30.306064, 30.306032, 30.306991, 30.306843, 30.300566]
    let shoalLongs = [-97.736999, -97.737329, -97.737012, -97.752598, -97.753818, -97.753557, -97.751247, -97.749627, -97.747932, -97.747632, -97.749110, -97.749557, -97.749733, -97.748896, -97.747533, -97.746975, -97.746396, -97.747297, -97.747544, -97.748939, -97.749636, -97.748499, -97.748666, -97.748236, -97.747820, -97.747724, -97.747268, -97.747424, -97.746794, -97.733590]
    
    // array of lat/long pairs used by polyline
    var coords: [CLLocationCoordinate2D] = []
    
    @IBAction func fiveMiles(_ sender: UIButton) {
        distanceSelected = "5"
        fiveMiles.backgroundColor = UIColor.green
        threeMiles.backgroundColor = UIColor.red
        plotRoute(region: selectedRegion)
    }
    
    @IBAction func threeMiles(_ sender: UIButton) {
        distanceSelected = "3"
        fiveMiles.backgroundColor = UIColor.red
        threeMiles.backgroundColor = UIColor.green
        plotRoute(region: selectedRegion)
    }
    
    
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
        
        // append all points in array that polyline will pass through
        map.remove(polyline)
        coords.removeAll()
        
        if (region == "South") {
            plotSouth()
        } else if (region == "North") {
            plotNorth()
        } else if (region == "West") {
            plotWest()
        } else if (region == "Shoal Creek") {
            plotShoal()
        }
        polyline = MKPolyline(coordinates: &coords, count: coords.count)
        map.add(polyline)
    }
    
    // plots south route
    func plotSouth() {
        if (distanceSelected == "5") {
            createPolyline(start: 0, stop: southLats.count - 1, latArray: southLats, longArray: southLongs)
        } else {
            createPolyline(start: 0, stop: 5, latArray: southLats, longArray: southLongs)
            // turn around after crossing congress bridge
            createPolyline(start: 19, stop: southLats.count - 1, latArray: southLats, longArray: southLongs)
        }
    }
    
    // plots north route
    func plotNorth() {
        if (distanceSelected == "5") {
            createPolyline(start: 0, stop: northLats.count - 1, latArray: northLats, longArray: northLongs)
        } else {
            createPolyline(start: 0, stop: 3, latArray: northLats, longArray: northLongs)
            // turn right at 38th street
            let point = CLLocationCoordinate2D(latitude: 30.300537, longitude: -97.733579)
            coords.append(point)
            createPolyline(start: 10, stop: northLats.count - 1, latArray: northLats, longArray: northLongs)
        }
    }
    
    // plots west route
    func plotWest() {
        if (distanceSelected == "5") {
            createPolyline(start: 0, stop: westLats.count - 1, latArray: westLats, longArray: westLongs)
        } else {
            createPolyline(start: 0, stop: 7, latArray: westLats, longArray: westLongs)
            // turn left at Hartford Rd
            let point = CLLocationCoordinate2D(latitude: 30.291620, longitude: -97.758862)
            coords.append(point)
            let point2 = CLLocationCoordinate2D(latitude: 30.288516, longitude: -97.759853)
            coords.append(point2)
            let point3 = CLLocationCoordinate2D(latitude: 30.287552, longitude: -97.759885)
            coords.append(point3)
            let point4 = CLLocationCoordinate2D(latitude: 30.284661, longitude: -97.761859)
            coords.append(point4)
            createPolyline(start: 14, stop: westLats.count - 1, latArray: westLats, longArray: westLongs)
        }
    }
    
    // plots shoal route
    func plotShoal() {
        if (distanceSelected == "5") {
            createPolyline(start: 0, stop: shoalLats.count - 1, latArray: shoalLats, longArray: shoalLongs)
            // shoal finishes the same way the north route starts
            for index in stride(from: 3, through: 0, by: -1) {
                let point = CLLocationCoordinate2D(latitude: northLats[index], longitude: northLongs[index])
                coords.append(point)
            }
        } else {
            createPolyline(start: 0, stop: 13, latArray: shoalLats, longArray: shoalLongs)
            // turn right at 29th
            let point = CLLocationCoordinate2D(latitude: 30.298021, longitude: -97.748206)
            coords.append(point)
            let point2 = CLLocationCoordinate2D(latitude: 30.295372, longitude: -97.742737)
            coords.append(point2)
            let point3 = CLLocationCoordinate2D(latitude: 30.292038, longitude: -97.741145)
            coords.append(point3)
            let point4 = CLLocationCoordinate2D(latitude: 30.287718, longitude: -97.741571)
            coords.append(point4)
            // finishes the same way it starts
            for index in stride(from: 2, through: 0, by: -1) {
                let point = CLLocationCoordinate2D(latitude: shoalLats[index], longitude: shoalLongs[index])
                coords.append(point)
            }
        }
    }
    
    // populating array of CLLocationCoords
    func createPolyline(start: Int, stop: Int, latArray: [Double], longArray: [Double]) {
        for index in start...stop {
            let point = CLLocationCoordinate2D(latitude: latArray[index], longitude: longArray[index])
            coords.append(point)
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

