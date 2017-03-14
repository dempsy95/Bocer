//
//  ResetPasswordViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/16/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResetPasswordViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {

    private var countdownTimer: Timer?
    
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var enter: UIButton!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var pwTF: SkyFloatingLabelTextFieldWithIcon!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //customize status bar
        onMakeNavitem()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //delegate and customize textfields
        emailTF.delegate = self
        emailTF.title = "Enter Your College Email Address"
        emailTF.iconFont = UIFont(name: "FontAwesome", size: 20)
        emailTF.iconText = "\u{f007}"
        emailTF.errorColor = .red
        Constant().customizeSFLTextField(tf: emailTF)
        pwTF.delegate = self
        pwTF.title = "verification code"
        pwTF.iconFont = UIFont(name: "FontAwesome", size: 20)
        pwTF.iconText = "\u{f023}"
        Constant().customizeSFLTextField(tf: pwTF)
        
        //customize button
        send.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        enter.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
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
    private func onMakeNavitem(){
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(ResetPasswordViewController.onCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        navigationItem.title = "RESET PASSWORD"
        navigationItem.leftBarButtonItem = btnItem
    }
    
    //return by swiping back
    private func addSwipeRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ResetPasswordViewController.onCancel))
        swipeRecognizer.direction = .right
        swipeRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    

    //text field close
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        if textField == emailTF {
            sendPerformed()
        } else {
            enterPerformed()
        }
        return true
    }

    //Time counter
    func updateTime(timer: Timer) {
        remainingSeconds -= 1
    }
    
    private var remainingSeconds: Int = 0 {
        willSet {
            
            UIView.setAnimationsEnabled(false)
            send.setTitle("\(newValue)s", for: .disabled)
            UIView.setAnimationsEnabled(false)
            
            if newValue <= 0 {
                send.setTitle("Resend", for: .normal)
                isCounting = false
            }
        }
    }
    
    private var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(ResetPasswordViewController.updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 60
                send.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                send.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)            }
            send.isEnabled = !newValue
        }
    }
    
    private func beginCounting() {
        isCounting = true
    }
    
    
    
    @IBAction func sendFired(_ sender: UIButton) {
        sendPerformed()
    }
    @IBAction func enterFired(_ sender: UIButton) {
        enterPerformed()
    }

    @IBAction func viewClicked(_ sender: UIView) {
        emailTF.resignFirstResponder()
        pwTF.resignFirstResponder()
    }
    
    //validate if email address is valid
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    /*
    TODO:
     1. Need to check whether email account is exist
    */
    private func sendPerformed() {
        if(validateEmail(enteredEmail: emailTF.text!)){
            Alamofire.request(
                URL(string: "ec2-50-18-202-224.us-west-1.compute.amazonaws.com:3000/forgetPassword")!,
                method: .post,
                parameters: ["username":emailTF.text!])
                .validate()
                .responseJSON {response in
                    var result = response.result.value
                    var json = JSON(result)
                    if(json["Target Action"] == "forgetresult"){
                        if(json["content"] == "fail"){
                            let alertController = UIAlertController(title: "Woops!", message: "Something bad happens", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                (result : UIAlertAction) -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)

                        }
                        else if(json["content"] == "not exist"){
                            let alertController = UIAlertController(title: "Woops!", message: "The email address does not exist", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                (result : UIAlertAction) -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)

                        }
                        else{ //success
                            //begin counting
                            if !self.isCounting {
                                self.beginCounting()
                                let alertController = UIAlertController(title: "Warning",
                                                                        message: "A verification link has been sent to your Email.\nYou need to wait 60 seconds to send another one.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
            }
        }
        else{
            let alertController = UIAlertController(title: "Woops!", message: "Not a valid email address", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

    
    private func enterPerformed() {
        if(emailTF.text == "" || emailTF.text == nil || pwTF.text == "" || pwTF.text == nil){
            let alertController = UIAlertController(title: "Woops!", message: "Both fields can not be empty", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        }
        else{
            let sb = UIStoryboard(name: "new-Qian", bundle: nil);
            let vc = sb.instantiateViewController(withIdentifier: "ResetPassword2") as! ResetPassword2ViewController
            vc.username = emailTF.text
            vc.token = pwTF.text
            //self.push(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
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
