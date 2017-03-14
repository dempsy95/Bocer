//
//  AddBookViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/29/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    //information used by server
    
    internal var bookID: String?
    
    //for search
    internal var search_text:String?
    internal var search_result:[Dictionary<String, String>] = []
    
    //for add
    internal var google_id:String?
    internal var myTitle: String? = ""
    internal var myAuthor: String? = ""
    private var myPublisher: String? = ""
    
    //for show book info
    var authorCell: UITableViewCell?
    var titleCell: UITableViewCell?
    var mTitle: UILabel?
    var mAuthor: UILabel?
    
    private var book: Book?
    
    @IBOutlet weak var mSearchBar: UISearchBar!
    @IBOutlet weak var mResTable: UITableView!  //书本内容
    @IBOutlet weak var mTableView: UITableView! //搜索结果
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        onMakeNavitem()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //table view delegate
        mResTable.delegate = self
        mResTable.dataSource = self
        mTableView.delegate = self
        mTableView.dataSource = self
        mSearchBar.delegate = self
        self.mTableView.tableFooterView = UIView()
        self.mTableView.tableFooterView?.isHidden = true
        
        mResTable.isHidden = false
        mTableView.isHidden = true
        
        book = BookInfoHelper().getBookInfo(bookID: bookID!)
        google_id = book?.googleID
        
        titleCell = mResTable.dequeueReusableCell(withIdentifier: "edit_book_title")
        mTitle = titleCell?.viewWithTag(100) as! UILabel?
        mTitle?.text = book?.title
        myTitle = book?.title
        authorCell = mResTable.dequeueReusableCell(withIdentifier: "edit_book_author")
        mAuthor = authorCell?.viewWithTag(100) as! UILabel?
        mAuthor?.text = book?.author
        myAuthor = book?.author
        
        myPublisher = book?.publisher
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mResTable.deselectRow(at: IndexPath(item: 0, section: 1), animated: false)
    }
    
    //customize navigation item
    private func onMakeNavitem(){
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(EditBookViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "finish")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(EditBookViewController.didNext), for: .touchUpInside)
        rightBtn.tintColor = UIColor.white
        let rightBtnItem = UIBarButtonItem(customView: rightBtn)
        navigationItem.title = "CHANGE BOOK"
        navigationItem.leftBarButtonItem = btnItem
        navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didNext() {
        nextPerformed()
    }
    
    private func nextPerformed() {
        if google_id == nil {
            let alert = UIAlertController(title: "Warning", message: "You need to find the book you want to sell first", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        BookInfoHelper().updateBookGoogleInfo(book: book!, google_id: google_id!, title: myTitle!, author: myAuthor!, publisher: myPublisher!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewClicked(_ sender: UIView) {
        mSearchBar.resignFirstResponder()
    }
    
    //Table View Functions
    //MARK: - Tableview Delegate & Datasource
    //Cell numbers for each section
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if tableView == mResTable {
            return 2
        } else {
            //TODO:
            //return number of cells for the search result
            return self.search_result.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView == mResTable) {
                if indexPath.item == 0 {
                    self.mTitle?.text = self.myTitle
                    return self.titleCell!
                } else {
                    self.mAuthor?.text = self.myAuthor
                    return self.authorCell!
                }
        } else {
            let identifier = "search_book_info"
            let cell=tableView.dequeueReusableCell(withIdentifier: identifier)
            let mTitle = cell?.viewWithTag(100) as! UILabel?
            let mAuthor = cell?.viewWithTag(101) as! UILabel?
            mTitle?.text = self.search_result[indexPath.row]["title"]
            mAuthor?.text = self.search_result[indexPath.row]["author"]
            self.google_id = self.search_result[indexPath.row]["google_id"]
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mResTable && indexPath.section == 0 && indexPath.item == 0 {
            return 70
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        mSearchBar.resignFirstResponder()
        if tableView == mTableView {
            let cell = mTableView.cellForRow(at: indexPath)
            
            UIView.transition(with: mResTable, duration: 0.5, options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowAnimatedContent], animations: {
                self.mTableView.isHidden = true
                self.mResTable.isHidden = false
                self.myTitle = self.search_result[indexPath.row]["title"]
                self.myAuthor = self.search_result[indexPath.row]["author"]
                print(self.search_result[indexPath.row]["title"])
                print(self.search_result[indexPath.row]["author"])
                
                
                self.mResTable.reloadRows(at: [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0)], with: .none)
            }, completion: nil)
        } else {

        }
    }
    
    @objc private func didSearch() {
        Alamofire.request(
            URL(string: "ec2-50-18-202-224.us-west-1.compute.amazonaws.com:3000/searchBook")!,
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
                        //TODO:
                        //retrieve google_id and publisher from search result
                        if(json["bookname"].string! == self.search_text!){
                            self.mTableView.reloadData()
                        }
                    }
                }
        }
        
        UIView.transition(with: mResTable, duration: 0.5, options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowAnimatedContent], animations: {
            self.mTableView.isHidden = false
            self.mResTable.isHidden = true
        }, completion: nil)
    }
    
    //will added auto complete as one of the functionalities
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search_text = searchText
        [NSObject .cancelPreviousPerformRequests(withTarget: self, selector: #selector(didSearch), object: nil)]
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didSearch), userInfo: nil, repeats: false)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
