//
//  AddBook3ViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/31/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Alamofire
import SwiftyJSON

class AddBook3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //information used by server
    private var sPrice, fPrice: Double?
    internal var username:String?
    internal var userimage:String?
    internal var book_title:String?
    internal var google_id:String?
    internal var school:String?
    internal var author:String?
    internal var edition:String?
    internal var small_image:String?
    internal var big_image:[String]?
    internal var state:String?
    internal var desc:String?
    internal var price:String?
    
    
    
    //end information used by server
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var mTableView: UITableView!
    
    private var dollar = [String](repeating: String(), count: 1000)
    private var cent = [String](repeating: String(), count: 100)
    private var mDollar = 0
    private var mCent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onMakeNavitem()
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
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addClicked(_ sender: UIButton) {
        finishPerformed()
    }
    
    //customize navigation item
    private func onMakeNavitem(){
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
        navigationItem.title = "YOUR PRICE"
        navigationItem.leftBarButtonItem = btnItem
        navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didFinish() {
        finishPerformed()
    }
    
    private func finishPerformed() {
        Alamofire.request(
            URL(string: "http://localhost:3000/createListing")!,
            method: .post,
            parameters: ["username":self.username!,"title":self.book_title!,"google_id":self.google_id!,"school":self.school!,"author":self.author!,"edition":self.edition!,"userimage":self.userimage!,"small_image":self.small_image!,"big_image":self.big_image!,"price":self.sPrice!,"real_price":self.fPrice!,"state":self.state!,"description":self.desc!])
            .validate()
            .responseJSON {response in
                var result = response.result.value
                var json = JSON(result)
                if(result != nil){
                    if(json["Target Action"] == "createListingresult"){
                        if(json["content"] == "fail"){
                            let alertController = UIAlertController(title: "Woops!", message: "Something bad happened!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                (result : UIAlertAction) -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            //TODO:
                            //Check pop to root vc functionality 
//                            let transition = Constant().transitionFromBottom()
//                            self.view.window!.layer.add(transition, forKey: kCATransition)
//                            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
        }
        
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
