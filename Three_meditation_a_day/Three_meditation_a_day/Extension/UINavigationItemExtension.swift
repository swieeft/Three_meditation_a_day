//
//  navigationItemExtension.swift
//  Three_meditation_a_day
//
//  Created by 박길남 on 10/10/2018.
//  Copyright © 2018 ParkGilNam. All rights reserved.
//

import Foundation

extension UINavigationItem {
 
    func addLeftItem(image:UIImage, target:Any, action:Selector) {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let barButton = UIBarButtonItem(customView: button)
        barButton.tintColor = UIColor.white
        
        self.leftBarButtonItem = barButton
    }
    
    func addRight(image:UIImage, target:Any, action:Selector) {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let barButton = UIBarButtonItem(customView: button)
        barButton.tintColor = UIColor.white
        
        self.rightBarButtonItem = barButton
    }
}
