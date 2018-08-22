//
//  TwitterViewController.swift
//  Texas Running
//
//  Created by Leon Cai on 8/21/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import UIKit
import TwitterKit

class TwitterViewController: TWTRTimelineViewController, TWTRTweetViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        // Curated list of running twitter accounts adjusted via the list functionality of my personal twitter account
        self.dataSource = TWTRListTimelineDataSource(listSlug: "RunningAccounts", listOwnerScreenName: "leoncai1999", apiClient: TWTRAPIClient())
        self.showTweetActions = true
    }
    
}
