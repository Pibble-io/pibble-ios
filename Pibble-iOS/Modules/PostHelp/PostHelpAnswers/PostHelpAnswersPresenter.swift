//
//  PostHelpAnswersPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - PostHelpAnswersPresenter Class
final class PostHelpAnswersPresenter: Presenter {
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
  
  override func viewDidAppear() {
    super.viewDidAppear()
    interactor.initialRefresh()
  }
 
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    interactor.refreshPostHelpRequestItem()
  }
}

// MARK: - PostHelpAnswersPresenter API
extension PostHelpAnswersPresenter: PostHelpAnswersPresenterApi {
  var canPickAnswers: Bool {
    let isHelpClosed = interactor.currentPostHelpRequest.isHelpClosed
    let isCurrentUserHelp = interactor.currentPostHelpRequest.helpForUser?.isCurrent ?? false
    
    return !isHelpClosed && isCurrentUserHelp
  }
  
  func handlePickItemActionAt(_ indexPath: IndexPath) {
    interactor.performPickAnswerItemAt(indexPath)
  }
  
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
    guard let user = item.answerUser else {
      return
    }
    
    router.routeToUserProfileFor(user)
  }
  
  func handleShowPostHelpAuthorUser() {
    guard let user = interactor.currentPostHelpRequest.helpForUser else {
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
    guard let user = item.answerUser else {
      return
    }
    
    viewController.setCommentInputText("@\(user.userName) ")
  }
  
  func handleAnswerTextChanged(_ text: String) {
    interactor.setAnswerText(text)
  }
  
  func handleSendAnswerAction(_ text: String) {
    interactor.createAnswerWith(text)
  }
  
  func presentCleanedAnswerText(_ text: String) {
    viewController.setCommentInputText(text)
  }
  
  func presentUserProfile(_ user: UserProtocol) {
    let placeholderImage = UIImage.avatarImageForNameString(user.userName)
    viewController.setUserPic(user.userpicUrlString, placeHolderImage: placeholderImage)
  }
  
  func presentAnswerSendSuccess() {
    viewController.cleanUpCommentInputField()
  }
  
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
  
 
  func presentPostHelpRequest(_ postHelpRequest: PostHelpRequestProtocol?) {
    guard let postHelpRequest = postHelpRequest else {
      viewController.setHeaderViewModel(vm: nil, animated: false)
      return
    }
    
    viewController.setHeaderViewModel(vm: PostHelpAnswers.PostHelpAnswersHeaderViewModel(postHelpRequest: postHelpRequest), animated: isPresented)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.section)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> PostHelpAnswerViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    let isSelectedToReply = interactor.isSelectedReplyItemAt(indexPath)
    return PostHelpAnswers.AnswerViewModel(answer: item,
                                           isSelectedToReply: isSelectedToReply,
                                           postHelpRequset: interactor.currentPostHelpRequest)
  }
  
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
 
}

// MARK: - PostHelpAnswers Viper Components
fileprivate extension PostHelpAnswersPresenter {
    var viewController: PostHelpAnswersViewControllerApi {
        return _viewController as! PostHelpAnswersViewControllerApi
    }
    var interactor: PostHelpAnswersInteractorApi {
        return _interactor as! PostHelpAnswersInteractorApi
    }
    var router: PostHelpAnswersRouterApi {
        return _router as! PostHelpAnswersRouterApi
    }
}

//MARK:- Helpers

extension PostHelpAnswersPresenter {
  
}

//MARK:- UpVoteDelegateProtocol

extension PostHelpAnswersPresenter: UpVoteDelegateProtocol {
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
