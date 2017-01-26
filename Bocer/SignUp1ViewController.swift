//
//  SignUp1ViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/16/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUp1ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, NSURLConnectionDataDelegate {

    private let mNavBar = Constant().makeNavBar()
    
    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pwTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    override func viewDidLoad() {
        super.viewDidLoad()

        //customize status bar
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //delegate and customize textfields
        emailTF.delegate = self
        emailTF.title = "Enter Your College Email Address"
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
        nextBtn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
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
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(SignUp1ViewController.onCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        mNavItem.title = "SIGN UP"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        return mNavItem
    }
    
    //return by swiping back
    private func addSwipeRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SignUp1ViewController.onCancel))
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
    
    //text field close
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        if textField == emailTF {
            pwTF.becomeFirstResponder()
        } else {
            nextPerformed()
        }
        return true
    }
    
    private func nextPerformed() {
        if checkValidation(email: emailTF.text, pw: pwTF.text) {
            var username = emailTF.text
            var password = pwTF.text
            Alamofire.request(
                URL(string: "http://localhost:3000/searchSchoolname")!,
                method: .post,
                parameters: ["domain":username!])
                .validate()
                .responseJSON {response in
                    var result = response.result.value
                    var json = JSON(result)
                    if(json["Target Action"] == "searchSchoolnameresult"){
                        if(json["content"] != "fail"){
                            var school = json["content"]
                            let sb = UIStoryboard(name: "new-Qian", bundle: nil);
                            let vc = sb.instantiateViewController(withIdentifier: "Signup2") as! SignUp2ViewController
                            vc.username = username!
                            vc.password = password!
                            vc.school = school.rawString()!
                            //self.push(vc, animated: true, completion: nil)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            print("fail")
                            let sb = UIStoryboard(name: "new-Qian", bundle: nil);
                            let vc = sb.instantiateViewController(withIdentifier: "Signup2") as! SignUp2ViewController
                            vc.username = username!
                            vc.password = password!
                            //self.push(vc, animated: true, completion: nil)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
        }
    }
    
    @IBAction func nextBtnFired(_ sender: UIButton) {
        if(emailTF.text == nil || emailTF.text == "" || pwTF.text == nil || pwTF.text == ""){
            let alertController = UIAlertController(title: "Woops!", message: "Both email and password can not be empty", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            nextPerformed()
        }
    }
    
    @IBAction func keyboardShouldResign(_ sender: UIView) {
        emailTF.resignFirstResponder()
        pwTF.resignFirstResponder()
    }
    
    /*
     TODO:
     isValidEmail
     input an email and check whether it is a valid college email or not
     */
    private func isValidEmail(s: String?) -> Bool {
        return true
    }
    
    /*
    TODO: 
    check for 2 parts:
    1. whether the email has been registered before
    2. whether the password is valid or not (for now the rule for a valid password is having 6 or more characters
    if one of the part is not satisfied, add an AlertView to tell user to change their email or password
    */
    private func checkValidation(email: String?, pw: String?) -> Bool {
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
