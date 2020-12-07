//
//  UpvotedUsersPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UpvotedUsersPresenter Class
final class UpvotedUsersPresenter: Presenter {
  fileprivate weak var delegate: UpvotePickDelegateProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
    interactor.initialRefresh()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
  }
  
  init(delegate: UpvotePickDelegateProtocol) {
    self.delegate = delegate
  }
}

// MARK: - UpvotedUsersPresenter API
extension UpvotedUsersPresenter: UpvotedUsersPresenterApi {
  func handleActionAt(_ indexPath: IndexPath, aciton: UpvotedUsers.ItemsAction) {
    let item = interactor.itemAt(indexPath)
    guard let upvotedUser = item.upvotedUser else {
      return
    }
    
    switch aciton {
    case .upvote:
      switch interactor.unvotedContentType  {
      case .posting(let post):
        guard post.isMyPosting else {
          return
        }
        
        interactor.selectItemAt(indexPath)
        router.routeToUpVote(delegate: self, purpose: .user(item.upvoteAmount))
      }
    case .showUser:
      router.routeToUserProfileFor(upvotedUser)
    case .upvoteInPlace:
      switch interactor.unvotedContentType  {
      case .posting(let post):
        guard post.isMyPosting else {
          return
        }
        
        interactor.selectItemAt(indexPath)
        interactor.performInPlaceUpvoteForSelectedItem()
      }
    case .follow:
      interactor.performFollowingActionAt(indexPath)
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleUpvoteBackActionAt(_ indexPath: IndexPath) {
    let item = interactor.itemAt(indexPath)
    delegate?.didSelectPostUpvote(upvote: item)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = interactor.itemAt(indexPath)
    guard let upvotedUser = item.upvotedUser else {
      return
    }
    
    router.routeToUserProfileFor(upvotedUser)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.item)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> UpvotedUserViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    return UpvotedUsers.UpvotedUserViewModel(upvote: item)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
  
  func presentReload() {
    viewController.reloadData()
  }
}


// MARK: - UpvotedUsers Viper Components
fileprivate extension UpvotedUsersPresenter {
    var viewController: UpvotedUsersViewControllerApi {
        return _viewController as! UpvotedUsersViewControllerApi
    }
    var interactor: UpvotedUsersInteractorApi {
        return _interactor as! UpvotedUsersInteractorApi
    }
    var router: UpvotedUsersRouterApi {
        return _router as! UpvotedUsersRouterApi
    }
}

extension UpvotedUsersPresenter: UpVoteDelegateProtocol {
  func isPromoted() -> Bool {
    return false
  }
  
  func shouldUpVoteWithAmount(_ amount: Int) {
    interactor.performUpvoteForSelectedItem(amount)
  }
}
