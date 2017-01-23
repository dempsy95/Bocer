//
//  ProfileViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/19/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import SideMenu

class ProfileViewController: UIViewController, MenuViewControllerDelegate, UIViewControllerTransitioningDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

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

    var uid: Int?
    private var bid: [Int]?
    private var currentpage = 0
    private var imageofbutton: [String] = ["pencil", "book"]
    private var cancelAction: UIAlertAction?
    private let tablePage = UITableView()
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //customize button
        menuButton.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        bookButton.layer.shadowColor = UIColor.black.cgColor
        bookButton.layer.shadowRadius = 1
        bookButton.layer.shadowOffset = CGSize(width: 0, height: 0.8)
        bookButton.layer.shadowOpacity = 1
        bookButton.layer.cornerRadius = 25
        
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
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mScroll.contentSize = CGSize(width: 640, height: 300)
        retrieveInfo()
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
        let point = CGPoint(x: 320*sender.currentPage, y: 0)
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
        } else {
            //TODO:
            //Add a book
        }
    }
    
    @IBAction func menuFired(_ sender: UIButton) {
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
        vc.delegate = self
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.selectedItem = 1
        self.show(vc, sender: self)
    }
    
    //TODO:
    //Get users' info by using uid
    private func retrieveInfo() {
        //nameLabel.text = userInfo(uid).getFirstName + " " + userInfo(uid).getLastName
        //emailLabel.text = userInfo(uid).getEmail
        //collegeLabel.text = userInfo(uid).getCollege
        //addressLabel.text = userInfo(uid).getAddress
        //bid = userInfo(uid).getBook
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //conform to protocol menuviewcontrollerdelegate
    func menu(_ menu: MenuViewController, didSelectItemAt index: Int, at point: CGPoint) {
        switch index {
        case 0:
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            showMain()
        default:
            break
        }
    }
    
    func menuDidCancel(_ menu: MenuViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
                             source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return menuAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
    
    //go to the other vcs
    private func showMain() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Main")
        vc.modalTransitionStyle = .crossDissolve
        vc.view.layer.speed = 0.4
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //TODO:
    //Table View delegate for books
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identify: String = "bookCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identify)
        let mImage = cell?.viewWithTag(100) as! UIImageView? //photo of the book
        let mTitle = cell?.viewWithTag(101)
        let mAuthor = cell?.viewWithTag(102)
        let mPrice = cell?.viewWithTag(103)
        
        //TODO:
        //retrieve bookinfo by using book id
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
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
