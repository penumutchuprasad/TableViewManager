//
/*
 
 * LKStateManager
 * Created by: Leela Prasad on 16/11/18
 
 * Copyright © 2018 Leela Prasad. All rights reserved.
 * All rights have been granted for free of use for any project in SecNinjaz
 
 */

import UIKit

class LKTVC: UITableViewController {
  
  struct Profile {
    var name: String
  }
  
  var tabView: LKTableView! {
    
    return (tableView as! LKTableView)
  }

  var names = [Profile]()
  
  private let cellId = "UITableViewCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tabView.stateManagerDelegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabView.frame = tableView.frame
    tabView.bounds = tableView.frame
    self.names.removeAll()
    //self.tabView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    simulateNetworkCall()
    
  }
  
  func simulateNetworkCall() {
    
    tabView.setStateAs(.loading)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.tabView.setStateAs(.error(NSError(domain: "Sample111 error", code: 555, userInfo: nil), #imageLiteral(resourceName: "info")))
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.tabView.setStateAs(.loading)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      self.tabView.setStateAs(.error(NSError(domain: "Sample222 error", code: 555, userInfo: nil), #imageLiteral(resourceName: "coin")))
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
      self.tabView.setStateAs(.empty("Please wait for some time", #imageLiteral(resourceName: "plus")))
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
      for k in 0..<100 {
        self.names.append(Profile(name: "NBK\(k)"))
      }
      self.tabView.setStateAs(.populated)
    }
    
  }
  
}


extension LKTVC: LKTableViewStateManagerDelegate {
  
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
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return names.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tabView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.textLabel?.text = names[indexPath.row].name
    return cell
  }
  
}
