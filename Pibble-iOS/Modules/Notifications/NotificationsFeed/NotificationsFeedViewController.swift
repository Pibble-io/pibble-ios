//
//  NotificationsFeedViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: NotificationsFeedView Class
final class NotificationsFeedViewController: ViewController {
  
  //MARK:- IBOutlets
  @IBOutlet weak var tableView: UITableView!
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
}

//MARK: - NotificationsFeedView API

extension NotificationsFeedViewController: NotificationsFeedViewControllerApi {
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

// MARK: - NotificationsFeedView Viper Components API
fileprivate extension NotificationsFeedViewController {
  var presenter: NotificationsFeedPresenterApi {
    return _presenter as! NotificationsFeedPresenterApi
  }
}

//MARK:- Helpers

extension NotificationsFeedViewController {
  fileprivate func setupView() {
    tableView.registerCell(NotificationsFeedFollowingTableViewCell.self)
    tableView.registerCell(NotificationsFeedPostRelatedItemTableViewCell.self)
    tableView.registerCell(NotificationsFeedPlainItemTableViewCell.self)
    tableView.registerCell(NotificationsFeedUserRelatedItemTableViewCell.self)
    
    tableView.registerViewAsHeader(NotificationsFeedSectionHeaderView.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
    
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    tableView.estimatedSectionHeaderHeight = UIConstants.estimatedHeaderHeight
    
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
  
    tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
  }
  
  fileprivate func setupAppearance() {
    tableView.backgroundView = nil
    tableView.backgroundColor = UIColor.clear
  }
}

extension NotificationsFeedViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.handleSelectionAt(indexPath)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let viewModel = presenter.sectionHeaderViewModel(section) else {
      return nil
    }
    
    let view = tableView.dequeueReusableHeader(NotificationsFeedSectionHeaderView.self)
    view.setTitle(viewModel.title)
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let _ = presenter.sectionHeaderViewModel(section) else {
      return CGFloat.leastNormalMagnitude
    }
    
    return UIConstants.estimatedHeaderHeight
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModelType = presenter.itemViewModelAt(indexPath)
    switch viewModelType {
    case .postRelated(let vm):
      let cell = tableView.dequeueReusableCell(cell: NotificationsFeedPostRelatedItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleCellAction)
      return cell
    case .following(let vm):
      let cell = tableView.dequeueReusableCell(cell: NotificationsFeedFollowingTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleCellAction)
      return cell
    case .userRelated(let vm):
      let cell = tableView.dequeueReusableCell(cell: NotificationsFeedUserRelatedItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: handleCellAction)
      return cell
    case .plain(let vm):
      let cell = tableView.dequeueReusableCell(cell: NotificationsFeedPlainItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .loadingPlaceholder:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
    presenter.handleWillDisplayItem(indexPath)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
    presenter.handleDidEndDisplayItem(indexPath)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return cachedCellsSizes[indexPath]?.height ?? UIConstants.itemCellsEstimatedHeight
  }
}

extension NotificationsFeedViewController {
  func handleCellAction(_ cell: UITableViewCell, action: NotificationsFeed.ItemActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleItemActionAt(indexPath, action: action)
  }
}

fileprivate enum UIConstants {
  static let estimatedHeaderHeight: CGFloat = 60
  static let bottomContentOffset: CGFloat = 60
  static let itemCellsEstimatedHeight: CGFloat = 62
}
