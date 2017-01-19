//
//  SignInViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/15/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {

    private let mNavBar = Constant().makeNavBar()
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var resetPw: UIButton!
    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var pwTF: SkyFloatingLabelTextFieldWithIcon!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize status bar
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //delegate and customize textfields
        emailTF.delegate = self
        emailTF.title = "Email Address"
        emailTF.iconFont = UIFont(name: "FontAwesome", size: 20)
        emailTF.iconText = "\u{f007}"
        emailTF.errorColor = .red
        Constant().customizeSFLTextField(tf: emailTF)
        pwTF.delegate = self
        pwTF.title = "Password"
        pwTF.iconFont = UIFont(name: "FontAwesome", size: 20)
        pwTF.iconText = "\u{f023}"
        Constant().customizeSFLTextField(tf: pwTF)
        
        //customize button
        signIn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
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
        let backBtn = UIBarButtonItem(title: "  Back", style: .plain,
                                      target: self, action: #selector(SignInViewController.onCancel))
        backBtn.tintColor = UIColor.white
        mNavItem.title = "SIGN IN"
        mNavItem.setLeftBarButton(backBtn, animated: true)
        return mNavItem
    }
    
    //return by swiping back
    private func addSwipeRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SignInViewController.onCancel))
        swipeRecognizer.direction = .right
        swipeRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if(textField == emailTF && (isValidEmail(s: text))) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        return true
    }
    
    @IBAction func viewClicked(_ sender: Any) {
        emailTF.resignFirstResponder()
        pwTF.resignFirstResponder()
    }
    //text field close
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        if textField == emailTF {
            pwTF.becomeFirstResponder()
        } else {
            signInPerformed()
        }
        return true
    }

    @IBAction func signInClicked(_ sender: UIButton) {
        signInPerformed()
    }
    
    @IBAction func resetPwClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "new-Qian", bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: "ResetPassword") as UIViewController
        //self.push(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    TODO:
    signInPerformed
    signInPerformed is called when SIGN IN button is clicked or the user finish inputing information and click return on the keyboard.
    It is used to call the sign in request to the back end
    */
    private func signInPerformed() {
        //for test
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Main") as UIViewController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
    TODO:
    isValidEmail
    input an email and check whether it is a valid college email or not
    */
    private func isValidEmail(s: String) -> Bool {
        return true
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
