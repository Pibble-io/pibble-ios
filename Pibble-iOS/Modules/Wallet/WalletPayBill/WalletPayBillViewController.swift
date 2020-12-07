//
//  WalletPayBillViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletPayBillView Class
final class WalletPayBillViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var placeholderView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var walletProfileHeaderView: WalletProfileHeaderView!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBOutlet weak var profileHeaderViewHeight: NSLayoutConstraint!
  
  //MARK:- Private Properties
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var animating = false
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
}

//MARK: - WalletPayBillView API
extension WalletPayBillViewController: WalletPayBillViewControllerApi {
  func setInteractionEnabled(_ enabled: Bool) {
    tableView.visibleCells.forEach { $0.isUserInteractionEnabled = enabled }
  }
 
  func setPlaceholderHidden(_ hidden: Bool, animated: Bool) {
    guard animated else {
      placeholderView.alpha = hidden ? 0.0 : 1.0
      tableView.alpha = !hidden ? 0.0 : 1.0
      return
    }
    
    guard !animating else {
      return
    }
    
    animating = true
    UIView.animate(withDuration: 0.15, animations: {
      [weak self] in
      
      self?.placeholderView.alpha = hidden ? 0.0 : 1.0
      self?.tableView.alpha = !hidden ? 0.0 : 1.0
    }) { [weak self] (_) in
      self?.animating = false
    }
  }
  
  func setProfile(_ vm: WalletProfileHeaderViewModelProtocol?) {
    walletProfileHeaderView.setViewModel(vm)
    
    profileHeaderViewHeight.constant = vm == nil ? UIConstants.Constraints.headerViewMinHeight :
      UIConstants.Constraints.headerViewMaxHeight
    guard vm != nil else {
      return
    }
    
    guard isBeingPresented else {
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }
  
  func reloadData() {
    tableView.reloadData()
  }
  
  func updateCollection(_ updates: CollectionViewModelUpdate) {
    if case CollectionViewModelUpdate.reloadData = updates {
      batchUpdates = []
      tableView.reloadData()
      return
    }
    
    guard case CollectionViewModelUpdate.endUpdates = updates else {
      batchUpdates.append(updates)
      return
    }
    
    tableView.beginUpdates()
    batchUpdates.forEach {
      switch $0 {
      case .reloadData:
        break
      case .beginUpdates:
        break
      case .endUpdates:
        break
      case .insert(let idx):
        tableView.insertRows(at: idx, with: .fade)
      case .delete(let idx):
        tableView.deleteRows(at: idx, with: .fade)
      case .insertSections(let idx):
        tableView.insertSections(IndexSet(idx), with: .fade)
      case .deleteSections(let idx):
        tableView.deleteSections(IndexSet(idx), with: .fade)
      case .updateSections(let idx):
        tableView.reloadSections(IndexSet(idx), with: .fade)
      case .moveSections(let from, let to):
        tableView.moveSection(from, toSection: to)
      case .update(let idx):
        tableView.reloadRows(at: idx, with: .fade)
      case .move(let from, let to):
        tableView.moveRow(at: from, to: to)
      }
    }
    
    tableView.endUpdates()
    batchUpdates = []
  }
}

// MARK: - WalletPayBillView Viper Components API
fileprivate extension WalletPayBillViewController {
    var presenter: WalletPayBillPresenterApi {
        return _presenter as! WalletPayBillPresenterApi
    }
}

//MARK:- Helpers

extension WalletPayBillViewController {
  fileprivate func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.CellSize.height
    
    tableView.layer.cornerRadius = UIConstants.cornerRadius
    tableView.clipsToBounds = true
    
    tableView.registerCell(WalletPayBillTableViewCell.self)
    tableView.registerCell(WalletActivityIncomingInvoiceTableViewCell.self)
    
    tableView.contentInset.top = UIConstants.TableViewContentInset.top
  }
  
  fileprivate func handleInvoiceActions(_ cell: WalletActivityIncomingInvoiceTableViewCell, action: Wallet.WalletActivityInvoiceAction) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleInvoiceActionAt(indexPath, action: action)
  }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension WalletPayBillViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    presenter.handleWillDisplayItem(indexPath)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
    presenter.handleDidEndDisplayItem(indexPath)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return cachedCellsSizes[indexPath]?.height ?? UIConstants.CellSize.height
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModelType = presenter.itemViewModelAt(indexPath)
    switch viewModelType {
    case .invoice(let vm):
      let cell = tableView.dequeueReusableCell(cell: WalletActivityIncomingInvoiceTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleInvoiceActions)
      return cell
    case .loadingPlaceholder:
      return UITableViewCell()
    }
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum Constraints {
    static let headerViewMaxHeight: CGFloat = 64.0
    static let headerViewMinHeight: CGFloat = 1.0
  }
  enum CellSize {
    static let height: CGFloat = 160.0
  }
  enum TableViewContentInset {
    static let top: CGFloat = 15.0
  }
  
  static let cornerRadius: CGFloat = 5.0
}
