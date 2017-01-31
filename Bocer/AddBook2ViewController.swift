//
//  AddBook2ViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/29/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

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
    internal var showAction: ((UITableViewCell, Int) -> Void)?
    internal func enableBtn(x: Int, photos: [UIImage]) {
        if x != 0 {
            for i in 0 ... x - 1 {
                //let imagedata = UIImageJPEGRepresentation(photos[i], 0.25)!
                let image = photos[i]
                photoBtns[i].alpha = 1
                photoBtns[i].isEnabled = true
                photoBtns[i].setImage(image, for: .normal)
                photoBtns[i].setImage(image, for: .highlighted)
                photoBtns[i].setImage(image, for: .selected)
                photoBtns[i].imageView?.contentMode = .scaleAspectFill
                photoBtns[i].imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
            let image2 = UIImage(named: "addBookHighlight")
            photoBtns[x].setImage(image, for: .normal)
            photoBtns[x].setImage(image2, for: .highlighted)
            photoBtns[x].setImage(image2, for: .selected)
            photoBtns[x].imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            photoBtns[x].removeTarget(self, action: #selector(photoTableCell.didShow), for: .touchUpInside)
            photoBtns[x].addTarget(self, action: #selector(photoTableCell.didPick), for: .touchUpInside)
        }
        if x < 7 {
            for i in x + 1 ... 7 {
                photoBtns[i].alpha = 0
                photoBtns[i].isEnabled = false
                photoBtns[i].removeTarget(self, action: #selector(photoTableCell.didPick), for: .touchUpInside)
                photoBtns[i].removeTarget(self, action: #selector(photoTableCell.didShow), for: .touchUpInside)
            }
        }
    }
    
    @objc internal func didPick() {
        pickAction!(self)
        
    }
    
    @objc internal func didShow(sender: UIButton) {
        for i in 0 ... 7 {
            if photoBtns[i] == sender {
                showAction!(self, i)
            }
        }
    }

}

class AddBook2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommentDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BookPhotoDelegate {

    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var mTableView: UITableView!

    internal var photos = [UIImage](repeating: UIImage(), count: 8)
    internal var photoCnt = 0
    private var wellness: Int = 4
    internal var myInfo: String? = nil
    private let wellString = ["onestar", "twostar", "threestar", "fourstar", "fivestar"]
    private let mNavBar = Constant().makeNavBar()
    private var showedPhoto: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        mTableView.delegate = self
        mTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        mTableView.deselectRow(at: IndexPath(item: 1, section: 1), animated: false)
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
            cell.enableBtn(x: photoCnt, photos: photos)
            cell.pickAction = {(cell) in self.pickPhotos()}
            cell.showAction = {(cell, xx) in self.showPhoto(x: xx)}
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
        if indexPath.section == 1 {
            if indexPath.item == 0 {
                //show actionsheet picker for wellness
                let picker = ActionSheetStringPicker(title: "Book Wellness", rows: ["five - new", "four - almost new", "three - not bad", "two - a little poor", "one - poor"], initialSelection: 4 - wellness, doneBlock: {
                    picker, value, index in
                    self.wellness = 4 - value
                    let cell = self.mTableView.cellForRow(at: IndexPath(item: 0, section: 1))
                    let image = cell?.viewWithTag(100) as! UIImageView?
                    image?.image = UIImage(named: self.wellString[self.wellness])
                    self.mTableView.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .none)
                    self.mTableView.deselectRow(at: IndexPath(item: 0, section: 1), animated: false)
                    return
                }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
                picker?.toolbarButtonsColor = UIColor.black
                picker?.show()
            } else {
                let sb = UIStoryboard(name: "new-Qian", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
                if myInfo != nil {
                    vc.myInfo = myInfo
                }
                vc.delegate = self
                let transition = Constant().transitionFromRight()
                view.window!.layer.add(transition, forKey: kCATransition)
                self.present(vc, animated: false)
            }
        }
    }
    
    //fetch edition info back from child vc
    func fetchCommentBack(edition comment: String) {
        myInfo = comment
        mTableView.reloadData()
    }

    //call photo funcs
    private func pickPhotos() {
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (action: UIAlertAction!) in self.camera()
        })
        let actionLibrary = UIAlertAction(title: "Choose Photo From Library", style: .default, handler: {
            (action: UIAlertAction!) in self.library()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action: UIAlertAction!) in actionsheet.dismiss(animated: true, completion: nil)
        })
        actionsheet.addAction(actionPhoto)
        actionsheet.addAction(actionLibrary)
        actionsheet.addAction(actionCancel)
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    private func showPhoto(x: Int) {
        showedPhoto = x
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookPhoto") as! BookPhotoViewController
        vc.delegate = self
        vc.image = photos[x]
        let transition = Constant().transitionFromRight()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false)
    }
    
    func deletePhoto() {
        if (showedPhoto != 7) {
            for i in showedPhoto! + 1 ... 7 {
                photos[i - 1] = photos[i]
            }
        }
        photos[7] = UIImage()
        photoCnt = photoCnt - 1
        self.mTableView.reloadData()
    }
    
    //调用照片方法
    private func library(){
        let pick:UIImagePickerController = UIImagePickerController()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pick, animated: true, completion: nil)
        
    }
    
    //调用照相机方法
    private func camera(){
        let pick:UIImagePickerController = UIImagePickerController()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.camera
        self.present(pick, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image  = (info[UIImagePickerControllerOriginalImage] as! UIImage?)!
        self.photos[self.photoCnt] = image
        self.photoCnt = self.photoCnt + 1
        self.mTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
