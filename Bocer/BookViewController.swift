//
//  BookViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/17/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    
    enum rightButton {
        case edit
        case profile
        case main
    }
    
    internal var right: rightButton?
    internal var bookID: String?
    
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
        super.viewWillAppear(animated)
        mTableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    //customize navigation item
    private func onMakeNavitem(){
        var mImage = UIImage(named: "back")
        if right == .main {
            mImage = UIImage(named: "cancel")
        }
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(BookViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        if right == .edit {
            let mRightImage = UIImage(named: "finish")
            let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
            rightBtn.setImage(mRightImage, for: .normal)
            rightBtn.addTarget(self, action: #selector(BookViewController.didFinish), for: .touchUpInside)
            rightBtn.tintColor = UIColor.white
            let rightBtnItem = UIBarButtonItem(customView: rightBtn)
            navigationItem.rightBarButtonItem = rightBtnItem
        } else {
            let mRightImage = UIImage(named: "small_menu")
            let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
            rightBtn.setImage(mRightImage, for: .normal)
            rightBtn.addTarget(self, action: #selector(BookViewController.didMenu), for: .touchUpInside)
            rightBtn.tintColor = UIColor.white
            let rightBtnItem = UIBarButtonItem(customView: rightBtn)
            navigationItem.rightBarButtonItem = rightBtnItem
        }
        
        navigationItem.title = "BOOK INFORMATION"
        navigationItem.leftBarButtonItem = btnItem
    }
    
    @objc private func didCancel() {
        if right == .main {
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func didFinish() {
        
    }
    
    @objc private func didMenu() {
        let mAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionSeller = UIAlertAction(title: "Seller's profile", style: .default, handler: {
            (action: UIAlertAction!) in self.didProfile()
        })
        let actionChat = UIAlertAction(title: "Contact seller", style: .default, handler: {
            (action: UIAlertAction!) in self.didContact()
        })
        let actionBuy = UIAlertAction(title: "Buy this book!", style: .destructive, handler: {
            (action: UIAlertAction!) in self.didBuy()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action: UIAlertAction!) in mAlert.dismiss(animated: true, completion: nil)
        })

        mAlert.addAction(actionSeller)
        mAlert.addAction(actionChat)
        mAlert.addAction(actionBuy)
        mAlert.addAction(actionCancel)
        self.present(mAlert, animated: true, completion: nil)
    }
    
    private func didProfile() {
        //TODO:
        //goto seller's profile vc
    }
    
    private func didContact() {
        //TODO:
        //goto chat vc
    }
    
    private func didBuy() {
        let mAlert = UIAlertController(title: "Are you sure you want to buy this book?", message: nil, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes I want to buy it!", style: .destructive, handler: {
            (action: UIAlertAction!) in self.didConfirmBuy()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action: UIAlertAction!) in mAlert.dismiss(animated: true, completion: nil)
        })
        mAlert.addAction(actionYes)
        mAlert.addAction(actionCancel)
        self.present(mAlert, animated: true, completion: nil)
    }
    
    private func didConfirmBuy() {
        //TODO:
        //buy process
        //goto confirmation page
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 3 ? 1 : section == 1 ? 3 : 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath {
        case IndexPath(item: 0, section: 0):
            let identifier = "book_main_cell"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mImage = cell?.viewWithTag(100) as! UIImageView?
            let mTitle = cell?.viewWithTag(101) as! UILabel?
            let mAuthor = cell?.viewWithTag(102) as! UILabel?
            break
        case IndexPath(item: 0, section: 1):
            let identifier = "book_price_cell"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            break
        case IndexPath(item: 1, section: 1):
            let identifier = "book_edition_cell"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            break
        case IndexPath(item: 2, section: 1):
            let identifier = "book_publisher_cell"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            break
        case IndexPath(item: 0, section: 2):
            let identifier = "book_rating_cell"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mImage = cell?.viewWithTag(100) as! UIImageView?
            break
        case IndexPath(item: 1, section: 2):
            let identifier = "book_description_cell"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            break
        default:
            let identifier = "book_photo_cell"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mImage = cell?.viewWithTag(100) as! UIImageView?
            break
        }
        if right == .edit {
            cell?.accessoryType = .disclosureIndicator
            cell?.isUserInteractionEnabled = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(item: 0, section: 0) {
            return 170
        }
        if indexPath == IndexPath(item: 1, section: 2) || indexPath == IndexPath(item: 0, section: 3) {
            return 80
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0001 : 18
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(item: 0, section: 3):
            let sb = UIStoryboard(name: "new-Qian", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "BookPhotoPage") as! BookPhotoPageViewController
            vc.startIndex = 0
            vc.images = [UIImage(named: "book_image")!, UIImage(named: "book_image_2")!, UIImage(named: "book_image_3")!]
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
