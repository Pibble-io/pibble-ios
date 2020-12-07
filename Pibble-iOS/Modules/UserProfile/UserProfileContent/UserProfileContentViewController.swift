//
//  UserProfileContentViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: UserProfileContentView Class
final class UserProfileContentViewController: ViewController {
  //MARK:- IBOutlets
  
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
  
  
  //MARK:- Protperties
  
  weak var embedableDelegate: EmbedableViewControllerDelegate?
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
}

//MARK: - UserProfileContentView API
extension UserProfileContentViewController: UserProfileContentViewControllerApi {
  func setBouncingEnabled(_ enabled: Bool) {
    tableView.bounces = enabled
    tableView.alwaysBounceVertical = enabled
  }
  
  func setScrollingEnabled(_ enabled: Bool) {
    tableView.isScrollEnabled = enabled
  }
  
  var contentSize: CGSize {
    return tableView.contentSize
  }
  
  func reloadData() {
    tableView.reloadData()
    embedableDelegate?.handleContentSizeChange(self, contentSize: contentSize)
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
    embedableDelegate?.handleContentSizeChange(self, contentSize: contentSize)
    
    batchUpdates = []
  }
}

// MARK: - UserProfileContentView Viper Components API
fileprivate extension UserProfileContentViewController {
  var presenter: UserProfileContentPresenterApi {
      return _presenter as! UserProfileContentPresenterApi
  }
}


extension UserProfileContentViewController {
  fileprivate func setupView() {
    tableView.registerCell(UserProfileAvatarTableViewCell.self)
    tableView.registerCell(UserProfileUsernameTableViewCell.self)
    tableView.registerCell(UserProfileFollowActionsTableViewCell.self)
    tableView.registerCell(UserProfileLevelTableViewCell.self)
    tableView.registerCell(UserProfileStatsTableViewCell.self)
    tableView.registerCell(UserProfileCaptionTableViewCell.self)
    
    tableView.registerCell(UserProfileFriendTableViewCell.self)
    tableView.registerCell(UserProfileUsersSectionHeaderTableViewCell.self)
    
    tableView.registerCell(UserProfileFriendRequestTableViewCell.self)
    tableView.registerCell(UserProfileBrushRewardChartTableViewCell.self)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
  }
}

extension UserProfileContentViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return cachedCellsSizes[indexPath]?.height ?? UIConstants.itemCellsEstimatedHeight
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let viewModelType = presenter.itemViewModelFor(indexPath)
    switch viewModelType {
    case .avatar(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileAvatarTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: avatarActionsHandler)
      return cell
    case .username(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileUsernameTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .followActions(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileFollowActionsTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: interactionActionsHandler)
      return cell
    case .level(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileLevelTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .countsStatus(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileStatsTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: showStatsActionsHandler)
      return cell
    case .caption(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileCaptionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: userCaptionActionsHandler)
      return cell
    case .friend(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileFriendTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: friendsUsersActionsHandler)
      return cell
    case .usersHeader(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileUsersSectionHeaderTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .friendRequest(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileFriendRequestTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: friendsRequestActionsHandler)
      return cell
    case .rewardsHistoryChart(let vm):
      let cell = tableView.dequeueReusableCell(cell: UserProfileBrushRewardChartTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: periodSwitchActionHandler)
      return cell
    }
  }
}


extension UserProfileContentViewController {
  fileprivate func interactionActionsHandler(_ cell: UserProfileFollowActionsTableViewCell, action: UserProfileContent.FollowActions) {
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .following:
      presenter.handleFollowingAction()
    case .friendship:
      presenter.handleFriendshipAction()
    }
  }
  
  fileprivate func showStatsActionsHandler(cell: UserProfileStatsTableViewCell, action: UserProfileContent.UserStatsShowActions) {
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .followers:
      presenter.handleShowFollowersAction()
    case .followings:
      presenter.handleShowFollowingsAction()
    case .friends:
      presenter.handleShowFriendsAction()
    case .posts:
      presenter.handleShowPostingsAction()
    }
  }
  
  fileprivate func avatarActionsHandler(_ cell: UserProfileAvatarTableViewCell, action: UserProfileContent.UserAvavarActions) {
    
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handlePickMediaAction(action)
  }
  
  fileprivate func userCaptionActionsHandler(_ cell: UserProfileCaptionTableViewCell, action: UserProfileContent.UserProfileCaptionActions) {
    
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .edit:
      presenter.handleEditCaptionAction()
    case .showWebsite:
      presenter.handleShowWebsiteAction()
    }
  }
  
  fileprivate func friendsUsersActionsHandler(_ cell: UserProfileFriendTableViewCell, action: UserProfileContent.UserProfileFriendActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .showUserProfile:
      presenter.handleShowProfileActionAt(indexPath)
    }
  }
  
  fileprivate func friendsRequestActionsHandler(_ cell: UserProfileFriendRequestTableViewCell, action: UserProfileContent.UserProfileFriendRequestActions) {
  
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
  
    presenter.handleFriendRequestActionFor(indexPath, action: action)
  }
  
  fileprivate func periodSwitchActionHandler(_ cell: UserProfileBrushRewardChartTableViewCell) {
    guard let _ = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleSwitchChartPeriodAction()
  }
}


fileprivate enum UIConstants {
  static let itemCellsEstimatedHeight: CGFloat = 1.1
}





