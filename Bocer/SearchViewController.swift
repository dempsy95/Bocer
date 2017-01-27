//
//  SearchViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/20/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    private var mNavBar = Constant().makeNavBar()
    @IBOutlet weak var mSearchBar: UISearchBar!
    @IBOutlet weak var schoolButton: UIButton!
    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var mResultTable: UITableView!
    @IBOutlet weak var mMiddleTable: UITableView!
    private var result = [String]()
    private var schoolName: String? = "University of California, Los Angeles"
    override func viewDidLoad() {
        super.viewDidLoad()

        mSearchBar.delegate = self
        self.mResultTable.delegate = self
        mResultTable.dataSource = self
        self.mMiddleTable.delegate = self
        self.mMiddleTable.dataSource = self
        mSearchBar.backgroundImage = UIImage()
        mSearchBar.barTintColor = Constant().defaultColor
        mSearchBar.backgroundColor = UIColor.clear
        mSearchBar.isTranslucent = true
        
        schoolButton.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        schoolButton.layer.borderWidth = 1
        schoolButton.layer.borderColor = UIColor.black.cgColor
        schoolButton.setTitle(schoolName, for: .focused)
        schoolButton.setTitle(schoolName, for: .highlighted)
        schoolButton.setTitle(schoolName, for: .normal)
        schoolButton.setTitle(schoolName, for: .selected)

        
        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //
        mResultTable.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewClicked(_ sender: Any) {
        mSearchBar.resignFirstResponder() 
    }
    
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(SearchViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        mNavItem.setLeftBarButton(btnItem, animated: true)
        
        let mrImage = UIImage(named: "search")
        let rbtn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        rbtn.setImage(mrImage, for: .normal)
        rbtn.addTarget(self, action: #selector(SearchViewController.didSearch), for: .touchUpInside)
        rbtn.tintColor = UIColor.white
        let rbtnItem = UIBarButtonItem(customView: rbtn)
        mNavItem.setRightBarButton(rbtnItem, animated: true)
        mNavItem.title = "SEARCH"
        return mNavItem
    }
    
    @objc private func didSearch() {
        //TODO:
        //When search fired, information inside search bar is sent to the server, and the client will get a list of book names back
        UIView.transition(with: mResultTable, duration: 0.3, options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowAnimatedContent], animations: {
            self.mMiddleTable.isHidden = false
            self.mResultTable.isHidden = true
        }, completion: nil)
    }
    
    @objc private func didCancel() {
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mMiddleTable {
            return 5
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mResultTable {
            let identify: String = "searchCell"
        
            let cell = tableView.dequeueReusableCell(withIdentifier: identify)
            let mImage = cell?.viewWithTag(100) as! UIImageView? //photo of the book
            let mTitle = cell?.viewWithTag(101) as! UILabel?
            let mAuthor = cell?.viewWithTag(102) as! UILabel?
            let mPrice = cell?.viewWithTag(103) as! UILabel?
            let mAvatar = cell?.viewWithTag(104) as! UIImageView?
            mAvatar?.layer.cornerRadius = 25
            mAvatar?.layer.masksToBounds = true
        
        
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
            return cell!
        } else {
            let identify: String = "searchMiddleCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify)
            let mTitle = cell?.viewWithTag(100) as! UILabel?
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mSearchBar.resignFirstResponder()
        if tableView == mMiddleTable {
            let cell = mMiddleTable.cellForRow(at: indexPath)
            //TODO:
            //Send book name back to the server
            //get all the selling items
            
            UIView.transition(with: mMiddleTable, duration: 0.3, options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowAnimatedContent], animations: {
                self.mMiddleTable.isHidden = true
                self.mResultTable.isHidden = false
            }, completion: nil)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("[ViewController searchBar] searchText: \(searchText)")
        
//        // 没有搜索内容时显示全部内容
//        if searchText == "" {
//            self.result = self.array
//        } else {
//            
//            // 匹配用户输入的前缀，不区分大小写
//            self.result = []
//            
//            for arr in self.array {
//                
//                if arr.lowercaseString.hasPrefix(searchText.lowercaseString) {
//                    self.result.append(arr)
//                }
//            }
//        }
        
        // 刷新tableView 数据显示
//        self.tableView.reloadData()
    }
    
    // 搜索触发事件，点击虚拟键盘上的search按钮时触发此方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        didSearch()
    }
    
    // 取消按钮触发事件
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 搜索内容置空
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    @IBAction func schoolButtonFired(_ sender: UIButton) {
        mSearchBar.resignFirstResponder()
        let title = ""
        let message = "\n\n\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.isModalInPopover = true
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 17, y: 52, width: 270, height: 120)// CGRectMake(left), top, width, height) - left and top are like margins
        let picker: UIPickerView = UIPickerView(frame: pickerFrame)
        
        picker.tag = 0
        picker.delegate = self;
        picker.dataSource = self;
        
        alert.view.addSubview(picker);

        //Create the toolbar view - the view witch will hold our 2 buttons
        let toolFrame = CGRect(x: 17, y: 5, width: 270, height: 45)
        let toolView: UIView = UIView(frame: toolFrame);
        
        //add buttons to the view
        let buttonCancelFrame: CGRect = CGRect(x: 0, y: 7, width: 70, height: 30) //size & position of the button as placed on the toolView

        //Create the cancel button & set its title
        let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
        buttonCancel.setTitle("Cancel", for: UIControlState.normal);
        buttonCancel.setTitleColor(UIColor.black, for: UIControlState.normal);
        toolView.addSubview(buttonCancel); //add it to the toolView
        
        //Add the target - target, function to call, the event witch will trigger the function call
        buttonCancel.addTarget(self, action: #selector(SearchViewController.cancelSelection), for: UIControlEvents.touchDown);

        //add buttons to the view
        let buttonOkFrame: CGRect = CGRect(x: 200, y: 7, width: 70, height: 30); //size & position of the button as placed on the toolView
        
        //Create the Select button & set the title
        let buttonOk: UIButton = UIButton(frame: buttonOkFrame);
        buttonOk.setTitle("Select", for: UIControlState.normal);
        buttonOk.setTitleColor(UIColor.black, for: UIControlState.normal);
        toolView.addSubview(buttonOk); //add to the subview
        
        //Add the target - target, function to call, the event witch will trigger the function call
        buttonOk.addTarget(self, action: #selector(SearchViewController.okSelection), for: UIControlEvents.touchDown);
        
        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    @objc private func okSelection(sender: UIButton){
        // Your code when select button is tapped
        schoolButton.setTitle(schoolName, for: .focused)
        schoolButton.setTitle(schoolName, for: .highlighted)
        schoolButton.setTitle(schoolName, for: .normal)
        schoolButton.setTitle(schoolName, for: .selected)
        //schoolButton.contentHorizontalAlignment = .center
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelSelection(sender: UIButton){
        self.dismiss(animated: true, completion: nil);
        // We dismiss the alert. Here you can add your additional code to execute when cancel is pressed
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
        schoolName = SchoolList().School[row]
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
    //TODO:
    //下拉刷新加载更多功能
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
