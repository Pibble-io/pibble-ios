//
//  UserProfileContentPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

// MARK: - UserProfileContentPresenter Class
final class UserProfileContentPresenter: Presenter {
  fileprivate var pickMediaAction: UserProfileContent.UserAvavarActions?
  
  fileprivate var deniedFriendsShipRequests: Set<IndexPath> = Set<IndexPath>()
  fileprivate var acceptedFriendsShipRequests: Set<IndexPath> = Set<IndexPath>()
  
  fileprivate var sections: [(section: UserProfileSections, items: [UserProfileContent.ItemViewModelType])] = [
    (section: .infoSection, items: []),
    (section: .rewardsHistory, items: []),
    
    (section: .friendsRequestsHeader, items: []),
    (section: .friendsRequests, items: []),
    (section: .friendsHeader, items: []),
    (section: .friends, items: [])
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefreshData()
  }
}

// MARK: - UserProfileContentPresenter API
extension UserProfileContentPresenter: UserProfileContentPresenterApi {
  func handleShowWebsiteAction() {
    guard let url = interactor.user?.getValidProfileSiteUrl() else {
      return
    }
    
    router.routeToUserProfileURL(url)
  }
  
  func handleSwitchChartPeriodAction() {
    interactor.performSwitchChartPeriodAction()
  }
  
  func handleShowProfileActionAt(_ indexPath: IndexPath) {
    guard let user = interactor.friendUserAt(indexPath.item) else {
      return
    }
    
    router.routeToUserProfileFor(user)
  }
  
  func handleFriendRequestActionFor(_ indexPath: IndexPath, action: UserProfileContent.UserProfileFriendRequestActions) {
    let sectionContent = sections[indexPath.section]
    guard sectionContent.section == .friendsRequests else {
      return
    }
    
    switch action {
    case .accept:
      interactor.acceptFriendRequestActionFor(indexPath.item)
    case .deny:
       interactor.denyFriendRequestActionFor(indexPath.item)
    case .showUserProfile:
      guard let user = interactor.friendRequestUserAt(indexPath.item) else {
        return
      }
      
      router.routeToUserProfileFor(user)
    }
  }
  
  func handleEditCaptionAction() {
    guard let user = interactor.user, (user.isCurrent ?? false) else {
      return
    }
    router.routeToDescriptionPickWith(self)
  }
  
  func handlePickMediaAction(_ action: UserProfileContent.UserAvavarActions) {
    guard let user = interactor.user else {
      return
    }
    
    switch action {
    case .wall, .userpic:
      guard (user.isCurrent ?? false) else {
        return
      }
      
      pickMediaAction = action
      router.routeToMediaPickWith(self)
    case .playroom:
      router.routeToPlayRoom(user)
    }
  }
  
  func handleShowFollowersAction() {
    guard let user = interactor.user, user.userFollowersCount > 0 else {
      return
    }
    
    router.routeToFollowersFor(user)
  }
  
  func handleShowFollowingsAction() {
    guard let user = interactor.user, user.userFollowingsCount > 0 else {
      return
    }
    
    router.routeToFollowingsFor(user)
  }
  
  func handleShowFriendsAction() {
    guard let user = interactor.user, user.userFriendsCount > 0 else {
      return
    }
    
    router.routeToFriendsFor(user)
  }
  
  func handleShowPostingsAction() {
    guard let user = interactor.user else {
      return
    }
    
    router.routeToPostingsFor(user)
  }
  
  func handleFollowingAction() {
    interactor.performFollowingAction()
  }
  
