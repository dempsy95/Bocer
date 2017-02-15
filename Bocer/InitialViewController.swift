//
//  InitialViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/15/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set button corner radius
        signIn.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        signUp.layer.cornerRadius = CGFloat(Constant().buttonCornerRadius)
        
        //delegate gesture recognizer
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
        
        //hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
        //隐藏导航栏
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func signInFired(_ sender: UIButton) {
        let sb = UIStoryboard(name: "new-Qian", bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: "Login") as UIViewController
        //self.push(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func signUpFired(_ sender: UIButton) {
        let sb = UIStoryboard(name: "new-Qian", bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: "Signup1") as UIViewController
        //self.push(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (self.navigationController?.viewControllers.count)! == 1 {
            return false
        } else {
            return true
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
