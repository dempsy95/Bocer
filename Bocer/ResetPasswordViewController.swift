//
//  ResetPasswordViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/16/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {

    private let mNavBar = Constant().makeNavBar()
    private var countdownTimer: Timer?
    
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var enter: UIButton!
    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var pwTF: SkyFloatingLabelTextFieldWithIcon!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    private func onMakeNavitem()->UINavigationItem{
        let backBtn = UIBarButtonItem(title: "  Back", style: .plain,
                                      target: self, action: #selector(ResetPasswordViewController.onCancel))
        backBtn.tintColor = UIColor.white
        mNavItem.title = "RESET PASSWORD"
        mNavItem.setLeftBarButton(backBtn, animated: true)
        return mNavItem
    }
    
    //return by swiping back
    private func addSwipeRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ResetPasswordViewController.onCancel))
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
    
    /*
    TODO:
     1. Need to check whether email account is exist
    */
    private func sendPerformed() {
        
        //begin counting
        if !isCounting {
            beginCounting()
            let alertController = UIAlertController(title: "Warning",
                                                message: "A verification link has been sent to your Email.\nYou need to wait 60 seconds to send another one.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
     TODO:
     isValidEmail
     input an email and check whether it is a valid college email or not
     */
    private func isValidEmail(s: String) -> Bool {
        return true
    }
    
    /*
    TODO:
    check whether the verification code entered by the user is correct or not
    */
    private func checkVerificationCode(s: String?) -> Bool {
        return true
    }
    
    private func enterPerformed() {
        if checkVerificationCode(s: pwTF.text) {
            let sb = UIStoryboard(name: "new-Qian", bundle: nil);
            let vc = sb.instantiateViewController(withIdentifier: "ResetPassword2") as UIViewController
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
