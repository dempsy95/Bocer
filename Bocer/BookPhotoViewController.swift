//
//  BookPhotoViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/30/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

protocol  BookPhotoDelegate: NSObjectProtocol {
    func deletePhoto()
}


class BookPhotoViewController: UIViewController {

    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mNavItem: UINavigationItem!
    
    internal weak var delegate: BookPhotoDelegate?
    private let mNavBar = Constant().makeNavBar()
    internal var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        mImage.image = image
    }

    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(BookPhotoViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "delete")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(BookPhotoViewController.didFinish), for: .touchUpInside)
        rightBtn.tintColor = UIColor.white
        let rightBtnItem = UIBarButtonItem(customView: rightBtn)
        
        mNavItem.title = "PHOTO"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        mNavItem.setRightBarButton(rightBtnItem, animated: true)
        return mNavItem
    }
    
    @objc private func didCancel() {
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func didFinish() {
        let mAlert = UIAlertController(title: "Warning", message: "Do you want to DELETE this photo?", preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Yes", style: .destructive, handler: {
            (action: UIAlertAction!) in self.delete()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action: UIAlertAction!) in mAlert.dismiss(animated: true, completion: nil)
        })
        mAlert.addAction(actionDelete)
        mAlert.addAction(actionCancel)
        self.present(mAlert, animated: true, completion: nil)
    }
    
    private func delete() {
        if delegate != nil {
            delegate?.deletePhoto()
        }
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
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
