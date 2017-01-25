//
//  ResetPassword2ViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/16/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class ResetPassword2ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {

        private let mNavBar = Constant().makeNavBar()

    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var pw1TF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var pw2TF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var confirmBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //customize status bar
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //delegate and customize textfields
        pw1TF.delegate = self
        pw1TF.title = "new password, at least 6 characters"
        pw1TF.iconFont = UIFont(name: "FontAwesome", size: 20)
        pw1TF.iconText = "\u{f084}"
        Constant().customizeSFLTextField(tf: pw1TF)
        pw2TF.delegate = self
        pw2TF.title = "Reenter the password"
        pw2TF.iconFont = UIFont(name: "FontAwesome", size: 20)
        pw2TF.iconText = "\u{f084}"
        Constant().customizeSFLTextField(tf: pw2TF)
        
        //customize button
        confirmBtn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    //cancel button is fired, go back to initial view controller
    @objc private func onCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //customize navigation item
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(ResetPassword2ViewController.onCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        mNavItem.title = "RESET PASSWORD"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        return mNavItem
    }
    
    //return by swiping back
    private func addSwipeRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ResetPassword2ViewController.onCancel))
        swipeRecognizer.direction = .right
        swipeRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    //text field close
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        if textField == pw1TF {
            pw2TF.becomeFirstResponder()
        } else {
            confirmPerformed()
        }
        return true
    }
    
    @IBAction func confirmFired(_ sender: UIButton) {
        confirmPerformed()
    }
    @IBAction func viewClicked(_ sender: UIView) {
        pw1TF.resignFirstResponder()
        pw2TF.resignFirstResponder()
    }
    
    /*
    TODO:
    1. update the new password
    2. add a new alert view which shows that the password changed successfullly
    3. go back to the login view
    */
    private func confirmPerformed() {
        
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