  func handleFriendshipAction() {
    interactor.performFriendshipAction()
  }
  
  
  func presentReloadHistoryRewards(_ rewardsHistory: UserProfileContent.BrushRewardsHistory) {
    let idx = UserProfileSections.rewardsHistory.rawValue
//    
//    guard rewardsHistory.pgb.count > 0 || rewardsHistory.prb.count > 0 else {
//      sections[idx] = (section: .rewardsHistory, items: [])
//      viewController.updateCollection(.beginUpdates)
//      viewController.updateCollection(.updateSections(idx: [idx]))
//      viewController.updateCollection(.endUpdates)
//      return
//    }
    
    DispatchQueue.global(qos: .utility).async { [weak self] in
      let userVMItems = [rewardsHistory]
        .map { UserProfileContent.UserProfileRewardsChartViewModel(rewardsHistory: $0) }
        .map { UserProfileContent.ItemViewModelType.rewardsHistoryChart($0) }
     
      DispatchQueue.main.async { [weak self] in
        guard let strongSelf = self else {
          return
        }
        strongSelf.sections[idx] = (section: .rewardsHistory, items: userVMItems)
        
        strongSelf.viewController.updateCollection(.beginUpdates)
        strongSelf.viewController.updateCollection(.updateSections(idx: [idx]))
        strongSelf.viewController.updateCollection(.endUpdates)
        
        //weird hack to force update tablewView layout
        strongSelf.viewController.updateCollection(.beginUpdates)
        strongSelf.viewController.updateCollection(.endUpdates)
      }
    }
  }
  
  func presentReloadFriendsRequestsFor(_ users: [UserProtocol]) {
    let idx = UserProfileSections.friendsRequests.rawValue
    let headerIdx = UserProfileSections.friendsRequestsHeader.rawValue
    
    let userVMItems = users
      .map { UserProfileContent.UserProfileFriendRequestViewModel(user: $0) }
      .map { UserProfileContent.ItemViewModelType.friendRequest($0) }
    
//    
//    let friendsCount = interactor.user?.userFriendsCount ?? userVMItems.count
//    let isShowAllButtonHidden = friendsCount <= userVMItems.count
    let headerVM = UserProfileContent.UserProfileFriendsRequestHeaderViewModel(friendsCount:  userVMItems.count,
                                                                               isShowAllButtonHidden: true )
    let headerVMItems: [UserProfileContent.ItemViewModelType] = userVMItems.count > 0 ? [.usersHeader(headerVM)] : []
    
    sections[idx] = (section: .friendsRequests, items: userVMItems)
    sections[headerIdx] = (section: .friendsRequestsHeader, items: headerVMItems)
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: [idx, headerIdx]))
    viewController.updateCollection(.endUpdates)
    
    //weird hack to update tablewView layout 
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.endUpdates)
  }
  
  func presentDiffReloadFriendsFor(_ users: [UserProtocol]) {
    let idx = UserProfileSections.friends.rawValue
    let headerIdx = UserProfileSections.friendsHeader.rawValue
    
    let newUserViewModels = users
      .map { UserProfileContent.UserProfileFriendViewModel(user: $0) }
      .map { UserProfileContent.ItemViewModelType.friend($0) }
    
    let friendsCount = interactor.user?.userFriendsCount ?? newUserViewModels.count
    let isShowAllButtonHidden = friendsCount <= newUserViewModels.count
    let headerVM = UserProfileContent.UserProfileFriendsHeaderViewModel(friendsCount: friendsCount, isShowAllButtonHidden: isShowAllButtonHidden)
    let newHeaderViewModels: [UserProfileContent.ItemViewModelType] = newUserViewModels.count > 0 ? [.usersHeader(headerVM)] : []
    
    let oldUsersViewModels = sections[idx].items
    let oldHeaderViewModels = sections[headerIdx].items
    
    sections[idx] = (section: .friends, items: newUserViewModels)
    sections[headerIdx] = (section: .friendsHeader, items: newHeaderViewModels)
    
    viewController.updateCollection(.beginUpdates)
    
    for vmsTuple in [(oldUsersViewModels, newUserViewModels, idx), (oldHeaderViewModels, newHeaderViewModels, headerIdx)] {
      
      let diff = vmsTuple.1.diff(before: vmsTuple.0)
      let insert = diff.insertedIndices.map { IndexPath(item: $0, section: vmsTuple.2) }
      let delete = diff.deletedIndices.map { IndexPath(item: $0, section: vmsTuple.2) }
      let update = diff.updateIndices.map { IndexPath(item: $0, section: vmsTuple.2) }
      
      let moves = diff.movedIndices.map {
        return CollectionViewModelUpdate.move(from: IndexPath(item: $0.from, section: vmsTuple.2),
                                              to:  IndexPath(item: $0.to, section: vmsTuple.2))
      }
      
      viewController.updateCollection(.insert(idx: insert))
      viewController.updateCollection(.delete(idx: delete))
      viewController.updateCollection(.update(idx: update))
      moves.forEach {
        viewController.updateCollection($0)
      }
    }
    
    viewController.updateCollection(.endUpdates)
  }
  
  func presentReloadFriendsFor(_ users: [UserProtocol]) {
    let idx = UserProfileSections.friends.rawValue
    let headerIdx = UserProfileSections.friendsHeader.rawValue
    
    let userVMItems = users
      .map { UserProfileContent.UserProfileFriendViewModel(user: $0) }
      .map { UserProfileContent.ItemViewModelType.friend($0) }
   
    let friendsCount = interactor.user?.userFriendsCount ?? userVMItems.count
    let isShowAllButtonHidden = friendsCount <= userVMItems.count
    let headerVM = UserProfileContent.UserProfileFriendsHeaderViewModel(friendsCount: friendsCount, isShowAllButtonHidden: isShowAllButtonHidden)
    let headerVMItems: [UserProfileContent.ItemViewModelType] = userVMItems.count > 0 ? [.usersHeader(headerVM)] : []
    
    sections[idx] = (section: .friends, items: userVMItems)
    sections[headerIdx] = (section: .friendsHeader, items: headerVMItems)
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: [idx, headerIdx]))
    viewController.updateCollection(.endUpdates)
  }
  
  func presentReloadInfoFor(_ user: UserProtocol) {
    let idx = UserProfileSections.infoSection.rawValue
  
    let newViewModels = UserProfileContent.ItemViewModelType.prepareInfoSectionViewModels(user: user)
    let oldViewModels = sections[idx].items
    
    let diff = newViewModels.diff(before: oldViewModels)
    let insert = diff.insertedIndices.map { IndexPath(item: $0, section: idx) }
    let delete = diff.deletedIndices.map { IndexPath(item: $0, section: idx) }
    let update = diff.updateIndices.map { IndexPath(item: $0, section: idx) }

    let moves = diff.movedIndices.map {
      return CollectionViewModelUpdate.move(from: IndexPath(item: $0.from, section: idx),
                                            to:  IndexPath(item: $0.to, section: idx))
    }

    sections[idx]  = (section: .infoSection, items: newViewModels)
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.insert(idx: insert))
    viewController.updateCollection(.delete(idx: delete))
    viewController.updateCollection(.update(idx: update))
    moves.forEach {
      viewController.updateCollection($0)
    }

    viewController.updateCollection(.endUpdates)
    //weird hack to force update tablewView layout 
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.endUpdates)
  }
  
  
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelFor(_ indexPath: IndexPath) -> UserProfileContent.ItemViewModelType {
    return sections[indexPath.section].items[indexPath.item]
  }
}

