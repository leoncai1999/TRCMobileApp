//
//  FirstViewController.swift
//  Texas Running
//
//  Created by Leon Cai on 7/24/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FirstViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var southButton: checkBox!
    @IBOutlet weak var northButton: checkBox!
    @IBOutlet weak var westButton: checkBox!
    @IBOutlet weak var shoalButton: checkBox!
    
    var routeSelected = "None"
    // indexes: 0 South, 1 North, 2 West, 3 Shoal 
    var routePollCounts = ["South" : "0", "North" : "0", "West" : "0", "Shoal" : "0"]
    
    // references to firebase database
    
    // current winner
    let routeRef = Database.database().reference().child("route")
    
    // counts for each route
    let southRef = Database.database().reference().child("South")
    let northRef = Database.database().reference().child("North")
    let westRef = Database.database().reference().child("West")
    let shoalRef = Database.database().reference().child("Shoal")
    
    var closeTime = "6:00 PM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // rounds the edges of the button
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        
        emailButton.layer.cornerRadius = 5
        emailButton.clipsToBounds = true
        
        // check for daylight savings
        let date = Date()
        let timeZone = TimeZone.current
        if !timeZone.isDaylightSavingTime(for: date) {
            closeTime = "5:15 PM"
        }
        adjustTimeText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routeRef.observe(.value) { (snap: DataSnapshot) in
            self.conditionLabel.text = (snap.value as AnyObject).description
        }
        // linking dictionary to database
        southRef.observe(.value) { (snap: DataSnapshot) in
            self.routePollCounts["South"] = (snap.value as AnyObject).description
        }
        northRef.observe(.value) { (snap: DataSnapshot) in
            self.routePollCounts["North"] = (snap.value as AnyObject).description
        }
        westRef.observe(.value) { (snap: DataSnapshot) in
            self.routePollCounts["West"] = (snap.value as AnyObject).description
        }
        shoalRef.observe(.value) { (snap: DataSnapshot) in
            self.routePollCounts["Shoal"] = (snap.value as AnyObject).description
        }
    }
    
    @IBAction func southDidTouch(_ sender: UIButton) {
        if (!southButton.isChecked) {
            routeSelected = "South"
        } else {
            routeSelected = "None"
        }
        // deselect all other buttons when one is checked
        northButton.isChecked = false
        westButton.isChecked = false
        shoalButton.isChecked = false
    }
    
    @IBAction func northDidTouch(_ sender: UIButton) {
        if (!northButton.isChecked) {
            routeSelected = "North"
        } else {
            routeSelected = "None"
        }
        southButton.isChecked = false
        westButton.isChecked = false
        shoalButton.isChecked = false
    }
    
    @IBAction func westDidTouch(_ sender: UIButton) {
        if (!westButton.isChecked) {
            routeSelected = "West"
        } else {
            routeSelected = "None"
        }
        southButton.isChecked = false
        northButton.isChecked = false
        shoalButton.isChecked = false
    }
    
    @IBAction func shoalDidTouch(_ sender: UIButton) {
        if (!shoalButton.isChecked) {
            routeSelected = "Shoal"
        } else {
            routeSelected = "None"
        }
        southButton.isChecked = false
        northButton.isChecked = false
        westButton.isChecked = false
    }
    
    @IBAction func submitChoice(_ sender: UIButton) {
        if (routeSelected != "None") {
            routeRef.setValue(routeSelected)
            adjustCount(choice: routeSelected)
            determineWinner()
        }
    }
    
    func adjustCount(choice: String) {
        // increment routes count in database and deselct its box
        let oldCount = Int(routePollCounts[choice]!)
        let newCount = oldCount! + 1
        if (choice == "South") {
            southRef.setValue(String(newCount))
            southButton.isChecked = false
        } else if (choice == "North") {
            northRef.setValue(String(newCount))
            northButton.isChecked = false
        } else if (choice == "West") {
            westRef.setValue(String(newCount))
            westButton.isChecked = false
        } else {
            shoalRef.setValue(String(newCount))
            shoalButton.isChecked = false
        }
    }
    
    func determineWinner() {
        // sets routeRef to the route with the most votes
        
    }
    
    @IBAction func facebookRedirect(_ sender: UIButton) {
        UIApplication.tryURL(urls: [
            "fb://profile/TexasRunningClub", // Attempt to open in app first
            "http://www.facebook.com/TexasRunningClub" // Open in website otherwsie
            ])
    }
    
    @IBAction func instagramRedirect(_ sender: UIButton) {
        UIApplication.tryURL(urls: [
            "instagram://user?username=texasrunningclub", // Attempt to open in app first
            "https://www.instagram.com/texasrunningclub/" // Open in website otherwsie
            ])
    }
    

    func adjustTimeText() {
        let hour = Calendar.current.component(.hour, from: Date())
        // also need to account for DST here
        let dayOfWeek = getDayOfWeek()
        if (dayOfWeek == 6 || dayOfWeek == 7 || (dayOfWeek == 5 && hour >= 18)) {
            timeText.text = "Poll Closes Monday at " + closeTime
        } else if (hour >= 18 || dayOfWeek == 1) {
            timeText.text = "Poll Closes Tomorrow at " + closeTime
        } else {
            timeText.text = "Poll Closes Today at " + closeTime
        }
    }
    
    // 1 indicates Sunday, 2 indicates Monday and so forth
    func getDayOfWeek() -> Int {
        let today = Date()
        let gregorian = Calendar(identifier: .gregorian)
        let dateComponents = gregorian.dateComponents([.weekday], from: today)
        return dateComponents.weekday!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

