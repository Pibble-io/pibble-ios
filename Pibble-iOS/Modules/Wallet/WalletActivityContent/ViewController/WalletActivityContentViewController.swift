//
//  WalletActivityContentViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletActivityContentView Class
class WalletActivityContentViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var dataPlaceholderView: UIView!
  @IBOutlet weak var dataPlaceholderTitle: UILabel!
  @IBOutlet weak var dataPlaceholderSubtitle: UILabel!
  
  //MARK:- private properites
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
}

//MARK: - WalletActivityContentView API
extension WalletActivityContentViewController: WalletActivityContentViewControllerApi {
  func setDataPlaceholderViewModel(_ vm: DataPlaceholderViewModelProtocol?, animated: Bool) {
    let alpha: CGFloat = vm == nil ? 0.0 : 1.0
    let tableViewAlpha: CGFloat = vm != nil ? 0.0 : 1.0
    guard animated else {
      dataPlaceholderView.alpha = alpha
      tableView.alpha = tableViewAlpha
      dataPlaceholderTitle.text = vm?.title ?? ""
      dataPlaceholderSubtitle.text = vm?.subtitle ?? ""
      return
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.tableView.alpha = tableViewAlpha
      strongSelf.dataPlaceholderView.alpha = alpha
      strongSelf.dataPlaceholderTitle.text = vm?.title ?? ""
      strongSelf.dataPlaceholderSubtitle.text = vm?.subtitle ?? ""
    }) { (_) in }
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
  
  func setInteractionEnabled(_ enabled: Bool) {
    tableView.visibleCells.forEach { $0.isUserInteractionEnabled = enabled }
  }
}

// MARK: - WalletActivityContentView Viper Components API
fileprivate extension WalletActivityContentViewController {
    var presenter: WalletActivityContentPresenterApi {
        return _presenter as! WalletActivityContentPresenterApi
    }
}

//MARK:- Helpers

extension WalletActivityContentViewController {
  func handleHideAction() {
    presenter.handleHideAction()
  }
  
  fileprivate func walletActivityActionHandler(_ cell: UITableViewCell, action: WalletActivityContent.WalletActivityAction) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleWalletActivityActionAt(indexPath, action: action)
  }
  
  fileprivate func setupView() {
    tableView.registerCell(WalletActivityOutcomingInvoiceTableViewCell.self)
    tableView.registerCell(WalletActivityIncomingInvoiceTableViewCell.self)
    tableView.registerCell(WalletActivityInternalTransactionTableViewCell.self)
    tableView.registerCell(WalletActivityExternalTransactionTableViewCell.self)
    tableView.registerCell(WalletActivityDonatorTableViewCell.self)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.CellSize.height
  }
  
  fileprivate func handleInvoiceActions(_ cell: WalletActivityIncomingInvoiceTableViewCell, action: Wallet.WalletActivityInvoiceAction) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleInvoiceActionAt(indexPath, action: action)
  }
}


//MARK:- UITableViewDataSource, UITableViewDelegate

extension WalletActivityContentViewController: UITableViewDataSource, UITableViewDelegate {
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
    let itemsCount =  presenter.numberOfItemsInSection(section)
    return itemsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let itemVM = presenter.itemViewModelAt(indexPath)
    switch itemVM {
    case .outcomingRequest(let vm):
      let cell = tableView.dequeueReusableCell(cell: WalletActivityIncomingInvoiceTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.handleInvoiceActions($0, action: $1) }
      return cell
    case .incomingRequest(let vm):
      let cell = tableView.dequeueReusableCell(cell: WalletActivityIncomingInvoiceTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.handleInvoiceActions($0, action: $1) }
      return cell
    case .internalTransaction(let vm):
      let cell = tableView.dequeueReusableCell(cell: WalletActivityInternalTransactionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .externalTransaction(let vm):
      let cell = tableView.dequeueReusableCell(cell: WalletActivityExternalTransactionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.walletActivityActionHandler($0, action: $1) }
      return cell
    case .exchangeTransaction(let vm):
      let cell = tableView.dequeueReusableCell(cell: WalletActivityInternalTransactionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .externalExchangeTransaction(let vm):
      let cell = tableView.dequeueReusableCell(cell: WalletActivityInternalTransactionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .donatorFundingTransaction(let vm):
      let cell = tableView.dequeueReusableCell(cell: WalletActivityDonatorTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.walletActivityActionHandler($0, action: $1) }
      return cell
      
    case .loadingPlaceholder:
      return UITableViewCell()
    }
  }
}

fileprivate enum UIConstants {
  enum CellSize {
    static let height: CGFloat = 110.0
  }
}





