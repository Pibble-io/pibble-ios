//
//  UsersListingPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UsersListingPresenter Class
final class UsersListingPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
    
    setNavigationBarTitle()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefresh()
  }
  
  override func viewDidDisappear() {
    super.viewDidDisappear()
    interactor.cleanUpData()
  }
}

// MARK: - UsersListingPresenter API
extension UsersListingPresenter: UsersListingPresenterApi {
  func handleUnmuteActionAt(_ indexPath: IndexPath) {
    interactor.performUnmuteActionAt(indexPath)
  }
  
  var isUnmuteUserActionAvailable: Bool {
    switch interactor.contentType {
    case .followers, .following, .friends, .editFriends:
      return false
    case .mutedUsers:
      return true
    }
  }
  
  var isCancelFriendshipActionAvailable: Bool {
    switch interactor.contentType {
    case .followers, .following, .friends:
      return false
    case .editFriends:
      return true
    case .mutedUsers:
      return false
    }
  }
  
  func handleFollowedHashTagsAction() {
    switch interactor.contentType {
    case .followers(_):
      break
    case .following(let user):
      router.routeToFollowedTagsFor(user)
    case .friends(_), .editFriends(_), .mutedUsers(_):
      break
    }
  }
  
  func presentFollowedTags(_ followedTags: UsersListing.FollowedTagsModel) {
    let vm = UsersListing.HashTagsHeaderViewModel(tags: followedTags)
    viewController.setHeaderViewModel(vm)
  }
  
  func handleFollowingActionAt(_ indexPath: IndexPath) {
    interactor.performFollowingActionAt(indexPath)
  }
  
  func handleCancelFriendshipActionAt(_ indexPath: IndexPath) {
    interactor.performCancelFriendshipActionAt(indexPath)
  }
  
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> UserListingItemViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    return UsersListing.UserListingItemViewModel(user: item, filterType: interactor.contentType)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.item)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.item)
  }
  
  func handleSelectActionAt(_ indexPath: IndexPath) {
    let item = interactor.itemAt(indexPath)
    router.routeToUserProfileFor(item)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
}

// MARK: - UsersListing Viper Components
fileprivate extension UsersListingPresenter {
    var viewController: UsersListingViewControllerApi {
        return _viewController as! UsersListingViewControllerApi
    }
    var interactor: UsersListingInteractorApi {
        return _interactor as! UsersListingInteractorApi
    }
    var router: UsersListingRouterApi {
        return _router as! UsersListingRouterApi
    }
}

// MARK: - Helpers

extension UsersListingPresenter {
  func setNavigationBarTitle() {
    let navBarTitle: String
    switch interactor.contentType {
    case .followers(_):
      navBarTitle = UsersListing.Strings.NavigationBar.followers.localize()
    case .following(_):
      navBarTitle = UsersListing.Strings.NavigationBar.following.localize()
    case .friends(_):
      navBarTitle = UsersListing.Strings.NavigationBar.friends.localize()
    case .editFriends(_):
      navBarTitle = UsersListing.Strings.NavigationBar.editFriends.localize()
    case .mutedUsers(_):
      navBarTitle = UsersListing.Strings.NavigationBar.mutedUsers.localize()
    }
    
    viewController.setNavigationBarTitle(navBarTitle)
  }
}
