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
    @IBOutlet weak var mNavItem: UINavigationItem!
    
    var cardNumber: String?
    private var month = "08", year = "2018"
    private let mNavBar = Constant().makeNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mTableView.delegate = self
        mTableView.dataSource = self
        
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
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
    
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "cancel")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(CardViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        mNavItem.title = "PAYMENT"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        return mNavItem
    }
    
    @objc private func didCancel() {
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
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
