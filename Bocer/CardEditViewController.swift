//
//  CardEditViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/25/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import CreditCardValidator

class CardEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mCVV: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var mDate: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var mNumber: SkyFloatingLabelTextFieldWithIcon!
    internal var mCardNumber: String?
    internal var mCardTitle: String? = "ADD CARD"
    private var firstChange = true
    private var cvvLimit = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mNumber.delegate = self
        mNumber.title = "Credit Card"
        mNumber.iconFont = UIFont(name: "FontAwesome", size: 20)
        mNumber.iconText = "\u{f061}"
        if mCardNumber != nil {
            mNumber.text? = secure(origin: mCardNumber!)
            //TODO:
            //customize the image of the card
        }
        Constant().customizeSFLTextField(tf: mNumber)
        
        mDate.delegate = self
        mDate.title = "Expiary Date"
        mDate.iconFont = UIFont(name: "FontAwesome", size: 20)
        mDate.iconText = "\u{f133}"
        mDate.textAlignment = .center
        Constant().customizeSFLTextField(tf: mDate)

        mCVV.delegate = self
        mCVV.title = "CVV Number"
        mCVV.iconFont = UIFont(name: "FontAwesome", size: 20)
        mCVV.iconText = "\u{f0a3}"
        mCVV.textAlignment = .center
        Constant().customizeSFLTextField(tf: mCVV)
        
        //customize nav bar
        onMakeNavitem()
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewClicked(_ sender: UIView) {
        mNumber.resignFirstResponder()
        mDate.resignFirstResponder()
        mCVV.resignFirstResponder()
    }
    
    private func secure(origin: String) -> String {
        var res = "•••• •••• •••• "
        res = res + origin.substring(from: origin.index(origin.startIndex, offsetBy: 12))
        return res
    }
    
    //textfield delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mNumber {
            if (textField.text == nil || textField.text == "") && mCardNumber != nil{
                textField.text = secure(origin: mCardNumber!)
            }
            if textField != nil {
                let text = textField.text!
                let v = CreditCardValidator()
                let flag = v.validate(string: text)
                if !flag {
                    UIView.transition(with: mImage, duration: 0.15, options: [UIViewAnimationOptions.transitionFlipFromTop, UIViewAnimationOptions.allowAnimatedContent], animations: {
                        self.mImage.image = UIImage(named: "creditcard")
                    }, completion: nil)
                } else {
                    let type = v.type(from: text)?.name
                    let image = UIImage(named: type!)
                    if image! != self.mImage.image {
                        UIView.transition(with: mImage, duration: 0.15, options: [UIViewAnimationOptions.transitionFlipFromTop, UIViewAnimationOptions.allowAnimatedContent], animations: {
                            self.mImage.image = image
                        }, completion: nil)
                    }
                    if type != "Amex" {
                        cvvLimit = 3
                    } else {
                        cvvLimit = 4
                    }
                    
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mNumber {
            mDate.becomeFirstResponder()
        } else if textField == mDate {
            mCVV.becomeFirstResponder()
        } else {
            
        }
        return true
    }
    
    func canInsert(atLocation y:Int, modNumber z: Int) -> Bool { return ((1 + y)%(z + 1) == 0) ? true : false }
    
    func canRemove(atLocation y:Int, modNumber z: Int) -> Bool { return (y != 0) ? (y%(z + 1) == 0) : false }
    
    //limit the maximum length of the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == mNumber) {
            if range.location == 19 {
                return false
            }
            
            let nsText = textField.text! as NSString
            
            if range.length == 0 && canInsert(atLocation: range.location, modNumber: 4) {
                textField.text! = textField.text! + " " + string
                return false
            }
            
            if range.length == 1 && canRemove(atLocation: range.location, modNumber: 4) {
                textField.text! = nsText.replacingCharacters(in: NSMakeRange(range.location-1, 2), with: "")
                return false
            }
            
            return true
        } else if textField == mCVV {
            if range.location == cvvLimit {
                return false
            }
            return true
        } else {
            if range.location == 5 {
                return false
            }
            
            let nsText = textField.text! as NSString
            
            if range.length == 0 && canInsert(atLocation: range.location, modNumber: 2) {
                textField.text! = textField.text! + "/" + string
                return false
            }
            
            if range.length == 1 && canRemove(atLocation: range.location, modNumber: 2) {
                textField.text! = nsText.replacingCharacters(in: NSMakeRange(range.location-1, 2), with: "")
                return false
            }
            
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mNumber && firstChange {
            firstChange = false
            textField.text = nil
        }
    }
    
    private func onMakeNavitem(){
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(CardEditViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRImage = UIImage(named: "finish")
        let rbtn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        rbtn.setImage(mRImage, for: .normal)
        rbtn.addTarget(self, action: #selector(CardEditViewController.didFinish), for: .touchUpInside)
        rbtn.tintColor = UIColor.white
        let rbtnItem = UIBarButtonItem(customView: rbtn)
        
        navigationItem.title = mCardTitle
        navigationItem.leftBarButtonItem = btnItem
        navigationItem.rightBarButtonItem = rbtnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //TODO:
    //send card info to the server
    @objc private func didFinish() {
        if mDate.text == nil || (mDate.text?.characters.count)! < 4 {
            dateAlert()
            return
        }
        let month = (mDate.text?.substring(to: (mDate.text?.index((mDate.text?.startIndex)!, offsetBy: 2))!))! as String
        let year = (mDate.text?.substring(from: (mDate.text?.index((mDate.text?.startIndex)!, offsetBy: 3))!))! as String
        if Int(month)! > 12 || Int(month)! < 0 {
            dateAlert()
            return
        }
        if Int(year)! > 50 || Int(year)! < 0 {
            dateAlert()
            return
        }
        
        var number = "" as String
        if (mNumber.text == nil) {
            numberAlert()
            return
        }
        for digit in (mNumber.text?.characters)! {
            if digit != " " {
              number = number + String(digit)
            }
            if (digit < "0" || digit > "9") {
                numberAlert()
                return
            }
        }
        if number.characters.count < 12 {
            numberAlert()
            return
        }
        
        if (mCVV.text == nil) {
            cvvAlert()
            return
        }
        let cvv = mCVV.text!
        for digit in cvv.characters {
            if (digit < "0" || digit > "9") {
                cvvAlert()
                return
            }
        }
        if cvv.characters.count != cvvLimit {
            cvvAlert()
            return
        }
        
        if (validate()) {
          //TODO:
          //send info:
          //card number: number
          //card expiary date: month year
          //card cvv: cvv
        }
        self.navigationController?.popViewController(animated: true)
    }

    private func dateAlert() {
        let alertController = UIAlertController(title: "Warning",
                                                message: "The expiary date of your credit card is invalid", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func numberAlert() {
        let alertController = UIAlertController(title: "Warning",
                                                message: "The number of your credit card is invalid", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func cvvAlert() {
        let alertController = UIAlertController(title: "Warning",
                                                message: "The CVV number of your credit card is invalid", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //TODO:
    //validate credit card
    private func validate() -> Bool {
        return true

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
