//
//  FundingPostDetailViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: FundingPostDetailView Class
final class FundingPostDetailViewController: ViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var bottomInsetsView: UIView!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
  
  fileprivate var tableViewContentSizeObserver: NSKeyValueObservation?
  
  deinit {
    tableViewContentSizeObserver = nil
  }
  
  fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
    return gesture
  }()
  
  @IBAction func hideAction(_ sender: Any) {
    
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setBackgroundImageView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTableViewContentHidden(true, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let footer = UIView(frame: CGRect(origin: CGPoint.zero, size: bottomInsetsView.bounds.size))
    footer.backgroundColor = UIColor.white
    tableView.tableFooterView = footer
    setTableViewContentHidden(false, animated: true)
  }
}

//MARK: - FundingPostDetailView API
extension FundingPostDetailViewController: FundingPostDetailViewControllerApi {
  func performHideAnimation(_ complete: @escaping () -> Void) {
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      self?.setTableViewContentHidden(true, animated: false)
      self?.view.layoutIfNeeded()
    }) {(_) in
      complete()
    }
  }
  
  func reloadData() {
    tableView.reloadData()
  }
}

// MARK: - FundingPostDetailView Viper Components API
fileprivate extension FundingPostDetailViewController {
  var presenter: FundingPostDetailPresenterApi {
    return _presenter as! FundingPostDetailPresenterApi
  }
}


//MARK:- Helpers

extension FundingPostDetailViewController {
  fileprivate func setBackgroundImageView() {
    backgroundImageView.image = presentingViewController?.view.takeSnapshot()
  }
  
  @objc func tap(sender: UITapGestureRecognizer) {
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
        self?.setTableViewContentHidden(true, animated: false)
        self?.view.layoutIfNeeded()
    }) { [weak self] (_) in
      self?.presenter.handleHideAction()
    }
  }
  
  fileprivate func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableView.automaticDimension
    
    tableView.registerCell(FundingPostDetailTitleTableViewCell.self)
    tableView.registerCell(FundingPostDetailProgressTableViewCell.self)
    tableView.registerCell(FundingPostDetailTimeProgressTableViewCell.self)
    tableView.registerCell(FundingPostDetailContributorsTableViewCell.self)
    tableView.registerCell(FundingPostDetailTeamTableViewCell.self)
    tableView.registerCell(FundingPostDetailRewardsInfoTableViewCell.self)
    tableView.registerCell(FundingPostDetailFinishStatsTableViewCell.self)
    tableView.registerCell(FundingPostDetailCampaignFinishTableViewCell.self)
    tableView.registerCell(FundingPostDetailActionButtonTableViewCell.self)
    
    let backgroundView = UIView()
    backgroundView.frame = tableView.bounds
    backgroundView.addGestureRecognizer(tapGestureRecognizer)
    
    tableView.backgroundView = backgroundView
    
    tableViewContentSizeObserver = tableView.observe(\UITableView.contentSize, options: .old) { (object, observedChange) in 
     
      object.contentInset.top = max(0, object.bounds.height - object.contentSize.height)
      
    }
  }
  
  
  
  fileprivate func setupAppearance() {
    //tableView.contentInset.top = ceil(view.bounds.height * 0.25)
  }
  
  fileprivate func setTableViewContentHidden(_ hidden: Bool, animated: Bool) {
    let offset = hidden ? tableView.bounds.height : 0.0
    tableViewTopConstraint.constant = offset
    let dimViewAlpha: CGFloat = hidden ? 0.0 : 0.3
   
    guard animated else {
      dimView.alpha = dimViewAlpha
      return
    }
    
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      self?.dimView.alpha = dimViewAlpha
      self?.view.layoutIfNeeded()
    }) { (_) in }
  }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension FundingPostDetailViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.viewModelAt(indexPath)
    switch viewModel {
    case .title(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailTitleTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .progressStatus(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailProgressTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .timeProgressStatus(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailTimeProgressTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .contriibutorsInfo(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailContributorsTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .teamInfo(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailTeamTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.handleCellsActions($0, action: $1) }
      return cell
    case .rewardsInfo(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailRewardsInfoTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .finishStats(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailFinishStatsTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .finishCampaign(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailCampaignFinishTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .actionButton(let vm):
      let cell = tableView.dequeueReusableCell(cell: FundingPostDetailActionButtonTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.handleCellsActions($0, action: $1) }
      return cell
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {    
    if scrollView.contentOffset.y >= -scrollView.contentInset.top {
      scrollView.contentOffset.y = -scrollView.contentInset.top
    }
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView.contentOffset.y < -tableView.bounds.height * 0.3 {
      
      //we won't observe content size anymore, and force set inset as current offset to keep tableview in current state
      tableViewContentSizeObserver = nil
      tableView.contentInset.top = abs(scrollView.contentOffset.y)
      tableView.bounces = false
      tableView.alwaysBounceVertical = false
      
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
        self?.setTableViewContentHidden(true, animated: false)
        self?.view.layoutIfNeeded()
      }) { [weak self] (_) in
        self?.presenter.handleHideAction()
      }
    }
  }
}

//MARK:- Actions

extension  FundingPostDetailViewController {
  
  fileprivate func handleCellsActions(_ cell: UITableViewCell, action: FundingPostDetail.Actions) {
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleAction(action)
  }
}
