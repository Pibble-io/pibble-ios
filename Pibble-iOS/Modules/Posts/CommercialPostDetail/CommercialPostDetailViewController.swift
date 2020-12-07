//
//  CommercialPostDetailViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: CommercialPostDetailView Class
final class CommercialPostDetailViewController: ViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  
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
    setTableViewContentHidden(false, animated: true)
  }
}

//MARK: - CommercialPostDetailView API
extension CommercialPostDetailViewController: CommercialPostDetailViewControllerApi {
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

// MARK: - CommercialPostDetailView Viper Components API
fileprivate extension CommercialPostDetailViewController {
  var presenter: CommercialPostDetailPresenterApi {
    return _presenter as! CommercialPostDetailPresenterApi
  }
}


//MARK:- Helpers

extension CommercialPostDetailViewController {
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
    
    tableView.registerCell(CommercialPostDetailLicensingTableViewCell.self)
    tableView.registerCell(CommercialPostDetailAgreementTableViewCell.self)
    tableView.registerCell(CommercialPostDetailMessageButtonTableViewCell.self)
    tableView.registerCell(CommercialPostDetailCheckoutTableViewCell.self)
    
    tableView.registerCell(CommercialPostDetailDescriptionTableViewCell.self)
    
    tableView.registerCell(CommercialPostDetailDigitalGoodUsageInfoTableViewCell.self)
    
    tableView.registerCell(CommercialPostDetailGoodsInfoTableViewCellTableViewCell.self)
    tableView.registerCell(CommercialPostDetailGoodsDescriptionTableViewCell.self)
    
    tableView.registerCell(CommercialPostDetailGoodsUsageInfoTableViewCell.self)
    
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

extension CommercialPostDetailViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.viewModelAt(indexPath)
    switch viewModel {
    case .description(let vm):
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailDescriptionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .licensing(let vm):
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailLicensingTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .agreement(let vm):
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailAgreementTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleCellsActions)
      return cell
    case .messages:
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailMessageButtonTableViewCell.self, for: indexPath)
      cell.setViewModel(handler: handleCellsActions)
      return cell
    case .checkout(let vm):
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailCheckoutTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleCellsActions)
      return cell
    case .goodsDescription(let vm):
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailGoodsDescriptionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .goodsInfo(let vm):
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailGoodsInfoTableViewCellTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleCellsActions)
      return cell
    case .digitalGoodsUsageInfo:
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailDigitalGoodUsageInfoTableViewCell.self, for: indexPath)
      return cell
    case .goodsEscrowInfo:
      let cell = tableView.dequeueReusableCell(cell: CommercialPostDetailGoodsUsageInfoTableViewCell.self, for: indexPath)
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

extension  CommercialPostDetailViewController {
  fileprivate func handleCellsActions(_ cell: UITableViewCell, action: CommercialPostDetail.Actions) {
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleAction(action)
  }
}
