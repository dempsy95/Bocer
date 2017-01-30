//
//  EditionViewController.swift
//  Bocer
//
//  Created by Dempsy on 1/29/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

protocol  EditionDelegate: NSObjectProtocol {
    func fetchEditionBack(edition: String)
}

class EditionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var edition: SkyFloatingLabelTextFieldWithIcon!

    internal weak var delegate: EditionDelegate?
    private let mNavBar = Constant().makeNavBar()
    internal var myEdition: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        edition.delegate = self
        edition.title = "Edition Number"
        edition.iconFont = UIFont(name: "FontAwesome", size: 20)
        edition.iconText = "\u{f187}"
        Constant().customizeSFLTextField(tf: edition)
        if myEdition != nil {
            edition.text = myEdition
        }        
    }
    
    @IBAction func viewClicked(_ sender: UIView) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //customize navigation item
    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(EditionViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "finish")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(EditionViewController.didFinish), for: .touchUpInside)
        rightBtn.tintColor = UIColor.white
        let rightBtnItem = UIBarButtonItem(customView: rightBtn)
        
        mNavItem.title = "EDITION"
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
        myEdition = edition.text
        if myEdition == nil {
            let alertController = UIAlertController(title: "Woops!", message: "Edition cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if delegate != nil {
                delegate?.fetchEditionBack(edition: myEdition!)
            }
            let transition = Constant().transitionFromLeft()
            view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false, completion: nil)
        }
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
