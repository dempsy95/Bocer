//
//  EditEditionViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/23/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class EditEditionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var mTextView: UITextView!
    @IBOutlet weak var mLabel: UILabel!
    internal var bookID: String?
    private var book: Book?
    private var myEdition: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onMakeNavitem()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        book = BookInfoHelper().getBookInfo(bookID: bookID!)
        myEdition = Int((book?.edition)!)
        
        mTextView.delegate = self
        if myEdition != nil {
            mTextView.text = String(format: "%d", myEdition!)
            mTextView.becomeFirstResponder()
        }
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        mLabel.alpha = 0
        return true
    }
    
    @IBAction func viewClicked(_ sender: UIView) {
        mTextView.resignFirstResponder()
    }
    
    //customize navigation item
    private func onMakeNavitem(){
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(EditEditionViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        
        let mRightImage = UIImage(named: "finish")
        let rightBtn = UIButton(frame: CGRect(x: self.view.bounds.maxX - 55, y: 30, width: 20, height: 20))
        rightBtn.setImage(mRightImage, for: .normal)
        rightBtn.addTarget(self, action: #selector(EditEditionViewController.didFinish), for: .touchUpInside)
        rightBtn.tintColor = UIColor.white
        let rightBtnItem = UIBarButtonItem(customView: rightBtn)
        
        navigationItem.title = "EDIT EDITION"
        navigationItem.leftBarButtonItem = btnItem
        navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didFinish() {
        myEdition = Int(mTextView.text)
        if myEdition == nil {
            let alertController = UIAlertController(title: "Woops!", message: "Edition cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            BookInfoHelper().updateBookEdition(book: book!, edition: myEdition!)
            self.navigationController?.popViewController(animated: true)
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
