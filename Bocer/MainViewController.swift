//
//  MainViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/16/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, MenuViewControllerDelegate {

    fileprivate var selectedIndex = 0
    fileprivate var transitionPoint: CGPoint!
    private let mNavBar = Constant().makeNavBar()
    private var leftSwipe: UIPanGestureRecognizer?
    private var percent: UIPercentDrivenInteractiveTransition?
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //customize status bar
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        //customize and delegate table view
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    //Table View Functions
    //MARK: - Tableview Delegate & Datasource
    //Cell numbers for each section
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier="Cell";
        let cell=tableView.dequeueReusableCell(withIdentifier: identifier);
        let mImage = cell?.viewWithTag(100) as! UIImageView?
        let mAvatar = cell?.viewWithTag(101) as! UIImageView?
        let mView = cell?.viewWithTag(99)
        let mTitle = cell?.viewWithTag(1) as! UILabel?
        let mAuthor = cell?.viewWithTag(2) as! UILabel?
        let mComment = cell?.viewWithTag(3) as! UILabel?
        let mPublisher = cell?.viewWithTag(4) as! UILabel?
        let mRate = cell?.viewWithTag(5) as! UIImageView?
        mAvatar?.layer.cornerRadius = 30
        mAvatar?.layer.masksToBounds = true
        
        mImage?.image = UIImage(named: "book_image")
        mAvatar?.image = UIImage(named: "sample_avatar")
        //TODO:
        //need a class get bookinfo to retrieve all the info about a book
        //getBookinfo(bookID).image
        //getBookinfo(bookID).seller
        //getBookinfo(bookID).title
        //getBookinfo(bookID).author
        //getBookinfo(bookID).publisher
        //getBookinfo(bookID).comment
        //getBookinfo(bookID).rate
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    //customize navigation item
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "menu_icon")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 25, height: 25))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(MainViewController.openSlideMenu), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        mNavItem.title = "BOCER"
        mNavBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Chalkduster", size: 25)!, NSForegroundColorAttributeName: UIColor.white]
        mNavItem.setLeftBarButton(btnItem, animated: true)
        return mNavItem
    }
    
    @objc private func openSlideMenu() {
        print("slide menu opened")
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
        vc.delegate = self
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.selectedItem = 0
        self.show(vc, sender: self)
    }
    
    
    //conform to protocol menuviewcontrollerdelegate
    func menu(_ menu: MenuViewController, didSelectItemAt index: Int, at point: CGPoint) {
        switch index {
        case 1:
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            showProfile()
            break
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
    
    @IBAction func viewClicked(_ sender: UIView) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showProfile() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Profile") 
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)

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


