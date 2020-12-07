//
//  TagsListingPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 14/03/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TagsListingPresenter Class
final class TagsListingPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefresh()
  }
}

// MARK: - TagsListingPresenter API
extension TagsListingPresenter: TagsListingPresenterApi {
  func handleFollowingActionAt(_ indexPath: IndexPath) {
    interactor.performFollowingActionAt(indexPath)
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
  
  func itemViewModelAt(_ indexPath: IndexPath) -> TagListingItemViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    return TagsListing.ItemViewModel(tag: item, filterType: interactor.filterType)
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

// MARK: - TagsListing Viper Components
fileprivate extension TagsListingPresenter {
  var viewController: TagsListingViewControllerApi {
    return _viewController as! TagsListingViewControllerApi
  }
  var interactor: TagsListingInteractorApi {
    return _interactor as! TagsListingInteractorApi
  }
  var router: TagsListingRouterApi {
    return _router as! TagsListingRouterApi
  }
}

