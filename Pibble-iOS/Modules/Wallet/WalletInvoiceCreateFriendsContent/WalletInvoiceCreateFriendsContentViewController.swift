//
//  WalletInvoiceCreateFriendsContentViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 01.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletInvoiceCreateFriendsContentView Class
final class WalletInvoiceCreateFriendsContentViewController: ViewController {
  @IBOutlet weak var tableView: UITableView!
  
  //MARK:- private properites
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}

//MARK: - WalletInvoiceCreateFriendsContentView API
extension WalletInvoiceCreateFriendsContentViewController: WalletInvoiceCreateFriendsContentViewControllerApi {
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
        tableView.insertRows(at: idx, with: .automatic)
      case .delete(let idx):
        tableView.deleteRows(at: idx, with: .automatic)
      case .insertSections(let idx):
        tableView.insertSections(IndexSet(idx), with: .automatic)
      case .deleteSections(let idx):
        tableView.deleteSections(IndexSet(idx), with: .automatic)
      case .updateSections(let idx):
        tableView.reloadSections(IndexSet(idx), with: .automatic)
      case .moveSections(let from, let to):
        tableView.moveSection(from, toSection: to)
      case .update(let idx):
        tableView.reloadRows(at: idx, with: .automatic)
      case .move(let from, let to):
        tableView.moveRow(at: from, to: to)
      }
    }
    
    tableView.endUpdates()
    batchUpdates = []
  }
}

// MARK: - WalletInvoiceCreateFriendsContentView Viper Components API
fileprivate extension WalletInvoiceCreateFriendsContentViewController {
    var presenter: WalletInvoiceCreateFriendsContentPresenterApi {
        return _presenter as! WalletInvoiceCreateFriendsContentPresenterApi
    }
}

//MARK:- Helpers

extension WalletInvoiceCreateFriendsContentViewController {
  func setupView() {
    tableView.registerCell(WalletInvoiceFriendsTableViewCell.self)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.CellSize.height
  }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension WalletInvoiceCreateFriendsContentViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    presenter.handleSelectionAt(indexPath)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return cachedCellsSizes[indexPath]?.height ?? UIConstants.CellSize.height
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    presenter.handleWillDisplayItem(indexPath)
    let viewModel = presenter.itemViewModelAt(indexPath)
    cell.setSelected(viewModel.isSelected, animated: false)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
    presenter.handleDidEndDisplayItem(indexPath)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(cell: WalletInvoiceFriendsTableViewCell.self, for: indexPath)
    let viewModel = presenter.itemViewModelAt(indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum CellSize {
    static let height: CGFloat = 61.0
  }
}
