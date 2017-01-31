//
//  CommentViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/30/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

protocol  CommentDelegate: NSObjectProtocol {
    func fetchCommentBack(edition: String)
}

class CommentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var mComment: UITextView!
    
    internal weak var delegate: CommentDelegate?
    private let mNavBar = Constant().makeNavBar()
    internal var myInfo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        mComment.delegate = self
        if myInfo != nil {
            mComment.text = myInfo
            mLabel.alpha = 0
        }
    }

    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(CommentViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "finish")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(CommentViewController.didFinish), for: .touchUpInside)
        rightBtn.tintColor = UIColor.white
        let rightBtnItem = UIBarButtonItem(customView: rightBtn)
        
        mNavItem.title = "COMMENT"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        mNavItem.setRightBarButton(rightBtnItem, animated: true)
        return mNavItem
    }
    
    @objc private func didCancel() {
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func didFinish() {
        myInfo = mComment.text
        if delegate != nil {
            delegate?.fetchCommentBack(edition: myInfo!)
        }
        let transition = Constant().transitionFromLeft()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewClikced(_ sender: Any) {
        mComment.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        mLabel.alpha = 0
        return true
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
