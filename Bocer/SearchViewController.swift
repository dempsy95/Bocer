//
//  SearchViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/20/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ActionSheetPicker_3_0

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    //informatino specific from server
    internal var search_row_num:Int?
    internal var result_row_num:Int?
    internal var search_text:String?
    
    var search_result:[Dictionary<String, String>] = []
    var fetch_result:[Dictionary<String, String>] = []
    //end information from server

    private var mNavBar = Constant().makeNavBar()
    @IBOutlet weak var mSearchBar: UISearchBar!
    @IBOutlet weak var schoolButton: UIButton!
    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var mResultTable: UITableView!
    @IBOutlet weak var mMiddleTable: UITableView!
    private var result = [String]()
    private var schoolName: String? = "Vanderbilt University"
    override func viewDidLoad() {
        super.viewDidLoad()
        //server part
        self.search_row_num = 0
        self.result_row_num = 0
        //end server part
        mSearchBar.delegate = self
        self.mResultTable.delegate = self
        mResultTable.dataSource = self
        self.mMiddleTable.delegate = self
        self.mMiddleTable.dataSource = self
        self.mMiddleTable.tableFooterView = UIView()
        self.mMiddleTable.tableFooterView?.isHidden = true
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
        Alamofire.request(
            URL(string: "http://localhost:3000/searchBook")!,
            method: .post,
            parameters: ["field":self.search_text!])
            .validate()
            .responseJSON {response in
                var result = response.result.value
                var json = JSON(result)
                if(result != nil){
                    if(json["content"] != "fail"){
                        self.search_result.removeAll()
                        for item in json["content"].array! {
                            var temp = [String:String]()
                            temp["title"] = item["title"].string!
                            if(item["authors"] == nil){
                                temp["author"] = "no author for this book"
                            }
                            else{
                                temp["author"] = item["authors"][0].string!
                            }
                            temp["google_id"] = item["id"].string!
                            self.search_result.append(temp)
                        }
                        if(json["bookname"].string! == self.search_text!){
                            self.mMiddleTable.reloadData()
                        }
                    }
                }
        }
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
            return self.search_result.count
        }
        else if(tableView == mResultTable) {
            return self.fetch_result.count
        }
        else{
            return 0 //in case of more tables added
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
            let mEdition = cell?.viewWithTag(105) as! UILabel?
            mAvatar?.layer.cornerRadius = 25
            mAvatar?.layer.masksToBounds = true
            
            //cell data source
            mTitle?.text = self.fetch_result[indexPath.row]["title"]
            mAuthor?.text = "By " + self.fetch_result[indexPath.row]["author"]!
            mPrice?.text = "$" + self.fetch_result[indexPath.row]["real_price"]!
            mEdition?.text = "Edition:" + self.fetch_result[indexPath.row]["edition"]!
            var userimagedata = NSData(base64Encoded: self.fetch_result[indexPath.row]["userimage"]!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            var userimage = UIImage(data:userimagedata as Data)
            var bookimagedata = NSData(base64Encoded: self.fetch_result[indexPath.row]["smallimage"]!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            var bookimage = UIImage(data:bookimagedata as Data)
            mAvatar?.image = userimage
            mImage?.image = bookimage
            
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
            return cell!
        } else {
            let identify: String = "searchMiddleCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify)
            let mTitle = cell?.viewWithTag(100) as! UILabel?
            let mAuthor = cell?.viewWithTag(101) as! UILabel?
            mTitle?.text = self.search_result[indexPath.row]["title"]
            mAuthor?.text = self.search_result[indexPath.row]["author"]
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mSearchBar.resignFirstResponder()
        if tableView == mMiddleTable {
            let cell = mMiddleTable.cellForRow(at: indexPath)
            let titleLabel = cell?.viewWithTag(100) as! UILabel?
            let authorLabel = cell?.viewWithTag(101) as! UILabel?
            var title = titleLabel?.text!
            var author = authorLabel?.text!
            Alamofire.request(
                URL(string: "http://localhost:3000/fetch_listing_by_author")!,
                method: .post,
                parameters: ["title":title!,"author":author!,"school":schoolName!])
                .validate()
                .responseJSON {response in
                    var result = response.result.value
                    var json = JSON(result)
                    if(result != nil){
                        if(json["Target Action"] == "fetchlistingbyauthorresult"){
                            if(json["content"] != "fail"){
                                if(json["content"] == "empty"){ //there is no data here
                                    self.fetch_result.removeAll()
                                    self.mResultTable.reloadData()
                                }
                                else{
                                    self.fetch_result.removeAll()
                                    for item in json["content"].array! {
                                        var temp = [String:String]()
                                        temp["listing_id"] = item["_id"].string!
                                        temp["title"] = item["title"].string!
                                        temp["author"] = item["author"].string!
                                        temp["school"] = item["school"].string!
                                        temp["edition"] = item["edition"].string!
                                        temp["userimage"] = item["userimage"].string!
                                        temp["smallimage"] = item["small_image"].string!
                                        temp["real_price"] = item["real_price"].string!
                                        temp["state"] = item["state"].string!
                                        self.fetch_result.append(temp)
                                    }
                                    self.mResultTable.reloadData()
                                }
                            }
                        }
                    }
            }
            UIView.transition(with: mMiddleTable, duration: 0.3, options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowAnimatedContent], animations: {
                self.mMiddleTable.isHidden = true
                self.mResultTable.isHidden = false
            }, completion: nil)
        }
    }
    
    //will added auto complete as one of the functionalities
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search_text = searchText
//        [NSObject .cancelPreviousPerformRequests(withTarget: self, selector: Selector(("didsearch")), object: searchText)]
//        
//        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didSearch(bookname:sear)), userInfo: nil, repeats: false)
        [NSObject .cancelPreviousPerformRequests(withTarget: self, selector: #selector(didSearch), object: nil)]
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didSearch), userInfo: nil, repeats: false)
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
        //show actionsheet picker for School
        let picker = ActionSheetStringPicker(title: "Select Your School", rows: SchoolList().School, initialSelection: getLoc(s: schoolName!), doneBlock: {
            picker, indexes, values in
            self.schoolName = values as! String?
            self.schoolButton.setTitle(self.schoolName, for: .focused)
            self.schoolButton.setTitle(self.schoolName, for: .highlighted)
            self.schoolButton.setTitle(self.schoolName, for: .normal)
            self.schoolButton.setTitle(self.schoolName, for: .selected)
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
        picker?.toolbarButtonsColor = UIColor.black
        
        picker?.show()
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
