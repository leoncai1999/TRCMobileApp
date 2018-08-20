//
//  FirstViewController.swift
//  Texas Running
//
//  Created by Leon Cai on 7/24/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var timeText: UILabel!
    
    var closeTime = "6:00 PM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // rounds the edges of the button
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        
        // check for daylight savings
        let date = Date()
        let timeZone = TimeZone.current
        if !timeZone.isDaylightSavingTime(for: date) {
            closeTime = "5:15 PM"
        }
        adjustTimeText()
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
    
    @IBAction func twitterRedirect(_ sender: UIButton) {
        UIApplication.tryURL(urls: [
            "twitter://user?screen_name=texasrunning", // Attempt to open in app first
            "https://twitter.com/TexasRunning" // Open in website otherwsie
            ])
    }
    
    

    func adjustTimeText() {
        let hour = Calendar.current.component(.hour, from: Date())
        let dayOfWeek = getDayOfWeek()
        if (dayOfWeek == 6 || dayOfWeek == 7 || (dayOfWeek == 5 && hour > 18)) {
            timeText.text = "Poll Closes Monday at " + closeTime
        } else if (hour > 18 || dayOfWeek == 1) {
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

