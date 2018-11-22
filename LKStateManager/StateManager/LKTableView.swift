//
/*
 
 * LKStateManager
 * Created by: Leela Prasad on 15/11/18
 
 * Copyright © 2018 Leela Prasad. All rights reserved.
 * All rights have been granted for free of use for any project in SecNinjaz
 
 */

import UIKit

protocol LKTableViewStateManagerDelegate {
  
  /** A delegate to be called upon state change occures */
  func tableViewStateDidChange(_ tableView: LKTableView, fromState from: LKTableView.State, toNewState: LKTableView.State)
  
  /** gives some state info when it refreshes to the same previos state
   * Could be used to stop hitting the servers in order to save battery, power, data etc
   */
  func tableViewDidRefreshToThePreviousState(_ tableView: LKTableView, _ state: LKTableView.State)
  
  /** A delegate to be called upon Retry button pressed */
  func tableViewDidSelectRetryButton(_ tableView: LKTableView, _ state: LKTableView.State)

}

fileprivate protocol StateProtocol {
  var title: String {get}
  var subDescription: String {get}
  var icon: UIImage? {get}
}

open class LKTableView: UITableView {
  
  enum State: StateProtocol {
    
    case loading
    case error(Error, UIImage?)
    case empty(String, UIImage?)
    case populated
    
    var title: String {
      switch self {
      case .loading:
        return "is loading"
      case .error(_):
        return "Something went wrong"
      case .empty:
        return "No data"
      default:
        return "data is populated"
      }
    }
    
    var subDescription: String {
      switch self {
      case .error(let err, _):
        return err.localizedDescription
      case .empty(let reasn, _):
        return reasn
      default:
        return ""
      }
    }
    
    var icon: UIImage? {
      switch self {
      case .empty(_, let img):
        return img
      case .error(_, let img):
        return img
      default:
        return nil
      }
    }
    
    //Methods
    static func ==(fromState: State, newState: State) -> Bool {
      
      switch (fromState, newState) {
      case (let s1, let s2) where s1.title == s2.title:
        return true
      default:
        return false
      }
    }
    
  }
 
  var stateManagerDelegate: LKTableViewStateManagerDelegate?
  
  /** To get the current state of the tableView */
  private(set) var state = State.loading
  
  /** Sets a new state for the tableView and reloads its data */
  func setStateAs(_ state: State) {
    
    //This way when it loads to the previos state, no need to reload and by pass this condition
    if self.state == state {
      if self.state == .loading {
        if state == .loading {
          self.refreshTableFooterView(with: state)
          return
        }
        
      }
      DispatchQueue.main.async {
        self.refreshTableFooterView(with: state)
        self.stateManagerDelegate?.tableViewDidRefreshToThePreviousState(self, self.state)
        return
      }
    } else {
      
      DispatchQueue.main.async {
       
        self.stateManagerDelegate?.tableViewStateDidChange(self, fromState: self.state, toNewState: state)
        self.state = state
        self.refreshTableFooterView(with: state)
        self.reloadData()
      }
      
    }

  }
  
  //Intiallisers
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    
    addSpinnerToTheView()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    
    addSpinnerToTheView()
  }
  
  func addSpinnerToTheView() {
    
    self.tableFooterView = loadingView
  }
  
  override open var bounds: CGRect {
    didSet{
     
    }
  }
    
    private func getAppDelegate() -> AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }
  
  private(set) lazy var loadingView = SpinnerView.init()
  private(set) lazy var errorView = ErrorStateView.init()
  private(set) lazy var emptyView = EmptyStateView.init()

  private func refreshTableFooterView(with state: State) {
    
    var padding: CGFloat = 0
    var isTabVC = false
    
    if let currentVisibleVC = self.getAppDelegate().window?.visibleViewController() {
    
        padding = currentVisibleVC.navigationController?.navigationBar.frame.maxY ?? 0
        
        if let tabVC = currentVisibleVC as? UITableViewController {
            padding = tabVC.navigationController?.navigationBar.frame.maxY ?? 0
            if let navRootVC = currentVisibleVC.navigationController?.viewControllers.first {
                if navRootVC == currentVisibleVC {
                    padding = 0
                } else {
                    padding = currentVisibleVC.navigationController?.navigationBar.frame.maxY ?? 0
                    padding = padding * 2 //- 20
                }
            }
            isTabVC = true
        } else if let navRootVC = currentVisibleVC.navigationController?.viewControllers.first {
            if navRootVC == currentVisibleVC {
                padding = 0
            } else {
                padding = currentVisibleVC.navigationController?.navigationBar.frame.maxY ?? 0
            }
        }
        
    }
    
    padding = isTabVC ? padding / 2 : padding
    print("padding is \(padding)")
    
    switch state {
    case .loading:
      DispatchQueue.main.async {
        self.tableFooterView = self.loadingView
        self.loadingView.frame = self.frame.insetBy(dx: 0, dy: padding)
        self.loadingView.bounds = isTabVC ? self.frame.insetBy(dx: 0, dy: padding * 2) : self.frame
      }
      
    case .error(_):
      DispatchQueue.main.async {
        self.errorView.state = state
        self.errorView.onRetry = { [unowned self] in
          self.stateManagerDelegate?.tableViewDidSelectRetryButton(self, state)
        }
        self.tableFooterView = self.errorView
        self.errorView.frame = self.frame.insetBy(dx: 0, dy: padding)
        self.errorView.bounds = isTabVC ? self.frame.insetBy(dx: 0, dy: padding / 2) : self.frame
      }
      
    case .empty(_):
      DispatchQueue.main.async {
        self.emptyView.state = state
        self.tableFooterView = self.emptyView
        self.emptyView.frame = self.frame.insetBy(dx: 0, dy: padding)
        self.emptyView.bounds = isTabVC ? self.frame.insetBy(dx: 0, dy: padding / 2) : self.frame
      }
    default:
      self.tableFooterView = nil
    }
   
    self.reloadData()
  }
  
}
