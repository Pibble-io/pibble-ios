//
//  UpvotedUsersModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import UIKit

//MARK: - UpvotedUsersRouter API
protocol UpvotedUsersRouterApi: RouterProtocol {
  func routeToUserProfileFor(_ user: UserProtocol)
  func routeToUpVote(delegate: UpVoteDelegateProtocol, purpose: UpVote.UpvotePurpose)
}

//MARK: - UpvotedUsersView API
protocol UpvotedUsersViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
}

//MARK: - UpvotedUsersPresenter API
protocol UpvotedUsersPresenterApi: PresenterProtocol {
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> UpvotedUserViewModelProtocol
  
  func handleSelectionAt(_ indexPath: IndexPath)
  func handleUpvoteBackActionAt(_ indexPath: IndexPath)
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  func presentReload()
  
  func handleHideAction()
  
  func handleActionAt(_ indexPath: IndexPath, aciton: UpvotedUsers.ItemsAction)
}

//MARK: - UpvotedUsersInteractor API
protocol UpvotedUsersInteractorApi: InteractorProtocol {
  var unvotedContentType: UpvotedUsers.UpvotedContentType { get }
  
  func selectItemAt(_ indexPath: IndexPath)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> UpvoteProtocol

  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  
  func performInPlaceUpvoteForSelectedItem()
  func performUpvoteForSelectedItem(_ amount: Int)
  func performFollowingActionAt(_ indexPath: IndexPath)
}

protocol UpvotedUserViewModelProtocol {
  var username: String { get }
  var userpicUrlString: String { get }
  var usrepicPlaceholder: UIImage? { get }
  var upvotedAmount: String { get }
  
  var followingTitle: String { get }
  var isFollowButtonHighlighted: Bool { get }
  
  var upvoteBackAmount: String { get }
  var isUpvoteBackVisible: Bool { get }
  
  var isFollowButtonVisible: Bool { get }
  
}

protocol UpvotePickDelegateProtocol: class {
  func didSelectPostUpvote(upvote: UpvoteProtocol)
}
