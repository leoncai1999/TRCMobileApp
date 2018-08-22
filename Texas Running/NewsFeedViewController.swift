//
//  NewsFeedViewController.swift
//  Texas Running
//
//  Created by Leon Cai on 8/19/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import UIKit

// custom cell class for an athlete's strava post
class stravaPost: UITableViewCell {
    @IBOutlet weak var runnerName: UILabel!
    @IBOutlet weak var runDescription: UILabel!
    @IBOutlet weak var distanceRan: UILabel!
    @IBOutlet weak var runningPace: UILabel!
    @IBOutlet weak var runningTime: UILabel!
    
}

class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    // from the club activies class
    var activities = [ClubActivityElement]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // dynamic row height for tableview
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchStravaPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchStravaPosts() {
        // obtaining a json file of recent member activies on Strava using Strava API
        let urlString = "https://www.strava.com/api/v3/clubs/111449/activities?access_token=" + keys.stravaKey
        
        if let url = URL(string: urlString) {
            do {
                let contents = try String(contentsOf: url)
                
                let data = contents.data(using: String.Encoding.utf8)
                
                activities = try JSONDecoder().decode([ClubActivityElement].self, from: data!)
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect a row once tapped
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stravaPost", for: indexPath) as? stravaPost
        cell?.runnerName.text = activities[indexPath.row].athlete.firstname + " " + activities[indexPath.row].athlete.lastname
        cell?.runDescription.text = activities[indexPath.row].name
        let distance = activities[indexPath.row].distance
        // converting distance from meters to miles
        let distanceInMi = distance/1609.34
        let distanceInMiStr = String(format: "%.02f", distanceInMi)
        cell?.distanceRan.text = distanceInMiStr + " mi"
        let time = activities[indexPath.row].movingTime
        cell?.runningTime.text = formatTime(time: time)
        cell?.runningPace.text = calculatePace(time: time, dist: distanceInMi)
        return cell!
    }
    
    // converts time to hour : min format
    func formatTime(time: Int) -> String {
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(hours) + "h " + String(minutes) + "m"
    }
    
    // converts moving time to minute per mile pace
    // seconds not being calculated correctly sometimes
    func calculatePace(time: Int, dist: Double) -> String {
        let minutes = (Double(time)/60.0)
        let pace = minutes/dist
        
        let minute = String(pace).components(separatedBy: ".")[0]
        let seconds = String(pace).components(separatedBy: ".")[1]
        let formattedSeconds = Int(seconds)! * 6
        let formattedSeconds2 = String(formattedSeconds).prefix(2)
        return minute + ":" + formattedSeconds2 + " /mi"
    }

}
