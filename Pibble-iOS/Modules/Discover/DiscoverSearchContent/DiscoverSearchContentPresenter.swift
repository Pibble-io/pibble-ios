//
//  DiscoverSearchContentPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - DiscoverSearchContentPresenter Class
final class DiscoverSearchContentPresenter: Presenter {
  fileprivate weak var delegate: DiscoverSearchContentDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefresh()
  }
  
  init(delegate: DiscoverSearchContentDelegate) {
    self.delegate = delegate
  }
}

// MARK: - DiscoverSearchContentPresenter API
extension DiscoverSearchContentPresenter: DiscoverSearchContentPresenterApi {
  func handleCopySearchStringAt(_ indexPath: IndexPath) {
    guard interactor.isCopySearchStringAvailable else {
      return
    }
    
    let item = interactor.itemAt(indexPath)
    delegate?.searchWithCopyPastedSearchString(item.searchString)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    interactor.saveToSearchHistoryItemAt(indexPath)
    let item = interactor.itemAt(indexPath)
    switch item {
    case .user(let searchResult):
      guard let user = searchResult.user else {
        return
      }
      router.routeToDetailFor(user)
    case .place(let searchResult):
      guard let place = searchResult.place else {
        return
      }
      router.routeToDetailFor(place)
    case .tag(let searchResult):
      guard let tag = searchResult.tag else {
        return
      }
      router.routeToDetailFor(tag)
    }
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> DiscoverSearchContentResultViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    switch item {
    case .user(let searchResult):
      return DiscoverSearchContent.ResultViewModel(user: searchResult.user,
                                                   isCopySearchStringAvailable: interactor.isCopySearchStringAvailable)
    case .place(let searchResult):
      return DiscoverSearchContent.ResultViewModel(place: searchResult.place,
                                                   isCopySearchStringAvailable: interactor.isCopySearchStringAvailable)
    case .tag(let searchResult):
      return DiscoverSearchContent.ResultViewModel(tag: searchResult.tag,
                                                   isCopySearchStringAvailable: interactor.isCopySearchStringAvailable)
    }
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
  
  func presentReload() {
    viewController.reloadData()
  }
}

// MARK: - DiscoverSearchContent Viper Components
fileprivate extension DiscoverSearchContentPresenter {
  var viewController: DiscoverSearchContentViewControllerApi {
    return _viewController as! DiscoverSearchContentViewControllerApi
  }
  var interactor: DiscoverSearchContentInteractorApi {
    return _interactor as! DiscoverSearchContentInteractorApi
  }
  var router: DiscoverSearchContentRouterApi {
    return _router as! DiscoverSearchContentRouterApi
  }
}

extension DiscoverSearchContentPresenter: DiscoverFeedRootContainerSearchDelegate {
  func handleSearch(_ text: String) {
    interactor.performSearch(text)
  }
}
