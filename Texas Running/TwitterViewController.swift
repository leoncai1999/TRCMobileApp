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
        self.dataSource = TWTRUserTimelineDataSource(screenName: "texasrunning", apiClient: client)
        self.showTweetActions = true
    }
    
}
