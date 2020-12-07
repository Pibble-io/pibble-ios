//
//  LeaderboardContentPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - LeaderboardContentPresenter Class
final class LeaderboardContentPresenter: Presenter {
  //MARK:- Overrides:
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
    viewController.setHeaderViewModels(nil, animated: false)
    interactor.initialRefresh()
  }
}

// MARK: - LeaderboardContentPresenter API
extension LeaderboardContentPresenter: LeaderboardContentPresenterApi {
  func handleShowUserWinPostsActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemAt(indexPath),
      let user = item.leaderboardUser
    else {
      return
    }
    
    router.routeToUserWinPostsFor(user)
  }
  
  func handleShowTopUserWinPostsActionAt(_ index: Int) {
    let indexPath = IndexPath(item: index, section: 0)
    
    guard let item = interactor.topItemAt(indexPath),
      let user = item.leaderboardUser
    else {
      return
    }
    
    router.routeToUserWinPostsFor(user)
  }
  
  func presentTopItems(_ leaderBoardEntries: [LeaderboardEntryProtocol]) {
    let viewModels = leaderBoardEntries
      .enumerated()
      .map {
        return LeaderboardContent.LeaderboardEntryItemViewModel(leaderboardEntry: $0.element, place: $0.offset + 1)
      }
    
    viewController.setHeaderViewModels(viewModels, animated: isPresented)
  }
  
  func presentReload() {
    viewController.reloadData()
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
  
  func itemViewModelAt(_ indexPath: IndexPath) -> LeaderboardContent.ItemViewModel {
    guard let item = interactor.itemAt(indexPath) else {
      return .loadingPlaceholder
    }
    
    let viewModel = LeaderboardContent.LeaderboardEntryItemViewModel(leaderboardEntry: item,
                                                                     place: indexPath.item + interactor.listStartItemPlaceIndex)
    return .leaderboardEntry(viewModel)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.item)
  }
  
  func handleSelectActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemAt(indexPath),
      let user = item.leaderboardUser
    else {
      return
    }
    
    router.routeToUserProfileFor(user)
  }
  
  func handleTopSelectActionAt(_ index: Int) {
    let indexPath = IndexPath(item: index, section: 0)
    
    guard let item = interactor.topItemAt(indexPath),
      let user = item.leaderboardUser
    else {
      return
    }
    
    router.routeToUserProfileFor(user)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
}

// MARK: - LeaderboardContent Viper Components
fileprivate extension LeaderboardContentPresenter {
  var viewController: LeaderboardContentViewControllerApi {
    return _viewController as! LeaderboardContentViewControllerApi
  }
  var interactor: LeaderboardContentInteractorApi {
    return _interactor as! LeaderboardContentInteractorApi
  }
  var router: LeaderboardContentRouterApi {
    return _router as! LeaderboardContentRouterApi
  }
}
