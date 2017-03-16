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
    
    internal var card: Card?
    private var month, year : Int64?
    private var type: String? = "MASTERCARD"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mTableView.delegate = self
        mTableView.dataSource = self
        
        onMakeNavitem()
                
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true

    }

    override func viewWillAppear(_ animated: Bool) {
        //TODO:
        //get card expiry date by using card number
        month = card?.month
        year = card?.year
        let v = CreditCardValidator()
        type = v.type(from: (card?.number)!)?.name.uppercased()
        navigationItem.title = type
        mTableView.reloadData()
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
                
            mNumber?.text = secure(origin: (card?.number)!)
            return cell!
        } else {
            let identifier = "cardDateCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mDate = cell?.viewWithTag(100) as! UILabel?
            
            mDate?.text = getDate(month: String(describing: month!), year: String(describing: year!))
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
        
        navigationItem.title = type
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
        vc.mCard = card
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func didDelete() {
        let alert = UIAlertController(title: "Warning", message: "Do you really want to delete this card?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            (action: UIAlertAction!) in self.deleteCard(card: self.card!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteCard(card: Card) {
        CardInfoHelper().deleteCard(card: card)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func secure(origin: String) -> String {
        var res = "•••• •••• •••• "
        res = res + origin.substring(from: origin.index(origin.startIndex, offsetBy: 12))
        return res
    }
    
    private func getDate(month: String, year: String) -> String {
        if month.characters.count == 1 {
            return "0"+month+"/"+year
        } else {
            return month+"/"+year
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
