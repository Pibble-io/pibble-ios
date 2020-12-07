//
//  TagsListingModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 14/03/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - TagsListingRouter API
protocol TagsListingRouterApi: RouterProtocol {
  func routeToUserProfileFor(_ tag: TagProtocol)
}

//MARK: - TagsListingView API
protocol TagsListingViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func setNavigationBarTitle(_ title: String)
}

//MARK: - TagsListingPresenter API
protocol TagsListingPresenterApi: PresenterProtocol {
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> TagListingItemViewModelProtocol
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func handleSelectActionAt(_ indexPath: IndexPath)
  func handleFollowingActionAt(_ indexPath: IndexPath)
}

//MARK: - TagsListingInteractor API
protocol TagsListingInteractorApi: InteractorProtocol {
  var filterType: TagsListing.FilterType { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> TagProtocol
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  
  func performFollowingActionAt(_ indexPath: IndexPath)
}

protocol TagListingItemViewModelProtocol {
  var avatarPlaceholder: UIImage? { get }
  var avatarURLString: String { get }
  var username: String { get }
  var userLevel: String { get }
  
  var isActionAvailable: Bool { get }
  var actionTitle: String { get }
  var isActionHighlighted: Bool { get }
}
