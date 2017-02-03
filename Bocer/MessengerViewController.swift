//
//  MessengerViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/2/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class MessengerViewController: UIViewController {

    @IBOutlet weak var mNavItem: UINavigationItem!
    @IBOutlet weak var mTableView: UITableView!
    private let mNavBar = Constant().makeNavBar()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(mNavBar)
        mNavBar.pushItem(onMakeNavitem(), animated: true)
    }

    private func onMakeNavitem()->UINavigationItem{
        let mImage = UIImage(named: "cancel")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(MessengerViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        mNavItem.title = "Messenger"
        mNavItem.setLeftBarButton(btnItem, animated: true)
        return mNavItem
    }
    
    @objc private func didCancel() {
        self.dismiss(animated: true, completion: nil)
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
