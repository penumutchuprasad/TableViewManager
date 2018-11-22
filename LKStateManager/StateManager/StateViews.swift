
import UIKit

//MARK: Error State

class ErrorStateView: UIView {
  
  var imgView: UIImageView = {
    
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  var titleLabel: UILabel = {
    
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.font = UIFont.boldSystemFont(ofSize: 15)
    lbl.textAlignment = .center
    lbl.sizeToFit()
    return lbl
  }()
  
  var descriptionLabel: UILabel = {
    
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.font = UIFont.systemFont(ofSize: 16)
    lbl.textAlignment = .center
    lbl.numberOfLines = 0
    lbl.sizeToFit()
    return lbl
  }()
  
  lazy var retryButton: UIButton = {
    
    let btn = UIButton.init(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    btn.setTitle("Re Try", for: .normal)
    btn.layer.cornerRadius = 5.0
    btn.layer.masksToBounds = true
    btn.addTarget(self, action: #selector(onRetryButtonPressed(_:)), for: .touchUpInside)
    btn.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    return btn
  }()
  
  @objc func onRetryButtonPressed(_ sender: UIButton) {
    
    self.onRetry?()
  }
  
  var onRetry: (() -> ())?
  
  convenience init(with state: LKTableView.State) {
    self.init()
    self.state = state

  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupViews()
  }
  
  override var bounds: CGRect {
    didSet{
      self.setNeedsDisplay()
      self.layoutIfNeeded()
    }
  }
  
  var state: LKTableView.State! {
    didSet{
      DispatchQueue.main.async {
        
        self.titleLabel.text = self.state.title
        self.descriptionLabel.text = self.state.subDescription
        if let img = self.state.icon {
          self.imgView.image = img
        }
      }
    }
  }
    
    private var navBarHeight: CGFloat = 0
    
    override func didMoveToWindow() {
        if let win = self.window {

            if let currentVC = win.visibleViewController() as? UITableViewController {
                if let _ = currentVC.navigationController?.navigationBar {
                    navBarHeight = (120) * -1 //Including Status bar
                    self.frame = currentVC.tableView.frame
                    self.layoutIfNeeded()
                }
            }

        }
    }
  
  func setupViews() {
    
    addSubview(imgView)
    addSubview(titleLabel)
    addSubview(descriptionLabel)
    addSubview(retryButton)
    
    addConstraints([
      
      //ImageView
      imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 120),
      imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
      imgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
      
      //Title
      titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16),
      titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
      titleLabel.heightAnchor.constraint(equalToConstant: 25),
      
      //Description
      descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      descriptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
      descriptionLabel.bottomAnchor.constraint(equalTo: self.retryButton.topAnchor, constant: -20),

      //Retry Button
      retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      retryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
      retryButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
      retryButton.heightAnchor.constraint(equalToConstant: 50),
    
      ])
   
//    descriptionLabel.setContentCompressionResistancePriority(.init(899), for: .vertical)
    titleLabel.setContentHuggingPriority(.init(987), for: .vertical)
    descriptionLabel.setContentHuggingPriority(.init(200), for: .vertical)

    retryButton.setContentHuggingPriority(.init(980), for: .vertical)
    retryButton.setContentCompressionResistancePriority(.init(900), for: .vertical)
    
  }
  
}

//MARK: Empty State

class EmptyStateView: UIView {
  
  var imgView: UIImageView = {
    
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  var titleLabel: UILabel = {
    
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.font = UIFont.boldSystemFont(ofSize: 15)
    lbl.textAlignment = .center
    lbl.sizeToFit()
    return lbl
  }()
  
  var descriptionLabel: UILabel = {
    
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.font = UIFont.systemFont(ofSize: 16)
    lbl.textAlignment = .center
    lbl.numberOfLines = 0
    lbl.sizeToFit()
    return lbl
  }()
  
  convenience init(with state: LKTableView.State) {
    self.init()
    self.state = state
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupViews()
  }
  
  override var bounds: CGRect {
    didSet{
      self.setNeedsDisplay()
      self.layoutIfNeeded()
    }
  }
  
  var state: LKTableView.State! {
    didSet{
      DispatchQueue.main.async {
        
        self.titleLabel.text = self.state.title
        self.descriptionLabel.text = self.state.subDescription
        if let img = self.state.icon {
          self.imgView.image = img
        }
        
      }
    }
  }
    
  func setupViews() {
    
    addSubview(imgView)
    addSubview(titleLabel)
    addSubview(descriptionLabel)
    
    addConstraints([
      
      //ImageView
      imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 120),
      imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
      imgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
      
      //Title
      titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16),
      titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
      //      titleLabel.heightAnchor.constraint(equalToConstant: 35),
      
      //Description
      descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      descriptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
      descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
      
      ])
    
    //    descriptionLabel.setContentCompressionResistancePriority(.init(899), for: .vertical)
    titleLabel.setContentHuggingPriority(.init(987), for: .vertical)
    descriptionLabel.setContentHuggingPriority(.init(200), for: .vertical)

  }
  
}

//MARK: To show spinner for Loading...
class SpinnerView: UIView {

  private var spinner: UIActivityIndicatorView = {

    let indicator = UIActivityIndicatorView.init(style: .whiteLarge)
    indicator.backgroundColor = .white
    indicator.color = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    indicator.hidesWhenStopped = true
    return indicator
  }()

  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setupViews()
  }

  override var bounds: CGRect {
    didSet{
      setFrame()
    }
  }

  func setFrame() {
    spinner.center = self.center
    layoutIfNeeded()
  }

  private func setupViews() {

    addSubview(spinner)
    setFrame()
    spinner.startAnimating()
  }

  override func didMoveToSuperview() {
    spinner.startAnimating()
  }

}
