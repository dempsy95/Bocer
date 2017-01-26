//
//  CardEditViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/25/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import CreditCardValidator
import FormTextField
import Formatter
import Validation
import InputValidator

class CardEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FormTextFieldDelegate {

    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mNavItem: UINavigationItem!
    internal var cardNumber: String?
    private var mNumber: FormTextField?
    private var mDate, mCVV: UITextField?
    private var mType: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mTableView.delegate = self
        mTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewClicked(_ sender: UIView) {
        mNumber?.resignFirstResponder()
        mDate?.resignFirstResponder()
        mCVV?.resignFirstResponder()
    }
    
    //Table View Functions
    //MARK: - Tableview Delegate & Datasource
    //Cell numbers for each section
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.item == 0 {
            let identifier = "cardEdit_Card"
            let cell1=tableView.dequeueReusableCell(withIdentifier: identifier)
            let mType = cell1?.viewWithTag(100) as! UIImageView?
            mNumber = cell1?.viewWithTag(101) as! FormTextField?
            mNumber?.formatter = CardNumberFormatter()
            mNumber?.invalidTextColor = .red
            var validation = Validation()
            validation.maximumLength = "1234 5678 1234 5678".characters.count
            validation.minimumLength = "1234 5678 1234 5678".characters.count
            validation.required = true
            let characterSet = NSMutableCharacterSet.decimalDigit()
            characterSet.addCharacters(in: " ")
            validation.characterSet = characterSet as CharacterSet
            let inputValidator = InputValidator(validation: validation)
            mNumber?.inputValidator = inputValidator
            
            if cardNumber != nil {
                mNumber?.text = secure(origin: (cardNumber)!)
                let v = CreditCardValidator()
                //mType?.image = UIImage(named: v.type(from: cardNumber!).name)
            }
            
            cell1?.bringSubview(toFront: mNumber!)
            
            return cell1!
        } else {
            let identifier = "cardEdit_Info"
            let cell2 = tableView.dequeueReusableCell(withIdentifier: identifier)
            mDate = cell2?.viewWithTag(100) as! UITextField?
            mCVV = cell2?.viewWithTag(101) as! UITextField?
            //let mZip = cell2?.viewWithTag(102) as! FormTextField?
            //let mCountry = cell2?.viewWithTag(103) as! UIButton?
            return cell2!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    private func secure(origin: String) -> String {
        var res = "•••• •••• •••• "
        res = res + origin.substring(from: origin.index(origin.startIndex, offsetBy: 12))
        return res
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell1=mTableView.dequeueReusableCell(withIdentifier: "cardEdit_Card")
        if mNumber == textField {
            let v = CreditCardValidator()
            if v.validate(string: textField.text!) {
                let mType = cell1?.viewWithTag(100) as! UIImageView?
                mType?.image = UIImage(named: (v.type(from: cardNumber!)?.name)!)
            }
        }
    }
    
    func formTextFieldDidReturn(_ textField: FormTextField) {
        if textField == mNumber {
            mDate?.becomeFirstResponder()
        } else if textField == mDate {
            mCVV?.becomeFirstResponder()
        }
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
