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
    
    
    // reference to firebase database
    let rootRef = Database.database().reference()
    
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
        let routeRef = rootRef.child("route")
        routeRef.observe(.value) { (snap: DataSnapshot) in
            self.conditionLabel.text = (snap.value as AnyObject).description
        }
    }
    
    @IBAction func southDidTouch(_ sender: UIButton) {
    }
    
    @IBAction func northDidTouch(_ sender: UIButton) {
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

