//
//  UIApplication.swift
//  Texas Running
//
//  Created by Leon Cai on 8/19/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import Foundation
import UIKit

// will be used for buttons that redirect to Facebook, Instagram and Twitter Accounts
extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.openURL(URL(string: url)!)
                return
            }
        }
    }
}
