//
//  SearchResultTagDetailContentPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - SearchResultTagDetailContentPresenter Class
final class SearchResultTagDetailContentPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setTagViewModel(nil, animated: false)
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefresh()
  }
}

// MARK: - SearchResultTagDetailContentPresenter API
extension SearchResultTagDetailContentPresenter: SearchResultTagDetailContentPresenterApi {
  func handleFollowAction() {
    interactor.performFollowAction()
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
  
  func presentTag(_ tag: TagProtocol) {
    let vm = SearchResultTagDetailContent.TagDetailViewModel(tag: tag)
    viewController.setTagViewModel(vm, animated: true)
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeedTagViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    return SearchResultTagDetailContent.TagViewModel(tag: item, isPromoted: false)
  }
}

// MARK: - SearchResultTagDetailContent Viper Components
fileprivate extension SearchResultTagDetailContentPresenter {
    var viewController: SearchResultTagDetailContentViewControllerApi {
        return _viewController as! SearchResultTagDetailContentViewControllerApi
    }
    var interactor: SearchResultTagDetailContentInteractorApi {
        return _interactor as! SearchResultTagDetailContentInteractorApi
    }
    var router: SearchResultTagDetailContentRouterApi {
        return _router as! SearchResultTagDetailContentRouterApi
    }
}
