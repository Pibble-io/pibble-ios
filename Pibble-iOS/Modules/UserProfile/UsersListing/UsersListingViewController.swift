//
//  UsersListingViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import SwipeCellKit

//MARK: UsersListingView Class
final class UsersListingViewController: ViewController {
  
  //MARK:- IBOutlets
  
  @IBOutlet weak var hideButton: UIButton!
  
  @IBOutlet weak var navBarTitleLabel: UILabel!
  
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
  
  
  //MARK:- Overrrides
  
  override var shouldHandleSwipeToPopGesture: Bool {
    return true
  }
  
  //MARK:- IBActions
  
  @IBAction func hideButtonAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
}

//MARK: - UsersListingView API
extension UsersListingViewController: UsersListingViewControllerApi {
  func setHeaderViewModel(_ vm: UserListingHeaderViewModelProtocol?) {
    guard let viewModel = vm else {
      tableView.tableHeaderView = nil
      return
    }
    
    guard let header = tableView.tableHeaderView as? UsersListingHashtagsHeaderView else {
      let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
      let headerView = UsersListingHashtagsHeaderView(frame: frame)
      headerView.setViewModel(viewModel, handler: headerActionHandler)
      tableView.setAndLayoutTableHeaderView(header: headerView)
      
      headerView.alpha = 0.0
      UIView.animate(withDuration: 0.3) {
        headerView.alpha = 1.0
      }
      return
    }
    
    
    header.setViewModel(viewModel, handler: headerActionHandler)
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.tableView.setAndLayoutTableHeaderView(header: header)
    }
  }
  
  func setNavigationBarTitle(_ title: String) {
    navBarTitleLabel.text = title
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

// MARK: - UsersListingView Viper Components API

fileprivate extension UsersListingViewController {
    var presenter: UsersListingPresenterApi {
        return _presenter as! UsersListingPresenterApi
    }
}

//MARK:- Helpers

extension UsersListingViewController {
  fileprivate func setupView() {
    tableView.registerCell(UsersListingItemTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
    
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
  }
}

//MARK:- SwipeTableViewCellDelegate

extension UsersListingViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else {
      return nil
    }
    
    var actions: [SwipeAction] = []
    
    if presenter.isCancelFriendshipActionAvailable {
      let action = SwipeAction(style: .destructive, title: UsersListing.Strings.unfriendAction.localize()) { [weak self] action, indexPath in
        self?.presenter.handleCancelFriendshipActionAt(indexPath)
      }

      actions.append(action)
    }
    
    if presenter.isUnmuteUserActionAvailable {
      let action = SwipeAction(style: .destructive, title: UsersListing.Strings.unmuteAction.localize()) { [weak self] action, indexPath in
        self?.presenter.handleUnmuteActionAt(indexPath)
      }
      
      actions.append(action)
    }
    
    return actions
  }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension UsersListingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.itemViewModelAt(indexPath)
    let cell = tableView.dequeueReusableCell(cell: UsersListingItemTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel, handler: itemsActionsHandler)
    cell.delegate = self
    return cell
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

extension UsersListingViewController {
  fileprivate func headerActionHandler(_ view: UsersListingHashtagsHeaderView, action: UsersListing.ItemActions) {
    switch action {
    case .following:
      return
    case .followedHashTagsSeletion:
      presenter.handleFollowedHashTagsAction()
    }
  }
  
  func itemsActionsHandler(_ cell: UsersListingItemTableViewCell, action: UsersListing.ItemActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .following:
      presenter.handleFollowingActionAt(indexPath)
    case .followedHashTagsSeletion:
      break
    }
  }
}

fileprivate enum UIConstants {
  static let bottomContentOffset: CGFloat = 60
  static let itemCellsEstimatedHeight: CGFloat = 60
}

