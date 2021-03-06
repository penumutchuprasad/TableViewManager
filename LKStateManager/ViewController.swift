//
/*
 
 * LKStateManager
 * Created by: Leela Prasad on 14/11/18
 
 * Copyright © 2018 Leela Prasad. All rights reserved.
 * All rights have been granted for free of use for any project in SecNinjaz
 
 */

import UIKit

class ViewController: UIViewController {

  struct Profile {
    var name: String
  }
  
  @IBOutlet weak var tabView: LKTableView!
  
  var names = [Profile]()
  
  private let cellId = "UITabCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
    tabView.delegate = self
    tabView.dataSource = self
    tabView.stateManagerDelegate = self
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
    
    tabView.setStateAs(.loading)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.tabView.setStateAs(.error(NSError(domain: "Sample111 error", code: 555, userInfo: nil), #imageLiteral(resourceName: "info")))
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.tabView.setStateAs(.loading)
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      self.tabView.setStateAs(.error(NSError(domain: "Sample222 error", code: 555, userInfo: nil), #imageLiteral(resourceName: "coin")))
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
      self.tabView.setStateAs(.empty("Please wait for some time", #imageLiteral(resourceName: "plus")))
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
      for k in 0..<100 {
        self.names.append(Profile(name: "NTR\(k)"))
      }
      self.tabView.setStateAs(.populated)
    }
    
  }
  
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, LKTableViewStateManagerDelegate {
  
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
    
    let cell = tabView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.textLabel?.text = names[indexPath.row].name
    return cell
  }
  
}
