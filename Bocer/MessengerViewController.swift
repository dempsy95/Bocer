//
//  MessengerViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/2/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import CoreData
import JSQMessagesViewController

class MessengerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!

    private var people = [NSManagedObject]()
    
    private var messengerNumber: Int? = 5 //number for table view
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onMakeNavitem()
        
        //tableview UITableViewDelegate
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.tableFooterView = UIView()
        mTableView.tableFooterView?.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mTableView.reloadData()
    }

    private func onMakeNavitem(){
        let mImage = UIImage(named: "cancel")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(MessengerViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        navigationItem.title = "Messenger"
        navigationItem.leftBarButtonItem = btnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messengerNumber!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify: String = "ChatCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify)

        let mImage = cell?.viewWithTag(100) as! UIImageView?
        mImage?.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        let mName = cell?.viewWithTag(101) as! UILabel?
        let mMessage = cell?.viewWithTag(102) as! UILabel?
        let mTime = cell?.viewWithTag(103) as! UILabel?
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatView = ChatViewController()
        chatView.messages = makeNormalConversation()
        chatView.myUserID = "SomeIDForUser"
        chatView.myDisplayName = "Lu Hsun"
//        let chatNavigationController = UINavigationController(rootViewController: chatView)
//        present(chatNavigationController, animated: true, completion: nil)
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO:
    private func makeNormalConversation() -> [JSQMessage] {
        let message = JSQMessage(senderId: "SomeSenderIDforHsunLu", displayName: "Lu Hsun", text: "Hello")
        let conversation = [message]
        return conversation as! [JSQMessage]
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
