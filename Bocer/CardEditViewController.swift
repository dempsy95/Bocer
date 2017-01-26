//
//  CardEditViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/25/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class CardEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mCVV: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var mDate: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var mNumber: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var mNavItem: UINavigationItem!
    internal var mCardNumber: String?
    internal var mCardTitle: String? = "ADD CARD"
    private let mNavBar = Constant().makeNavBar()
    private var firstChange = true

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
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewClicked(_ sender: UIView) {
    }
    
    private func secure(origin: String) -> String {
        var res = "•••• •••• •••• "
        res = res + origin.substring(from: origin.index(origin.startIndex, offsetBy: 12))
        return res
    }
    
    //textfield delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mNumber && textField.text == nil {
            textField.text = mCardNumber
        }
    }
    
    //limit the maximum length of the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == mNumber) {
            if ((textField.text?.characters.count)! >= 19) {
                textField.text = textField.text?.substring(to: (textField.text?.index((textField.text?.startIndex)!, offsetBy: 18))!)
                return true
            }
            if ((textField.text?.characters.count)! % 5 == 4) {
                textField.text = textField.text! + " "
            }
            if ((textField.text?.characters.count)! % 5 == 0 && (textField.text?.characters.count)! != 0 && textField.text?.substring(from: (textField.text?.endIndex)!) != " ") {
                textField.text = textField.text?.substring(to: (textField.text?.index((textField.text?.endIndex)!, offsetBy: -1))!)
            }
            return true
        } else if (textField == mDate) {
            if ((textField.text?.characters.count)! >= 5) {
                textField.text = textField.text?.substring(to: (textField.text?.index((textField.text?.startIndex)!, offsetBy: 4))!)
                return true
            }
            return true
        } else {
            if ((textField.text?.characters.count)! >= 4) {
                textField.text = textField.text?.substring(to: (textField.text?.index((textField.text?.startIndex)!, offsetBy: 3))!)
                return true
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
    
    private func onMakeNavitem()->UINavigationItem{
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
        
        mNavItem.title = mCardTitle
        mNavItem.setLeftBarButton(btnItem, animated: true)
        mNavItem.setRightBarButton(rbtnItem, animated: true)
        return mNavItem
    }
    
    @objc private func didCancel() {
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func didFinish() {

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
