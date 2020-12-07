//
//  NotificationsFeedModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - NotificationsFeedRouter API
protocol NotificationsFeedRouterApi: RouterProtocol {
  func routeToUserProfileFor(_ user: UserProtocol)
  func routeToPostDetailFor(_ post: PostingProtocol) 
}

//MARK: - NotificationsFeedView API
protocol NotificationsFeedViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
}

//MARK: - NotificationsFeedPresenter API
protocol NotificationsFeedPresenterApi: PresenterProtocol {
  func presentReload()
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  
  func handleHideAction()
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func handleSelectionAt(_ indexPath: IndexPath)
  func handleItemActionAt(_ indexPath: IndexPath, action: NotificationsFeed.ItemActions)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> NotificationsFeed.ItemViewModelType
  
  func sectionHeaderViewModel(_ section: Int) -> NotificationsFeedSectionHeaderViewModelProtocol?
}

//MARK: - NotificationsFeedInteractor API
protocol NotificationsFeedInteractorApi: InteractorProtocol {
  func itemAt(_ indexPath: IndexPath) -> NotificationEntity?
  func numberOfItemsInSection(_ section: Int) -> Int
  func numberOfSections() -> Int
  
  func cancelPrepareItemFor(_ indexPath: IndexPath)
  func prepareItemFor(_ indexPath: IndexPath)
  
  func initialRefresh()
  func initialFetchData()
  
  func performFollowUserActionAt(_ indexPath: IndexPath) 
}


protocol NotificationsFeedPostRelatedItemViewModelProtocol: NotificationsFeedPlainItemViewModelProtocol {

  var postPreviewUrlString: String { get }
}

protocol NotificationsFeedFollowItemViewModelProtocol: NotificationsFeedPlainItemViewModelProtocol {

  var isActionAvailable: Bool { get }
  var actionTitle: String { get }
  var isActionHighlighted: Bool { get }
}

protocol NotificationsFeedUserRelatedItemViewModelProtocol: NotificationsFeedPlainItemViewModelProtocol {
  
  var relatedUserAvatarUrlString: String { get }
  var relatedUserAvatarPlaceholder: UIImage? { get }
}

protocol NotificationsFeedPlainItemViewModelProtocol {
  var avatarPlaceholder: UIImage? { get }
  var avatarURLString: String { get }
//  var message: String { get }
  var attributedMessage: NSAttributedString { get }
}

protocol NotificationsFeedSectionHeaderViewModelProtocol {
  var title: String { get }
}
