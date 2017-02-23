//
//  BookPhotoPageContentViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/22/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class BookPhotoPageContentViewController: UIViewController {

    @IBOutlet weak var mImageView: UIImageView!
    internal var index = 0
    internal var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mImageView.image = photo
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