// MARK: - UserProfileContent Viper Components
fileprivate extension UserProfileContentPresenter {
  var viewController: UserProfileContentViewControllerApi {
    return _viewController as! UserProfileContentViewControllerApi
  }
  var interactor: UserProfileContentInteractorApi {
    return _interactor as! UserProfileContentInteractorApi
  }
  var router: UserProfileContentRouterApi {
    return _router as! UserProfileContentRouterApi
  }
}

//MARK:- MediaPickDelegateProtocol

extension UserProfileContentPresenter: MediaPickDelegateProtocol {
  func didSelectedMediaAssets(_ assets: [LibraryAsset]) {
    router.dismissMediaPick()
    
    guard let imageAsset = assets.first, let pickMediaActionPurpose = pickMediaAction else {
      return
    }
    
    switch pickMediaActionPurpose {
    case .wall:
      interactor.uploadWallFromAsset(imageAsset)
    case .userpic:
      interactor.uploadUserpicFromAsset(imageAsset)
    case .playroom:
      break
    }
  }
  
  func presentationStyle() -> MediaPick.PresentationStyle {
    return .present
  }
}


//MARK:- UserDescriptionPickDelegateProtocol

extension UserProfileContentPresenter: UserProfilePickDelegateProtocol {
  func didSelectUserProfile(_ profile: UserProfileProtocol) {
    interactor.updateUserProfile(profile)
  }
  
  func selectedUserProfile() -> UserProfileProtocol? {
    return interactor.user
  }
}



fileprivate enum UserProfileSections: Int {
  case infoSection
  case rewardsHistory
  case friendsRequestsHeader
  case friendsRequests
  case friendsHeader
  case friends
}
