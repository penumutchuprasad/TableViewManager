//TodayViewController.swift
/*
 * State Today
 * Created by penumutchu.prasad@gmail.com on 20/11/18
 * Is a product created by SecNinjaz
 * For the State Today in the LKStateManager
 
 * Here the permission is granted to this file with free of use anywhere in the IOS Projects.
 * Copyright © 2018 ABNBoys.com All rights reserved.
*/

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    var coins = ["BTC", "ETH", "BCH"]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.preferredContentSize.height = CGFloat(self.coins.count * 60)
        self.view.layoutIfNeeded()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        tableViewHeightConstraint.constant = CGFloat(Double(coins.count) * 60.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if activeDisplayMode == .compact {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 200)
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = maxSize
        }
        
        tableView.reloadData()
    }
    
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var size = self.preferredContentSize
        size.height = CGFloat(self.coins.count * 60)
        self.preferredContentSize = size
        
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WidgetCell.cellId, for: indexPath) as! WidgetCell
        cell.textLabel?.text = coins[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected coin is \(coins[indexPath.row])")
    }
}

class WidgetCell: UITableViewCell {
    
    static let cellId = "WidgetCell"
    
}
