//
//  CommentsPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - CommentsPresenter Class

final class CommentsPresenter: Presenter {
  fileprivate var upVoteIndexPath: IndexPath? {
    get {
      return interactor.indexPathForSelectedItem
    }
    
    set {
      interactor.selectItemAt(newValue)
    }
  }
  
  fileprivate var deleteIndexPath: IndexPath? {
    get {
      return interactor.indexPathForSelectedItem
    }
    
    set {
      interactor.selectItemAt(newValue)
    }
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    setHeaderViewModel()
    interactor.initialRefresh()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    interactor.refreshPostingItem()
  }
}

// MARK: - CommentsPresenter API

extension CommentsPresenter: CommentsPresenterApi {
  func handleDeleteCurrentItemAction() {
    guard let indexPath = deleteIndexPath else {
      return
    }
    
    interactor.performDeleteItemAt(indexPath)
  }
  
  func handleDeleteItemActionAt(_ indexPath: IndexPath) {
    deleteIndexPath = indexPath
    viewController.showDeleteAlert()
  }
  
  func handleShowUserActionAt(_ indexPath: IndexPath) {
    let item = interactor.itemAt(indexPath)
    guard let user = item.commentUser else {
      return
    }
    
    router.routeToUserProfileFor(user)
  }
  
  func handleShowPostAuthorUser() {
    guard let user = interactor.currentPost.postingUser else {
      return
    }
    
    router.routeToUserProfileFor(user)
  }
  
  func handleUpvoteActionAt(_ indexPath: IndexPath) {
    let item = interactor.itemAt(indexPath)
    guard !item.isUpVotedByUser else {
      return
    }
    
    upVoteIndexPath = indexPath
    router.routeToUpVote(delegate: self)
  }
  
  func handleSelectReplyActionAt(_ indexPath: IndexPath) {
    interactor.changeSelectedReplyStateForItemAt(indexPath)
    guard interactor.isSelectedReplyItemAt(indexPath) else {
      viewController.cleanUpCommentInputField()
      return
    }
    
    let item = interactor.itemAt(indexPath)
    viewController.setBeginEditingAndScrollTo(indexPath)
    guard let user = item.commentUser else {
      return
    }
    
    viewController.setCommentInputText("@\(user.userName) ")
  }
  
  func handleCommentTextChanged(_ text: String) {
    interactor.setCommentText(text)
  }
  
  func presentCleanedCommentText(_ text: String) {
    viewController.setCommentInputText(text)
  }
  
  func presentUserProfile(_ user: UserProtocol) {
    let placeholderImage = UIImage.avatarImageForNameString(user.userName)
    viewController.setUserPic(user.userpicUrlString, placeHolderImage: placeholderImage)
  }
  
  func presentCommentSendSuccess() {
    viewController.cleanUpCommentInputField()
  }
  
  func handleSendCommentAction(_ text: String) {
    interactor.createCommentWith(text)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> CommentViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    let isSelectedToReply = interactor.isSelectedReplyItemAt(indexPath)
    return Comments.CommentViewModel(comment: item, isSelectedToReply: isSelectedToReply)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
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
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.section)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.section)
  }
}

// MARK: - Comments Viper Components

fileprivate extension CommentsPresenter {
  var viewController: CommentsViewControllerApi {
    return _viewController as! CommentsViewControllerApi
  }
  
  var interactor: CommentsInteractorApi {
    return _interactor as! CommentsInteractorApi
  }
  
  var router: CommentsRouterApi {
    return _router as! CommentsRouterApi
  }
}

//MARK:- Helpers

extension CommentsPresenter {
  fileprivate func setHeaderViewModel() {
    viewController.setHeaderViewModel(vm: Comments.CommentsHeaderViewModel(post: interactor.currentPost), animated: false)
  }
}

//MARK:- UpVoteDelegateProtocol

extension CommentsPresenter: UpVoteDelegateProtocol {
  func isPromoted() -> Bool {
    return false
  }
  
  func shouldUpVoteWithAmount(_ amount: Int) {
    guard let indexPath = upVoteIndexPath else {
      return
    }
    
    interactor.performUpVoteAt(indexPath, withAmount: amount)
  }
}
