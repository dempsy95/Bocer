//
//  AddBook3ViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/31/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class AddBook3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var mTableView: UITableView!
    
    private let mNavBar = Constant().makeNavBar()
    private var sPrice, fPrice: Double?
    private var dollar = [String](repeating: String(), count: 1000)
    private var cent = [String](repeating: String(), count: 100)
    private var mDollar = 0
    private var mCent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        mTableView.delegate = self
        mTableView.dataSource = self
        
        addBtn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        //initialize picker view content
        for i in 0 ... 999 {
            dollar[i] = String(i)
        }
        
        for i in 0 ... 99 {
            if i < 10 {
                cent[i] = "0" + String(i)
            } else {
                cent[i] = String(i)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addClicked(_ sender: UIButton) {
        finishPerformed()
    }
    
    //customize navigation item
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(AddBook3ViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "finish")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(AddBook3ViewController.didFinish), for: .touchUpInside)
        rightBtn.tintColor = UIColor.white
        let rightBtnItem = UIBarButtonItem(customView: rightBtn)
        mNavItem.title = "YOUR PRICE"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        mNavItem.setRightBarButton(rightBtnItem, animated: true)
        return mNavItem
    }
    
    @objc private func didCancel() {
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func didFinish() {
        finishPerformed()
    }
    
    private func finishPerformed() {
        
    }
    
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
            let identifier = "sellPriceCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            if sPrice == nil {
                mLabel?.text = "----"
            } else {
                mLabel?.text = "$" + String(describing: sPrice!)
            }
            return cell!
        } else {
            let identifier = "buyPriceCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            if fPrice == nil {
                mLabel?.text = "----"
            } else {
                mLabel?.text = "$" + String(describing: fPrice!)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                //show actionsheet picker for price
                let picker = ActionSheetMultipleStringPicker(title: "Select Your Price", rows: [dollar, ["Dollar"], cent, ["Cent  "]], initialSelection: [mDollar, 0, mCent, 0], doneBlock: {
                    picker, indexes, values in
                    self.mDollar = indexes?[0] as! Int
                    self.mCent = indexes?[2] as! Int
                    
                    self.sPrice = Double(self.mDollar) + Double(self.mCent) / 100
                    self.fPrice = self.getFinalPrice(price: self.sPrice!)
                    
                    self.mTableView.reloadData()
                    self.mTableView.deselectRow(at: IndexPath(item: 0, section: 0), animated: false)
                    
                    return
                }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
                picker?.toolbarButtonsColor = UIColor.black
                picker?.show()
            }
        }
    }

    //TODO: calculate the final price by the given price
    private func getFinalPrice(price: Double) -> Double {
        return price
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
