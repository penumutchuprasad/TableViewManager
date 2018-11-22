//LKKKVC.swift
/*
 * LKStateManager
 * Created by penumutchu.prasad@gmail.com on 22/11/18
 * Is a product created by SecNinjaz
 * For the LKStateManager in the LKStateManager
 
 * Here the permission is granted to this file with free of use anywhere in the IOS Projects.
 * Copyright © 2018 ABNBoys.com All rights reserved.
*/

import UIKit

class LKKKVC: UIViewController {
    
    struct Profile {
        var name: String
    }
    
    @IBOutlet var tableView: LKTableView!
    
    
    var names = [Profile]()
    
    private let cellId = "LKCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.stateManagerDelegate = self
        // tabView.setDatasource(names)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.names.removeAll()
        //self.tabView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        simulateNetworkCall()
        
    }
    
    func simulateNetworkCall() {
        
        tableView.setStateAs(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.setStateAs(.error(NSError(domain: "Sample111 error", code: 555, userInfo: nil), #imageLiteral(resourceName: "info")))
        }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              self.tableView.setStateAs(.loading)
            }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
              self.tableView.setStateAs(.error(NSError(domain: "Sample222 error", code: 555, userInfo: nil), #imageLiteral(resourceName: "coin")))
            }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
              self.tableView.setStateAs(.empty("Please wait for some time", #imageLiteral(resourceName: "plus")))
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            for k in 0..<100 {
                self.names.append(Profile(name: "NTR\(k)"))
            }
            self.tableView.setStateAs(.populated)
        }
        
    }
    
}

extension LKKKVC: UITableViewDelegate, UITableViewDataSource, LKTableViewStateManagerDelegate {
    
    func tableViewDidSelectRetryButton(_ tableView: LKTableView, _ state: LKTableView.State) {
        
        let alert = UIAlertController.init(title: "Retry", message: "Retry......", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableViewStateDidChange(_ tableView: LKTableView, fromState from: LKTableView.State, toNewState: LKTableView.State) {
        print("TabView state changed from \(from.title) to \(toNewState.title)")
    }
    
    func tableViewDidRefreshToThePreviousState(_ tableView: LKTableView, _ state: LKTableView.State) {
        print("It goes back to the previous state as \(state.title)")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = names[indexPath.row].name
        return cell
    }
    
}
