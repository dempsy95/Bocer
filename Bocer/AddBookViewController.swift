//
//  AddBookViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/29/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, EditionDelegate {

    @IBOutlet weak var mResTable: UITableView!
    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var mSearchBar: UISearchBar!
    @IBOutlet weak var mTableView: UITableView!
    
    private var myTitle: String? = "Selected Stories of Lu Hsun"
    private var myAuthor: String? = "Lu Hsun"
    internal var myEdition: String?
    private let mNavBar = Constant().makeNavBar()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        nextBtn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        //table view delegate
        mResTable.delegate = self
        mResTable.dataSource = self
        mTableView.delegate = self
        mTableView.dataSource = self
        mSearchBar.delegate = self
        
        mResTable.isHidden = true
        nextBtn.isHidden = true
        mTableView.isHidden = false
    }
    
    //customize navigation item
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(AddBookViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "next")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(AddBookViewController.didNext), for: .touchUpInside)
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
        nextPerformed()
    }
    
    @IBAction func nextFired(_ sender: UIButton) {
        nextPerformed()
    }
    
    private func nextPerformed() {
        
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
            if section == 0 {
                return 2
            } else {
                return 1
            }
        } else {
            //TODO: 
            //return number of cells for the search result
            return 10
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == mResTable {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView == mResTable) {
            if indexPath.section == 0 {
                if indexPath.item == 0 {
                    let identifier = "addBookTitle"
                    let cell=tableView.dequeueReusableCell(withIdentifier: identifier)
                    let mTitle = cell?.viewWithTag(100) as! UILabel?
                    mTitle?.text? = myTitle!
                    return cell!
                } else {
                    let identifier = "addBookAuthor"
                    let cell=tableView.dequeueReusableCell(withIdentifier: identifier)
                    let mAuthor = cell?.viewWithTag(100) as! UILabel?
                    mAuthor?.text? = myAuthor!
                    return cell!
                }
            } else {
                let identifier = "addBookEdition"
                let cell=tableView.dequeueReusableCell(withIdentifier: identifier)
                let mEdition = cell?.viewWithTag(100) as! UILabel?
                if myEdition != nil {
                    mEdition?.text? = myEdition!
                } else {
                    mEdition?.text? = "Enter your book's edition here"
                }
                return cell!
            }
        } else {
            let identifier = "addBookCell"
            let cell=tableView.dequeueReusableCell(withIdentifier: identifier)
            return cell!
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
                self.nextBtn.isHidden = false
                //TODO:
                //get info of the BOOK
                //myTitle, myAuthor, myEdition
                //mResTable.reloadData()
            }, completion: nil)
        } else {
            if indexPath == IndexPath(item: 0, section: 1) {
                let sb = UIStoryboard(name: "new-Qian", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "Edition") as! EditionViewController
                if myEdition != nil {
                    vc.myEdition = myEdition
                }
                vc.delegate = self
                let transition = Constant().transitionFromRight()
                view.window!.layer.add(transition, forKey: kCATransition)
                self.present(vc, animated: false)
            }
        }
    }
    
    //fetch edition info back from child vc
    func fetchEditionBack(edition: String) {
        print("fetch info success")
        myEdition = edition
        print(myEdition)
        mResTable.reloadData()
    }
    
    @objc private func didSearch() {
        UIView.transition(with: mResTable, duration: 0.5, options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowAnimatedContent], animations: {
            self.mTableView.isHidden = false
            self.mResTable.isHidden = true
            self.nextBtn.isHidden = true
        }, completion: nil)
    }
    
    //will added auto complete as one of the functionalities
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

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