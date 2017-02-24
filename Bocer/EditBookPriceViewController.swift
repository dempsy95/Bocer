//
//  EditBookPriceViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/23/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class EditBookPriceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    internal var bookID: String?
    
    private var dollar = [String](repeating: String(), count: 1000)
    private var cent = [String](repeating: String(), count: 100)
    private var mDollar = 0
    private var mCent = 0
    private var sPrice, fPrice: Double?
    private var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onMakeNavitem()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        mTableView.delegate = self
        mTableView.dataSource = self
        
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
        
        book = BookInfoHelper().getBookInfo(bookID: bookID!)
        sPrice = book?.sellerPrice
        fPrice = book?.buyerPrice
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //customize navigation item
    private func onMakeNavitem(){
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(EditBookPriceViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "finish")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(EditBookPriceViewController.didFinish), for: .touchUpInside)
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
        if(self.sPrice == nil){
            let alert = UIAlertController(title: "Warning", message: "You must provide some number for edition", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            BookInfoHelper().updateBookPrice(book: book!, sPrice: sPrice!, fPrice: fPrice!)
            self.navigationController?.popViewController(animated: true)
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
            let identifier = "edit_sell_price"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            if sPrice == nil {
                mLabel?.text = "----"
            } else {
                mLabel?.text = "$" + String(describing: sPrice!)
            }
            return cell!
        } else {
            let identifier = "edit_buy_price"
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
