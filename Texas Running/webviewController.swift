//
//  webviewController.swift
//  Texas Running
//
//  Created by Leon Cai on 8/21/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import UIKit
import WebKit

class webviewController: UIViewController, WKNavigationDelegate {
    
    // MARK: Properties
    @IBOutlet weak var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView()
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // url to join email list
        let myURLString = "https://utexas.us9.list-manage.com/subscribe?u=4dfcb979851fe33219d453d34&id=0794b21555"
        let url = NSURL(string: myURLString)
        let request = NSURLRequest(url: url! as URL)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
