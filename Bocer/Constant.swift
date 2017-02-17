//
//  Constant.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/15/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import Foundation
import UIKit
import Darwin

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

public extension UIImage {
    
    /// Extension to fix orientation of an UIImage without EXIF
    func fixOrientation() -> UIImage {
        
        guard let cgImage = cgImage else { return self }
        
        if imageOrientation == .up { return self }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
            
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            
        case .up, .upMirrored:
            break
        }
        
        switch imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .up, .down, .left, .right:
            break
        }
        
        if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            
            ctx.concatenate(transform)
            
            switch imageOrientation {
                
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
                
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            
            if let finalImage = ctx.makeImage() {
                return (UIImage(cgImage: finalImage))
            }
        }
        
        // something failed -- return original
        return self
    }
}
