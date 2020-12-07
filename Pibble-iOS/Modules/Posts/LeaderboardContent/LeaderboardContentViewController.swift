//
//  LeaderboardContentViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: LeaderboardContentView Class
final class LeaderboardContentViewController: ViewController {
  @IBOutlet weak var tableView: UITableView!
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = false
  }
  
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
}

//MARK: - LeaderboardContentView API
extension LeaderboardContentViewController: LeaderboardContentViewControllerApi {
  func setHeaderViewModels(_ vm: [LeaderboardEntryViewModelProtocol]?, animated: Bool) {
    guard let viewModel = vm else {
      tableView.tableHeaderView = nil
      return
    }
    
    guard let header = tableView.tableHeaderView as? LeaderboardHeaderView else {
      let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 210)
      let headerView = LeaderboardHeaderView(frame: frame)
      
      tableView.tableHeaderView = headerView
      headerView.alpha = 0.0
      
      UIView.animate(withDuration: 0.3, animations: { [weak self] in
        guard let strongSelf = self else{
          return
        }
        
        headerView.setViewModel(viewModel, handler: strongSelf.headerSelectionHandler)
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        
      }) { [weak self] (_) in
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self?.tableView.beginUpdates()
        self?.tableView.endUpdates()
        UIView.animate(withDuration: 0.3) {
          headerView.alpha = 1.0
        }
        
      }
      //      tableView.setAndLayoutTableHeaderView(header: headerView)
      //
      //      headerView.alpha = 0.0
      return
    }
    
    UIView.animate(withDuration: 0.20, animations: { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      header.setViewModel(viewModel, handler: strongSelf.headerSelectionHandler)
      header.setNeedsLayout()
      header.layoutIfNeeded()
      
      
    }) { [weak self] (_) in
      header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      self?.tableView.beginUpdates()
      self?.tableView.endUpdates()
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

// MARK: - LeaderboardContentView Viper Components API
fileprivate extension LeaderboardContentViewController {
  var presenter: LeaderboardContentPresenterApi {
    return _presenter as! LeaderboardContentPresenterApi
  }
}

extension LeaderboardContentViewController {
  fileprivate func headerSelectionHandler(_ view: UIView, action: LeaderboardContent.LeaderboardActions) {
    switch action {
    case .showTopUser(let index):
      presenter.handleTopSelectActionAt(index)
    case .showTopUserPosts(let index):
      presenter.handleShowTopUserWinPostsActionAt(index)
    case .showUser:
      break
    case .showUserPosts:
      break
    }
  }
  
  fileprivate func itemsActionHandler(_ cell: UITableViewCell, action: LeaderboardContent.LeaderboardActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .showTopUser:
      break
    case .showTopUserPosts:
      break
    case .showUser:
      presenter.handleSelectActionAt(indexPath)
    case .showUserPosts:
      presenter.handleShowUserWinPostsActionAt(indexPath)
    }
  }
  
  fileprivate func setupView() {
    tableView.registerCell(LeaderboardTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
    
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
  }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension LeaderboardContentViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.itemViewModelAt(indexPath)
    switch viewModel {
    case .loadingPlaceholder:
      return UITableViewCell()
    case .leaderboardEntry(let vm):
      let cell = tableView.dequeueReusableCell(cell: LeaderboardTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: itemsActionHandler)
      return cell
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    presenter.handleSelectActionAt(indexPath)
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  static let bottomContentOffset: CGFloat = 60
  static let itemCellsEstimatedHeight: CGFloat = 60
}
