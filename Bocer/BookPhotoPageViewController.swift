//
//  BookPhotoPageViewController.swift
//  Bocer
//
//  Created by Dempsy on 2/22/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit

class BookPhotoPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    internal var startIndex = 0
    internal var images: [UIImage]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: startIndex)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        onMakeNavitem()
        
        //增加右滑返回
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
    }

    private func onMakeNavitem(){
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(BookPhotoPageViewController.didCancel), for: .touchUpInside)
        btn.tintColor = .white
        let btnItem = UIBarButtonItem(customView: btn)
        
        navigationItem.title = "Photos  \(startIndex + 1)/\((images?.count)!)"
        navigationItem.leftBarButtonItem = btnItem
    }
    
    @objc private func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> BookPhotoPageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let sb = UIStoryboard(name: "new-Qian", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookPhotoPageContent") as! BookPhotoPageContentViewController
        vc.index = index
        vc.photo = images?[index]
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: BookPhotoPageContentViewController = viewController as! BookPhotoPageContentViewController
        var index = pageContent.index
        navigationItem.title = "Photos \(index + 1)/\((images?.count)!)"

        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }

        index -= 1
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: BookPhotoPageContentViewController = viewController as! BookPhotoPageContentViewController
        var index = pageContent.index
        navigationItem.title = "Photos \(index + 1)/\((images?.count)!)"

        if (index == NSNotFound)
        {
            return nil;
        }

        index += 1;
        if (index == images?.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
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
