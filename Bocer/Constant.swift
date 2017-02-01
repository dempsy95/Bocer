//
//  Constant.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/15/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import Foundation
import UIKit

class Constant {
    let buttonCornerRadius = 5 as Float
    let defaultColor = UIColor(red: 38/255, green: 38/255, blue: 59/255, alpha: 1)
    
    func makeNavBar() -> UINavigationBar {
        var navBar: UINavigationBar
        let screenMaxX = UIScreen.main.bounds.maxX
        navBar = UINavigationBar(frame: CGRect(x: 0,y: 0,width: screenMaxX,height: 64))
        navBar.isTranslucent = true
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.backgroundColor = defaultColor
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.white, forKey: NSForegroundColorAttributeName as NSCopying)
        navBar.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        return navBar
    }
    
    func customizeSFLTextField(tf: SkyFloatingLabelTextFieldWithIcon) {
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 27/255, green: 143/255, blue: 246/255, alpha: 1.0)
        tf.tintColor = overcastBlueColor
        tf.textColor = darkGreyColor
        tf.lineColor = lightGreyColor
        tf.selectedTitleColor = overcastBlueColor
        tf.selectedLineColor = overcastBlueColor
        tf.iconColor = UIColor.lightGray
        tf.selectedIconColor = overcastBlueColor
        tf.iconMarginBottom = 11
        tf.iconMarginLeft = 2.0
    }
    
    func transitionFromRight() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        return transition
    }
    
    func transitionFromLeft() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        return transition
    }
    
    func transitionFromBottom() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        return transition
    }
    
}
