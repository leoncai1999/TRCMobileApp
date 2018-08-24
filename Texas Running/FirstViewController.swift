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
    
    @IBOutlet weak var southButton: checkBox!
    @IBOutlet weak var northButton: checkBox!
    @IBOutlet weak var westButton: checkBox!
    @IBOutlet weak var shoalButton: checkBox!
    
    var routeSelected = "None"
    // indexes: 0 South, 1 North, 2 West, 3 Shoal
    var routePollCounts = ["South" : "0", "North" : "0", "West" : "0", "Shoal" : "0"]
    let routes = ["South", "North", "West", "Shoal"]
    
    // references to firebase database
    
    // current winner
    let routeRef = Database.database().reference().child("route")
    
    // counts for each route
    let southRef = Database.database().reference().child("South")
    let northRef = Database.database().reference().child("North")
    let westRef = Database.database().reference().child("West")
    let shoalRef = Database.database().reference().child("Shoal")
    
    var closeTime = "6:00 PM"
    var closeHour = 18 // 6 PM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // rounds the edges of the button
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        
        emailButton.layer.cornerRadius = 5
        emailButton.clipsToBounds = true
        
        //closePoll()
        
        // check for daylight savings
        let date = Date()
        let timeZone = TimeZone.current
        if !timeZone.isDaylightSavingTime(for: date) {
            closeTime = "5:00 PM"
            closeHour = 17
        }
        adjustTimeText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print ("is this getting called")
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
        closePoll()
    }
    
    func closePoll() {
        let hour = Calendar.current.component(.hour, from: Date())
        // account for DST
        let dayOfWeek = getDayOfWeek()
        print ("currenthour")
        print (hour)
        if (((dayOfWeek == 2) || (dayOfWeek == 3) || (dayOfWeek == 4) || (dayOfWeek == 5)) && (hour == 20)) {
            
            routeRef.observe(.value) { (snap: DataSnapshot) in
                let routeChoice : String = (snap.value as? String)!
                self.timeText.text = "The Poll has closed. The route selected is " + routeChoice
                // check box of selected route and disable boxes from being checked and unchecked
                
                if (routeChoice == "South") {
                    self.southButton.isChecked = true
                } else if (routeChoice == "North") {
                    self.northButton.isChecked = true
                } else if (routeChoice == "West") {
                    self.westButton.isChecked = true
                } else {
                    self.shoalButton.isChecked = true
                }
                self.southButton.isUserInteractionEnabled = false
                self.northButton.isUserInteractionEnabled = false
                self.westButton.isUserInteractionEnabled = false
                self.shoalButton.isUserInteractionEnabled = false
            }
            // clear the poll
            for route in routes {
                routePollCounts[route] = "0"
            }
            print ("when is this getting called")
            southRef.setValue("0")
            northRef.setValue("0")
            westRef.setValue("0")
            shoalRef.setValue("0")
            // users are unable to vote between 6-7PM M-TH or 5-6PM during DST
            submitButton.isHidden = true
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
            //routeRef.setValue(routeSelected)
            adjustCount(choice: routeSelected)
            determineWinner()
            routeSelected = "None"
        }
    }
    
    func adjustCount(choice: String) {
        // increment routes count in database and deselct its box
        let oldCount = Int(routePollCounts[choice]!)
        let newCount = oldCount! + 1
        routePollCounts[choice] = String(newCount)
        if (choice == "South") {
            southRef.setValue(String(newCount))
            southButton.isChecked = false
        } else if (choice == "North") {
            northRef.setValue(String(newCount))
            print (routePollCounts["North"])
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
        // in a tie, the route with the lower index wins
        var winner = "South"
        var highestCount = 0
        for route in routes {
            let currentCount = Int(routePollCounts[route]!)
            /*print ("route")
            print (route)
            print ("currentCount")
            print (currentCount)
            print ("highestCount")
            print (highestCount)*/
            if currentCount! > highestCount {
                highestCount = currentCount!
                winner = route
            }
        }
        print ("is this getting called")
        routeRef.setValue(winner)
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

