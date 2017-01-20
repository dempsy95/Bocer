//
//  ProfileViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/19/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import SideMenu

class ProfileViewController: UIViewController, MenuViewControllerDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var collegeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    private var cancelAction: UIAlertAction?
    private let tablePage = UITableView()
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //customize button
        menuButton.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        bookButton.layer.shadowColor = UIColor.black.cgColor
        bookButton.layer.shadowRadius = 1
        bookButton.layer.shadowOffset = CGSize(width: 0, height: 0.8)
        bookButton.layer.shadowOpacity = 1
        bookButton.layer.cornerRadius = 22.5
        
        //customize button for edit info
        cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveInfo()
    }
    
    
    @IBAction func photoFired(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changePhotoAction = UIAlertAction(title: "Change Photo", style: .default, handler: changePhotoHandler)
        alertController.addAction(cancelAction!)
        alertController.addAction(changePhotoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func nameFired(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changePhotoAction = UIAlertAction(title: "Change Photo", style: .default, handler: changePhotoHandler)
        let changeNameAction = UIAlertAction(title: "Change Name", style: .default, handler: changeNameHandler)
        alertController.addAction(cancelAction!)
        alertController.addAction(changeNameAction)
        alertController.addAction(changePhotoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func emailFired(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changeEmailAction = UIAlertAction(title: "Change Email", style: .default, handler: changeEmailHandler)
        alertController.addAction(cancelAction!)
        alertController.addAction(changeEmailAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func collegeFired(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Warning",
                                                message: "You should change your college email address before change your college name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func addressFired(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changeAddressAction = UIAlertAction(title: "Change Address", style: .default, handler: changeAddressHandler)
        alertController.addAction(cancelAction!)
        alertController.addAction(changeAddressAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bookFired(_ sender: UIButton) {
    }
    @IBAction func menuFired(_ sender: UIButton) {
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
        vc.delegate = self
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.selectedItem = 1
        self.show(vc, sender: self)
    }
    
    //TODO:
    //Get users' info by using uid
    private func retrieveInfo() {
        //nameLabel.text = userInfo(uid).getFirstName + " " + userInfo(uid).getLastName
        //emailLabel.text = userInfo(uid).getEmail
        //collegeLabel.text = userInfo(uid).getCollege
        //addressLabel.text = userInfo(uid).getAddress
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //conform to protocol menuviewcontrollerdelegate
    func menu(_ menu: MenuViewController, didSelectItemAt index: Int, at point: CGPoint) {
        switch index {
        case 0:
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            showMain()
        default:
            break
        }
    }
    
    func menuDidCancel(_ menu: MenuViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
                             source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return menuAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
    
    //Action Handler for alert view
    private func cancelHandler(alert: UIAlertAction!) {
        self.presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    private func changePhotoHandler(alert: UIAlertAction!) {
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        //goto change photo vc
    }
    
    private func changeAddressHandler(alert: UIAlertAction!) {
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        //goto change address vc
    }
    
    private func changeNameHandler(alert: UIAlertAction!) {
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        //goto change name vc
    }
    
    private func changeEmailHandler(alert: UIAlertAction!) {
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        //goto change email vc
    }
    
    //go to the other vcs
    private func showMain() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Main")
        vc.modalTransitionStyle = .crossDissolve
        vc.view.layer.speed = 0.4
        self.present(vc, animated: true, completion: nil)
        
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
