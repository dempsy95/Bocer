//
//  AddBook2ViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/29/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class photoTableCell: UITableViewCell {
    @IBOutlet weak var photo1: UIButton!
    @IBOutlet weak var photo2: UIButton!
    @IBOutlet weak var photo3: UIButton!
    @IBOutlet weak var photo4: UIButton!
    @IBOutlet weak var photo5: UIButton!
    @IBOutlet weak var photo6: UIButton!
    @IBOutlet weak var photo7: UIButton!
    @IBOutlet weak var photo8: UIButton!
    
    internal var photoBtns: [UIButton] = [UIButton]()
    
    internal var pickAction: ((UITableViewCell) -> Void)?
    internal var showAction: ((UITableViewCell) -> Void)?
    
    internal func enableBtn(x: Int) {
        for btn in photoBtns {
            btn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        }
        if x != 0 {
            for i in 0 ... x - 1 {
                photoBtns[i].removeTarget(self, action: #selector(photoTableCell.didPick), for: .touchUpInside)
                photoBtns[i].addTarget(self, action: #selector(photoTableCell.didShow), for: .touchUpInside)
            }
        }
        if (x != 8) {
            photoBtns[x].isEnabled = true
            photoBtns[x].alpha = 1
            photoBtns[x].layer.borderWidth = 1
            photoBtns[x].layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1).cgColor
            let image = UIImage(named: "addBookPhoto")
            photoBtns[x].setImage(image, for: .normal)
            photoBtns[x].setImage(image, for: .focused)
            photoBtns[x].setImage(image, for: .highlighted)
            photoBtns[x].setImage(image, for: .selected)
            photoBtns[x].imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            photoBtns[x].addTarget(self, action: #selector(photoTableCell.didPick), for: .touchUpInside)
        }
        if x < 7 {
            for i in x + 1 ... 7 {
                photoBtns[i].alpha = 0
                photoBtns[i].isEnabled = false
            }
        }
    }
    
    @objc internal func didPick() {
        pickAction!(self)
        
    }
    
    @objc internal func didShow() {
        showAction!(self)
    }

}

class AddBook2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var mTableView: UITableView!

    internal var photos: [UIImage] = [UIImage()]
    internal var photoCnt = 0
    private var wellness: Int = 4
    internal let myInfo: String? = nil
    private let wellString = ["onestar", "twostar", "threestar", "fourstar", "fivestar"]
    private let mNavBar = Constant().makeNavBar()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        mTableView.delegate = self
        mTableView.dataSource = self
    }

    //customize navigation item
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(AddBook2ViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "next")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(AddBook2ViewController.didNext), for: .touchUpInside)
        rightBtn.tintColor = UIColor.white
        let rightBtnItem = UIBarButtonItem(customView: rightBtn)
        mNavItem.title = "ADD BOOK"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        mNavItem.setRightBarButton(rightBtnItem, animated: true)
        return mNavItem
    }
    
    @objc private func didCancel() {
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func didNext() {
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let identifier = "bookPhotoCell"
            let cell:photoTableCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! photoTableCell
            cell.photoBtns = [cell.photo1, cell.photo2, cell.photo3, cell.photo4, cell.photo5, cell.photo6, cell.photo7, cell.photo8]
            cell.enableBtn(x: photoCnt)
            cell.pickAction = {(cell) in self.pickPhotos()}
            cell.showAction = {(cell) in self.showPhoto()}
            return cell
        } else if indexPath.item == 0 {
            let identifier = "bookWellCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mWell = cell?.viewWithTag(100) as! UIImageView?
            mWell?.image = UIImage(named: wellString[wellness])
            return cell!
        } else {
            let identifier = "bookInfoCell"
            let cell=tableView.dequeueReusableCell(withIdentifier: identifier)
            let mInfo = cell?.viewWithTag(100) as! UILabel?
            if myInfo != nil {
                mInfo?.text? = myInfo!
            } else {
                mInfo?.text? = "Course name/number, wellness, content, etc."
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 181
        } else if indexPath.item == 0 {
            return 50
        } else {
            return 94
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0 {
            
        }
    }

    private func pickPhotos() {
        
    }
    
    private func showPhoto() {
        
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
