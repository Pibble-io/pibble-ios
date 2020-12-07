//
//  UsersListingModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - UsersListingRouter API
protocol UsersListingRouterApi: RouterProtocol {
  func routeToUserProfileFor(_ user: UserProtocol)
  func routeToFollowedTagsFor(_ user: UserProtocol)
}

//MARK: - UsersListingView API
protocol UsersListingViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func setNavigationBarTitle(_ title: String)
  func setHeaderViewModel(_ vm: UserListingHeaderViewModelProtocol?)
}

//MARK: - UsersListingPresenter API
protocol UsersListingPresenterApi: PresenterProtocol {
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  
  func handleHideAction() 
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> UserListingItemViewModelProtocol
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func handleSelectActionAt(_ indexPath: IndexPath)
  func handleFollowingActionAt(_ indexPath: IndexPath)
  
  func handleCancelFriendshipActionAt(_ indexPath: IndexPath)
  func handleUnmuteActionAt(_ indexPath: IndexPath)
  
  func handleFollowedHashTagsAction()
  
  func presentFollowedTags(_ followedTags: UsersListing.FollowedTagsModel)
  
  var isCancelFriendshipActionAvailable: Bool { get }
  
  var isUnmuteUserActionAvailable: Bool { get }
}

//MARK: - UsersListingInteractor API
protocol UsersListingInteractorApi: InteractorProtocol {
  var contentType: UsersListing.ContentType { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> UserProtocol
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  func cleanUpData()
  
  func performFollowingActionAt(_ indexPath: IndexPath)
  func performCancelFriendshipActionAt(_ indexPath: IndexPath)
  func performUnmuteActionAt(_ indexPath: IndexPath)
  
}

protocol UserListingItemViewModelProtocol {
  var avatarPlaceholder: UIImage? { get }
  var avatarURLString: String { get }
  var username: String { get }
  var userLevel: String { get }
  
  var isActionAvailable: Bool { get }
  var actionTitle: String { get }
  var isActionHighlighted: Bool { get }
}

protocol UserListingHeaderViewModelProtocol {
  var username: String { get }
  var userLevel: String { get }
  
  var isActionAvailable: Bool { get }
}
