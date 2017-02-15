//
//  CardViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/25/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import CreditCardValidator

class CardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    
    var cardNumber: String?
    private var month = "08", year = "2018"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mTableView.delegate = self
        mTableView.dataSource = self
        
        onMakeNavitem()
    }

    override func viewWillAppear(_ animated: Bool) {
        //TODO:
        //get card expiry date by using card number
        //month = getCardInfo(cardNumber).month
        //year = getCardInfo(cardNumber).year
        //let v = CreditCardValidator()
        //let type = v.type(from: cardNumber)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let identifier = "cardNumberCell";
            let cell=tableView.dequeueReusableCell(withIdentifier: identifier)
            let mNumber = cell?.viewWithTag(100) as! UILabel?
                
            mNumber?.text = secure(origin: (cardNumber)!)
            return cell!
        } else {
            let identifier = "cardDateCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mDate = cell?.viewWithTag(101) as! UILabel?
            
            mDate?.text = getDate(month: month, year: year)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
    
    private func onMakeNavitem(){
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(CardViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRImage = UIImage(named: "small_menu")
        let rbtn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        rbtn.setImage(mRImage, for: .normal)
        rbtn.addTarget(self, action: #selector(CardViewController.didMenu), for: .touchUpInside)
        rbtn.tintColor = UIColor.white
        let rbtnItem = UIBarButtonItem(customView: rbtn)
        
        navigationItem.title = "MASTERCARD"
        navigationItem.leftBarButtonItem = btnItem
        navigationItem.rightBarButtonItem = rbtnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didMenu() {
        let mAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionEdit = UIAlertAction(title: "Edit", style: .default, handler: {
            (action: UIAlertAction!) in self.didEdit()
        })
        let actionDelete = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (action: UIAlertAction!) in self.didDelete()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action: UIAlertAction!) in mAlert.dismiss(animated: true, completion: nil)
        })
        mAlert.addAction(actionEdit)
        mAlert.addAction(actionDelete)
        mAlert.addAction(actionCancel)
        self.present(mAlert, animated: true, completion: nil)
    }

    private func didEdit() {
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CardEdit") as! CardEditViewController
        vc.mCardNumber = self.cardNumber
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func didDelete() {
        
    }
    
    private func secure(origin: String) -> String {
        var res = "•••• •••• •••• "
        res = res + origin.substring(from: origin.index(origin.startIndex, offsetBy: 12))
        return res
    }
    
    private func getDate(month: String, year: String) -> String {
        return month+"/"+year
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
