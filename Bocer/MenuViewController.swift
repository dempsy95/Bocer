//
//  MenuViewController.swift
//  mealplanappiOS
//
//  Created by Dempsy on 1/18/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit
import SideMenu
import QuartzCore

protocol MenuViewControllerDelegate: class {
    
    func menu(_ menu: MenuViewController, didSelectItemAt index: Int, at point: CGPoint)
    func menuDidCancel(_ menu: MenuViewController)
}


class MenuViewController: UITableViewController, Menu, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var mButton: UIButton!
    @IBOutlet weak var mainTVC: UITableViewCell!
    @IBOutlet weak var settingTVC: UITableViewCell!
    @IBOutlet weak var chatTVC: UITableViewCell!
    @IBOutlet weak var historyTVC: UITableViewCell!
    @IBOutlet weak var payTVC: UITableViewCell!
    @IBOutlet weak var profileTVC: UITableViewCell!
    weak var delegate: MenuViewControllerDelegate?
    var selectedItem = 0

    var menuItems: [UIView] {
        return [tableView.tableHeaderView!] + tableView.visibleCells
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Do any additional setup after loading the view.
        let bgColor = UIView()
        bgColor.backgroundColor = UIColor(red: 200/255, green: 48/255, blue: 99/255, alpha: 1)
        mainTVC.selectedBackgroundView = bgColor
        settingTVC.selectedBackgroundView = bgColor
        chatTVC.selectedBackgroundView = bgColor
        historyTVC.selectedBackgroundView = bgColor
        payTVC.selectedBackgroundView = bgColor
        profileTVC.selectedBackgroundView = bgColor
        print("selectedItem is \(selectedItem)")
        self.preferredContentSize = CGSize(width: 125, height: 667)
        let indexPath = IndexPath(row: selectedItem, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        self.tableView.delegate?.tableView!(self.tableView, didSelectRowAt: indexPath)
        print("index path is \(indexPath)")
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowOffset = CGSize.zero
        tableView.layer.shadowRadius = 2.5
    }

    @IBAction func dismissMenu(_ sender: UIButton) {
        print("button clicked")
        delegate?.menuDidCancel(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Menu closed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath == tableView.indexPathForSelectedRow ? nil : indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rect = tableView.rectForRow(at: indexPath)
        var point = CGPoint(x: rect.midX, y: rect.midY)
        point = tableView.convert(point, to: nil)
        delegate?.menu(self, didSelectItemAt: indexPath.row, at: point)
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
