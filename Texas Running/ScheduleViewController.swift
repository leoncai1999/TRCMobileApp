//
//  ScheduleViewController.swift
//  Texas Running
//
//  Created by Leon Cai on 8/19/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var coreText: UILabel!
    @IBOutlet weak var runText0: UILabel!
    @IBOutlet weak var runText1: UILabel!
    @IBOutlet weak var runText2: UILabel!
    @IBOutlet weak var runText3: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let date = Date()
        
        let timeZone = TimeZone.current
        // adjust workout times if we're not in daylight savings time
        if !timeZone.isDaylightSavingTime(for: date) {
            coreText.text = "4:45 PM - Core Workout (at Clark Field)"
            runText0.text = "5:15 PM - Evening Run & Track Workout"
            runText1.text = "5:15 PM - Evening Run"
            runText2.text = "5:15 PM - Evening Run"
            runText3.text = "5:15 PM - Evening Run"
        }
    }
    
    // goes back to the poll screen when the x is tapped
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
