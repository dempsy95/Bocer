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

class MessengerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var mTableView: UITableView!

    internal var messages : [Message]?
    private var people = [NSManagedObject]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onMakeNavitem()
        
        //tableview UITableViewDelegate
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.tableFooterView = UIView()
        mTableView.tableFooterView?.isHidden = true
        
        //delegate the gesture recognizer
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messages = DatabaseHelper().loadData()
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
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify: String = "ChatCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify)

        let mImage = cell?.viewWithTag(100) as! UIImageView?
        mImage?.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        let mName = cell?.viewWithTag(101) as! UILabel?
        let mMessage = cell?.viewWithTag(102) as! UILabel?
        let mTime = cell?.viewWithTag(103) as! UILabel?
        
        //date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        //for loading info
        let message = messages?[indexPath.item]
        mName?.text = message?.friend?.name
        mImage?.image = UIImage(named: (message?.friend?.profileImageName)!)
        mMessage?.text = message?.text
        mTime?.text = String(describing: dateFormatter.string(from: (message?.date)! as Date))
        
        //set text attributes for read message
        if message?.hasRead == false {
            mName?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
            mMessage?.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
        } else {
            mName?.font = UIFont(name: "HelveticaNeue", size: 15)
            mMessage?.font = UIFont(name: "HelveticaNeue", size: 13)
        }
        
        return cell!
        
        //TODO:
        //Make the name of friend bold if there is/are unread message(s)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatView = ChatViewController()
//        chatView.messages = makeNormalConversation()
        let friend = messages?[indexPath.item].friend
        chatView.myUserID = "someid"
        chatView.myDisplayName = friend?.name
        chatView.friend = friend
//        let chatNavigationController = UINavigationController(rootViewController: chatView)
//        present(chatNavigationController, animated: true, completion: nil)
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            DatabaseHelper().deleteFriend(id: (messages?[indexPath.item].friend?.id)!)
            messages = DatabaseHelper().loadData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    //TODO:
//    private func makeNormalConversation() -> [JSQMessage] {
//        let message = JSQMessage(senderId: "SomeSenderIDforHsunLu", displayName: "Lu Hsun", text: "Hello")
//        let conversation = [message]
//        return conversation as! [JSQMessage]
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //helper method to test functionality

}
