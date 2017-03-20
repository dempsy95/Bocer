//
//  PayViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/25/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import CreditCardValidator

class PayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var mTableView: UITableView!
    
    private var cards : [Card]?
    private var numOfCards = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mTableView.delegate = self
        mTableView.dataSource = self
        
        onMakeNavitem()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        //TODO:
        //cards = getCardInfo(uid)
        //numOfCards = cards?.count
        cards = CardInfoHelper().loadData()
        numOfCards = (cards?.count)!
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
        if section == 0 {
            return numOfCards + 1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "   Credit/Debit Card"
        } else {
            return "   Wechat Pay"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       if indexPath.section == 0 {
            if indexPath.item < numOfCards {
                let identifier = "cardCell";
                let cell=tableView.dequeueReusableCell(withIdentifier: identifier)
                let mImage = cell?.viewWithTag(100) as! UIImageView?
                let mNumber = cell?.viewWithTag(101) as! UILabel?

                mNumber?.text = secure(origin: (cards?[indexPath.item].number)!)
                let v = CreditCardValidator()
                let type = v.type(from: (cards?[indexPath.item].number)!)
                mImage?.image = UIImage(named: (type?.name)!)
                return cell!
            } else {
                let identifier = "addCardCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                return cell!
            }
        } else {
            let identifier = "wechatCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0 {
            if indexPath.item < numOfCards {
                showCardDetail(card: (cards?[indexPath.item])!)
            } else {
                let sb = UIStoryboard(name: "new-Qian", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "CardEdit") as! CardEditViewController
                vc.mCard = nil
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func onMakeNavitem(){
        let mImage = UIImage(named: "cancel")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(PayViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        navigationItem.title = "PAYMENT"
        navigationItem.leftBarButtonItem = btnItem
    }

    @objc private func didCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    //go to the vc which shows the detail info about a card
    private func showCardDetail(card: Card) {
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Card") as! CardViewController
        vc.card = card
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func secure(origin: String) -> String {
        var res = "•••• "
        res = res + origin.substring(from: origin.index(origin.startIndex, offsetBy: 12))
        return res
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
