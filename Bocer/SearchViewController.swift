//
//  SearchViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/20/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private var mNavBar = Constant().makeNavBar()
    @IBOutlet weak var mSearchBar: UISearchBar!
    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var mResultTable: UITableView!
    private var result = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        mSearchBar.delegate = self
        self.mResultTable.delegate = self
        mResultTable.dataSource = self
        mSearchBar.backgroundImage = UIImage()
        mSearchBar.barTintColor = Constant().defaultColor
        mSearchBar.backgroundColor = UIColor.clear
        mSearchBar.isTranslucent = true
        
        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewClicked(_ sender: Any) {
    }
    
    private func onMakeNavitem()->UINavigationItem{
        let btn = UIBarButtonItem(title: " Back", style: .plain,
                                      target: self, action: #selector(SearchViewController.didCancel))
        btn.tintColor = UIColor.white
        mNavItem.setLeftBarButton(btn, animated: true)
        
        let rightBtn = UIBarButtonItem(title: "Search", style: .plain,
                                  target: self, action: #selector(SearchViewController.didSearch))
        rightBtn.tintColor = UIColor.white
        mNavItem.setRightBarButton(rightBtn, animated: true)
        mNavItem.title = "SEARCH"
        return mNavItem
    }
    
    @objc private func didSearch() {
        
    }
    
    @objc private func didCancel() {
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identify: String = "searchCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identify)
        let mImage = cell?.viewWithTag(100) as! UIImageView? //photo of the book
        let mTitle = cell?.viewWithTag(101)
        let mAuthor = cell?.viewWithTag(102)
        let mPrice = cell?.viewWithTag(103)
        let mAvatar = cell?.viewWithTag(104) as! UIImageView?
        mAvatar?.layer.cornerRadius = 25
        mAvatar?.layer.masksToBounds = true
        
        
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
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
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    // 取消按钮触发事件
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // 搜索内容置空
        searchBar.text = ""
//        self.result = self.array
//        self.tableView.reloadData()
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
