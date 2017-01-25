//
//  SignUp2ViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/16/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var firstNameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var lastNameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var collegeTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var enterBtn: UIButton!
    
    private let mNavBar = Constant().makeNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        enterBtn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        //delegate & customize textfields
        firstNameTF.delegate = self
        firstNameTF.title = "First Name"
        firstNameTF.iconFont = UIFont(name: "FontAwesome", size: 20)
        firstNameTF.iconText = "\u{f0da}"
        lastNameTF.delegate = self
        lastNameTF.title = "Last Name"
        lastNameTF.iconFont = UIFont(name: "FontAwesome", size: 20)
        lastNameTF.iconText = "\u{f0da}"
        collegeTF.delegate = self
        collegeTF.title = "Enter Your College Name"
        collegeTF.iconFont = UIFont(name: "FontAwesome", size: 20)
        collegeTF.iconText = "\u{f0cd}"
        Constant().customizeSFLTextField(tf: firstNameTF)
        Constant().customizeSFLTextField(tf: lastNameTF)
        Constant().customizeSFLTextField(tf: collegeTF)
        collegeTF.iconMarginBottom = 9
        firstNameTF.iconMarginBottom = 10
        lastNameTF.iconMarginBottom = 10
        //customize status bar
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    //cancel button is fired, go back to initial view controller
    @objc private func onCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //text field close
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        if textField == firstNameTF {
            lastNameTF.becomeFirstResponder()
        } else if textField == lastNameTF {
            collegeTF.becomeFirstResponder()
        } else {
            enterPerformed()
        }
        return true
    }
    
    //customize navigation item
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(SignUp2ViewController.onCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        mNavItem.title = "SIGN UP"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        return mNavItem
    }
    
    //return by swiping back
    private func addSwipeRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SignUp2ViewController.onCancel))
        swipeRecognizer.direction = .right
        swipeRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    @IBAction func enterFired(_ sender: UIButton) {
        enterPerformed()
    }
    @IBAction func viewClicked(_ sender: UIView) {
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        collegeTF.resignFirstResponder()
    }
    
    /*
    TODO:
    add the new user to the server, log in
    */
    private func enterPerformed() {
        
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
