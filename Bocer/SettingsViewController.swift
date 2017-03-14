//
//  SettingsViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/16/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onMakeNavitem()
        
        logoutBtn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func onMakeNavitem(){
        let mImage = UIImage(named: "cancel")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(SettingsViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        navigationItem.title = "SETTINGS"
        navigationItem.leftBarButtonItem = btnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutFired(_ sender: UIButton) {
        //TODO:
        
        let mAlert = UIAlertController(title: "Warning", message: "Do you want to log out?", preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Yes", style: .destructive, handler: {
            (action: UIAlertAction!) in self.logout()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action: UIAlertAction!) in mAlert.dismiss(animated: true, completion: nil)
        })
        mAlert.addAction(actionDelete)
        mAlert.addAction(actionCancel)
        self.present(mAlert, animated: true, completion: nil)

    }
    
    private func logout() {
        //delete user info from database
        var vc = self.presentingViewController
        while ((vc?.presentingViewController) != nil) {
            vc = vc?.presentingViewController
        }
        DatabaseHelper().clearData()
        SocketIOManager.sharedInstance.closeConnection()
        vc?.dismiss(animated: true, completion: nil)
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

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}
