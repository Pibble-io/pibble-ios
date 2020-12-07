//
//  LeaderboardContentModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//
import UIKit

//MARK: - LeaderboardContentRouter API
protocol LeaderboardContentRouterApi: RouterProtocol {
  func routeToUserProfileFor(_ user: UserProtocol)
  func routeToUserWinPostsFor(_ user: UserProtocol)
}

//MARK: - LeaderboardContentView API
protocol LeaderboardContentViewControllerApi: ViewControllerProtocol {
  func reloadData()
  func updateCollection(_ updates: CollectionViewModelUpdate)
  
  func setHeaderViewModels(_ vm: [LeaderboardEntryViewModelProtocol]?, animated: Bool)
}

//MARK: - LeaderboardContentPresenter API
protocol LeaderboardContentPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> LeaderboardContent.ItemViewModel
  
  func handleSelectActionAt(_ indexPath: IndexPath)
  func handleShowUserWinPostsActionAt(_ indexPath: IndexPath)
  
  func handleTopSelectActionAt(_ index: Int)
  func handleShowTopUserWinPostsActionAt(_ index: Int)
  
  
  func presentReload()
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  
  func presentTopItems(_ leaderBoardEntries: [LeaderboardEntryProtocol])
}

//MARK: - LeaderboardContentInteractor API
protocol LeaderboardContentInteractorApi: InteractorProtocol {
  var listStartItemPlaceIndex: Int { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> LeaderboardEntryProtocol?
 
  func topItemAt(_ indexPath: IndexPath) -> LeaderboardEntryProtocol?
  
  func prepareItemFor(_ indexPath: IndexPath)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
   
}

protocol LeaderboardEntryViewModelProtocol {
  var username: String { get }
  var avatarPlaceholder: UIImage? { get }
  var avatarURLString: String { get }
  var leaderboardValue: String { get }
  var leaderboardPlace: String { get }
}
