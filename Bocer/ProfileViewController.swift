//
//  ProfileViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/19/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import SideMenu

class ProfileViewController: UIViewController, UIViewControllerTransitioningDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    //information used by server
    internal var username:String?
    internal var school:String? = "Vanderbilt University"
    

    
    
    //end information used by server
    @IBOutlet weak var mConstranit: NSLayoutConstraint!
    @IBOutlet weak var mStackView: UIStackView!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mScroll: UIScrollView!
    @IBOutlet weak var mPageControl: UIPageControl!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var uid: String?
    private var books: [Book]?
    private var currentpage = 0
    private var imageofbutton: [String] = ["pencil", "book"]
    private var cancelAction: UIAlertAction?
    private let tablePage = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collegeLabel.text = "Vanderbilt University" //!!!!!!
        self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
        self.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
        mScroll.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 300)
        mStackView.frame.size = CGSize(width: UIScreen.main.bounds.width * 2, height: 300)
        mConstranit.constant = UIScreen.main.bounds.width * 2
        
        // Do any additional setup after loading the view.
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //customize button
        menuButton.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        bookButton.layer.shadowColor = UIColor.black.cgColor
        bookButton.layer.shadowRadius = 1
        bookButton.layer.shadowOffset = CGSize(width: 0, height: 0.8)
        bookButton.layer.shadowOpacity = 1
        bookButton.layer.cornerRadius = 25
        nameLabel.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        //customize scroll view
        mScroll.showsHorizontalScrollIndicator = false
        mScroll.showsVerticalScrollIndicator = false
        mScroll.scrollsToTop = false
        mScroll.delegate = self
//        mScroll.isPagingEnabled = true
        mScroll.isScrollEnabled = true
        
        //customize page controller
        mPageControl.addTarget(self, action: #selector(ProfileViewController.pageChanged), for: UIControlEvents.valueChanged)
        
        //delegate table view
        mTableView.delegate = self
        mTableView.dataSource = self
        
        //delegate the gesture recognizer 
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //load book data from database
        books = BookInfoHelper().loadData()
        
        mTableView.reloadData()
        retrieveInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mScroll {
            //通过scrollView内容的偏移计算当前显示的是第几页
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            //设置pageController的当前页
            mPageControl.currentPage = page
            if currentpage != page {
                currentpage = page
                changeButton()
            }
        }
    }
    
    //点击页控件时事件处理
    @objc private func pageChanged(sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        let point = CGPoint(x: UIScreen.main.bounds.width * CGFloat(sender.currentPage), y: 0)
        mScroll.setContentOffset(point, animated: true)
        if currentpage != sender.currentPage {
            currentpage = sender.currentPage
            changeButton()
        }
    }
    
    //changeButton
    private func changeButton() {
        if currentpage == 1 {
            UIView.transition(with: bookButton, duration: 0.15, options: [UIViewAnimationOptions.transitionFlipFromLeft, UIViewAnimationOptions.allowAnimatedContent], animations: {
                self.bookButton.setImage(UIImage(named: "book"), for: UIControlState.normal)
                self.bookButton.backgroundColor = UIColor.brown
            }, completion: nil)
        } else {
            UIView.transition(with: bookButton, duration: 0.15, options: [UIViewAnimationOptions.transitionFlipFromRight, UIViewAnimationOptions.allowAnimatedContent], animations: {
                self.bookButton.setImage(UIImage(named: "pencil"), for: UIControlState.normal)
                self.bookButton.backgroundColor = UIColor.red
            }, completion: nil)
        }
    }
    
    //TODO:
    //Edit user's info or add a book
    @IBAction func bookFired(_ sender: UIButton) {
        if currentpage == 0 {
            //TODO:
            //Edit personal info
            let sb = UIStoryboard(name: "new-Qian", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "EditInfo") as! EditInfoViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            //TODO:
            //Add a book
            //encode image
            let imagedata = UIImageJPEGRepresentation(self.mImage.image!, 0.25)
            let imagestring = imagedata?.base64EncodedString()
            let sb = UIStoryboard(name: "new-Qian", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AddBook") as! AddBookViewController
            vc.username = self.username!
            vc.userimage = imagestring!
            vc.school = self.collegeLabel.text!

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func menuFired(_ sender: UIButton) {
        UIView.transition(with: menuButton, duration: 0.15, options: UIViewAnimationOptions.transitionFlipFromTop, animations: nil, completion: nil)
        showMain()
    }
    
    //TODO:
    //Get users' info by using uid
    private func retrieveInfo() {
        //nameLabel.text = userInfo(uid).getFirstName + " " + userInfo(uid).getLastName
        //emailLabel.text = userInfo(uid).getEmail
        //collegeLabel.text = userInfo(uid).getCollege
        //addressLabel.text = userInfo(uid).getAddress
        //bid = userInfo(uid).getBook
        let info = UserInfoHelper().loadData()
        if (uid == info.id) {
            let s = info.firstname! + "  " + info.lastname!
            nameLabel.text = s.uppercased()
            nameLabel.sizeToFit()
            emailLabel.text = info.email
            collegeLabel.text = info.college
            if info.address != nil {
                addressLabel.text = info.address
            } else {
                addressLabel.text = "None"
            }
            if info.full_avatar == nil {
                mImage.image = UIImage(named: "sample_big_avatar")
            } else {
                mImage.image = UIImage(data: info.full_avatar as Data!)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //go to the other vcs
    private func showMain() {
//        let transition = Constant().transitionFromBottom()
//        view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //TODO:
    //Table View delegate for books
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identify: String = "bookCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identify)
        let mImage = cell?.viewWithTag(100) as! UIImageView? //photo of the book
        var mTitle = cell?.viewWithTag(101) as! UILabel?
        let mAuthor = cell?.viewWithTag(102) as! UILabel?
        let mPrice = cell?.viewWithTag(103) as!UILabel?
        let mEdition = cell?.viewWithTag(104) as! UILabel?
        
        let book = books?[indexPath.item]
        
        //TODO:
        //retrieve bookinfo by using book id
        let imagedata = BookInfoHelper().getFirstImage(book: book!)?.photo
        mImage?.image = UIImage(data: imagedata as! Data)
        mTitle?.text = book?.title
        mAuthor?.text = "By" + (book?.author)!
        mPrice?.text = "$" + String(format: "%.2f", (book?.buyerPrice)!)
        mEdition?.text = "Edition: " + String(format: "%d", (book?.edition)!)
        
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Book") as! BookViewController
        vc.right = .edit
        vc.bookID = books?[indexPath.item].bookID
        self.navigationController?.pushViewController(vc, animated: true)
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
