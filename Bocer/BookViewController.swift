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
        let mImage = UIImage(named: "cancel")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(BookViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        if right == .edit {
            let mRightImage = UIImage(named: "small_menu")
            let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
            rightBtn.setImage(mRightImage, for: .normal)
            rightBtn.addTarget(self, action: #selector(BookViewController.didEdit), for: .touchUpInside)
            rightBtn.tintColor = UIColor.white
            let rightBtnItem = UIBarButtonItem(customView: rightBtn)
            navigationItem.rightBarButtonItem = rightBtnItem
        } else {
            let mRightImage = UIImage(named: "user")
            let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 30, height: 30))
            rightBtn.setImage(mRightImage, for: .normal)
            rightBtn.addTarget(self, action: #selector(BookViewController.didProfile), for: .touchUpInside)
            rightBtn.tintColor = UIColor.white
            let rightBtnItem = UIBarButtonItem(customView: rightBtn)
            navigationItem.rightBarButtonItem = rightBtnItem
        }
        
        navigationItem.title = "BOOK INFORMATION"
        navigationItem.leftBarButtonItem = btnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didEdit() {
    }
    
    @objc private func didProfile() {
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 3 ? 1 : section == 0 ? 3 : 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(item: 0, section: 0):
            let identifier = "book_title_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            return cell!
            break
        case IndexPath(item: 1, section: 0):
            let identifier = "book_author_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            return cell!
            break
        case IndexPath(item: 2, section: 0):
            let identifier = "book_price_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            return cell!
            break
        case IndexPath(item: 0, section: 1):
            let identifier = "book_edition_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            return cell!
            break
        case IndexPath(item: 1, section: 1):
            let identifier = "book_publisher_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            return cell!
            break
        case IndexPath(item: 0, section: 2):
            let identifier = "book_rating_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mImage = cell?.viewWithTag(100) as! UIImageView?
            return cell!
            break
        case IndexPath(item: 1, section: 2):
            let identifier = "book_description_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mLabel = cell?.viewWithTag(100) as! UILabel?
            return cell!
            break
        default:
            let identifier = "book_photo_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mImage = cell?.viewWithTag(100) as! UIImageView?
            return cell!
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(item: 1, section: 2) || indexPath == IndexPath(item: 0, section: 3) {
            return 80
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0001 : 18
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
