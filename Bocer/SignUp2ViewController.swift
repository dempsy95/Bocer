//
//  SignUp2ViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/16/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUp2ViewController: UIViewController, UITextFieldDelegate {
    //user information
    internal var username:String?
    internal var password:String?
    internal var school:String?
    internal var firstname:String?
    internal var lastname:String?
    
    //UI elements
    @IBOutlet weak var firstNameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var lastNameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var collegeTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var enterBtn: UIButton!
    
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
        onMakeNavitem()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //assign school name
        if(school != nil){
            collegeTF.text = school
            collegeTF.isEnabled = false
        }
        else{
            collegeTF.isEnabled = true
        }
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
    private func onMakeNavitem(){
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(SignUp2ViewController.onCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        navigationItem.title = "SIGN UP"
        navigationItem.leftBarButtonItem = btnItem
    }
    
    //return by swiping back
    private func addSwipeRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SignUp2ViewController.onCancel))
        swipeRecognizer.direction = .right
        swipeRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    @IBAction func enterFired(_ sender: UIButton) {
        if(firstNameTF.text == nil || firstNameTF.text == "" || lastNameTF.text == nil || lastNameTF.text == ""
            || collegeTF.text == nil || collegeTF.text == ""){
            let alertController = UIAlertController(title: "Woops!", message: "All the fields can not be empty", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.school = collegeTF.text
            self.firstname = firstNameTF.text
            self.lastname = lastNameTF.text
            enterPerformed()
        }
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
        Alamofire.request(
            URL(string: "http://localhost:3000/addUser")!,
            method: .post,
            parameters: ["username":self.username!,"password":self.password!,"school":self.school!,"firstName":self.firstname!,"lastName":self.lastname!])
            .validate()
            .responseJSON {response in
                let result = response.result.value
                var json = JSON(result)
                if(json["Target Action"] == "signupresult"){
                    if(json["content"] == "fail"){
                        let alertController = UIAlertController(title: "Woops!", message: "Server failed", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                        let okAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.default) {
                            (result : UIAlertAction) -> Void in
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)

                    }
                    else if(json["content"] == "exist"){
                        let alertController = UIAlertController(title: "Woops!", message: "Username already exists", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            (result : UIAlertAction) -> Void in
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)

                    }
                    else{ // success
                        Alamofire.request(
                            URL(string: "http://localhost:3000/login")!,
                            method: .post,
                            parameters: ["username":self.username!,"password":self.password!])
                            .validate()
                            .responseJSON {response in
                                var result = response.result.value
                                var json = JSON(result)
                                if(json["Target Action"] == "loginresult"){
                                    if(json["content"] == "success"){
                                        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
                                        let vc = sb.instantiateViewController(withIdentifier: "Main") as! MainViewController
                                        vc.username = self.username!
                                        vc.password = self.password!
                                        vc.modalTransitionStyle = .flipHorizontal
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                    else{
                                        let alertController = UIAlertController(title: "Congratulations!", message: "Now you can log in", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                                        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                            (result : UIAlertAction) -> Void in
                                        }
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                }
                        }
                    }
                }
        }
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
