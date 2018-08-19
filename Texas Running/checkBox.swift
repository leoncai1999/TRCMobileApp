//
//  checkBox.swift
//  Texas Running
//
//  Created by Leon Cai on 8/19/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import Foundation
import UIKit

class checkBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checkedBox")! as UIImage
    let uncheckedImage = UIImage(named: "uncheckedBox")! as UIImage
    
    // Adjust image as box is checked/unchecked
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
