//
//  EditInfoViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/16/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class EditInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!

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
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        for i in 0 ... 1 {
            for j in 0 ... 2 {
                let indexPath = IndexPath(item: j, section: i)
                mTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        mTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //customize navigation item
    private func onMakeNavitem(){
        let mImage = UIImage()
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "finish")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(EditInfoViewController.didCancel), for: .touchUpInside)
        rightBtn.tintColor = UIColor.white
        let rightBtnItem = UIBarButtonItem(customView: rightBtn)
        navigationItem.title = "EDIT USER INFO"
        navigationItem.leftBarButtonItem = btnItem
        navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let info = UserInfoHelper().loadData()
        switch indexPath {
        case IndexPath(item: 0, section: 0):
            let identifier = "edit_avatar_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let mImage = cell?.viewWithTag(100) as! UIImageView?
            mImage?.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
            if info.avatar == nil {
                mImage?.image = UIImage(named: "sample_avatar")
            } else {
                mImage?.image = UIImage(data: info.avatar as! Data)
            }
            return cell!
            break
        case IndexPath(item: 1, section: 0):
            let identifier = "edit_first_name_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let label = cell?.viewWithTag(100) as! UILabel?
            if info.firstname == nil {
                label?.text = "MyFirstName"
            } else {
                label?.text = info.firstname
            }
            return cell!
            break
        case IndexPath(item: 2, section: 0):
            let identifier = "edit_last_name_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let label = cell?.viewWithTag(100) as! UILabel?
            if info.lastname == nil {
                label?.text = "MyLastName"
            } else {
                label?.text = info.lastname
            }
            return cell!
            break
        case IndexPath(item: 0, section: 1):
            let identifier = "edit_email_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let label = cell?.viewWithTag(100) as! UILabel?
            if info.email == nil {
                label?.text = "MyEmail"
            } else {
                label?.text = info.email
            }
            return cell!
            break
        case IndexPath(item: 1, section: 1):
            let identifier = "edit_college_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let label = cell?.viewWithTag(100) as! UILabel?
            if info.college == nil {
                label?.text = "MyCollege"
            } else {
                label?.text = info.college
            }
            return cell!
            break
        case IndexPath(item: 2, section: 1):
            let identifier = "edit_address_cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            let label = cell?.viewWithTag(100) as! UILabel?
            if info.address == nil {
                label?.text = "None"
            } else {
                label?.text = info.address
            }
            return cell!
            break
        default:
            let cell = UITableViewCell()
            return cell
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == IndexPath(item: 0, section: 0) || indexPath == IndexPath(item: 2, section: 1)) {
            return 80
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch  indexPath {
        case IndexPath(item: 0, section: 0):
            pickPhotos()
            break
        case IndexPath(item: 1, section: 0):
            let sb = UIStoryboard(name: "new-Qian", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "EditFirstName") as! EditFirstNameViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case IndexPath(item: 2, section: 0):
            let sb = UIStoryboard(name: "new-Qian", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "EditLastName") as! EditLastNameViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case IndexPath(item: 1, section: 1):
            //show actionsheet picker for School
            let info = UserInfoHelper().loadData()
            let picker = ActionSheetStringPicker(title: "Select Your School", rows: SchoolList().School, initialSelection: getLoc(s: info.college!), doneBlock: {
                picker, indexes, values in
                UserInfoHelper().saveCollege(name: values as! String)
                self.mTableView.reloadData()
                return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
            picker?.toolbarButtonsColor = UIColor.black
            
            picker?.show()
            break
        case IndexPath(item: 2, section: 1):
            let sb = UIStoryboard(name: "new-Qian", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "EditAddress") as! EditAddressViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break

        default:
            break
        }
        
    }
    
    
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
    
    //调用照片方法
    private func library(){
        let pick:UIImagePickerController = UIImagePickerController()
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
        
        UserInfoHelper().storeImage(image: image)
        
        self.mTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.mTableView.deselectRow(at: IndexPath(item: 0, section: 0), animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return SchoolList().School.count
    }
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SchoolList().School[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserInfoHelper().saveCollege(name: SchoolList().School[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 12)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = SchoolList().School[row]
        
        return pickerLabel!;
    }
    
    private func getLoc(s: String) -> Int {
        var ans = 0
        let schools = SchoolList().School
        for name in 0 ... schools.count - 1 {
            if s == schools[name] {
                ans = name
            }
        }
        return ans
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
