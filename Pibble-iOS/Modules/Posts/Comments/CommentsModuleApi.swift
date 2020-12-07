//
//  CommentsModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - CommentsRouter API

protocol CommentsRouterApi: RouterProtocol {
  func routeToUpVote(delegate: UpVoteDelegateProtocol)
  func routeToUserProfileFor(_ user: UserProtocol)
}

//MARK: - CommentsView API

protocol CommentsViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func cleanUpCommentInputField()
  func setUserPic(_ urlString: String, placeHolderImage: UIImage?)
  func setCommentInputText(_ text: String)
  func setBeginEditingAndScrollTo(_ indexPath: IndexPath)
  func setHeaderViewModel(vm: CommentsHeaderViewModelProtocol?, animated: Bool)
  
  func showDeleteAlert()
}

//MARK: - CommentsPresenter API

protocol CommentsPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> CommentViewModelProtocol
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func handleCommentTextChanged(_ text: String)
  func handleSendCommentAction(_ text: String)
  func presentCommentSendSuccess()
  func presentUserProfile(_ user: UserProtocol)
  
  func presentCleanedCommentText(_ text: String)
  
  func handleSelectReplyActionAt(_ indexPath: IndexPath)
  func handleUpvoteActionAt(_ indexPath: IndexPath)
  func handleShowUserActionAt(_ indexPath: IndexPath)
  
  func handleShowPostAuthorUser()
  
  func handleDeleteItemActionAt(_ indexPath: IndexPath)
  func handleDeleteCurrentItemAction()
}

//MARK: - CommentsInteractor API

protocol CommentsInteractorApi: InteractorProtocol {
  var indexPathForSelectedItem: IndexPath? { get }
  func selectItemAt(_ indexPath: IndexPath?)
  
  var currentPost: PostingProtocol { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> CommentProtocol
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  func refreshPostingItem()
  
  func createCommentWith(_ text: String)
  func setCommentText(_ text: String)
  
  func isSelectedReplyItemAt(_ indexPath: IndexPath) -> Bool
  func changeSelectedReplyStateForItemAt(_ indexPath: IndexPath)
  func performUpVoteAt(_ indexPath: IndexPath, withAmount: Int)
  
  func performDeleteItemAt(_ indexPath: IndexPath)
}


//MARK: - ViewModels

protocol CommentsHeaderViewModelProtocol {
  var userpicPlaceholder: UIImage? { get }
  var userPic: String { get }
  var attrubutedBody: NSAttributedString { get }
  var date: String { get }
}

protocol CommentViewModelProtocol {
  var username: String { get }
  var userpicPlaceholder: UIImage? { get }
  var userPic: String { get }
  var body: String { get }
  var createdAt: String { get }
  var attrubutedBody: NSAttributedString { get }
  var isReplyComment: Bool { get }
  var isSelectedToReply: Bool { get }
  var isUpVoted: Bool { get }
  var brushedCountTitle: String { get }
  var isUpVoteEnabled: Bool { get }
  
  var canBeEdited: Bool { get }
  
  var isInteractionEnabled: Bool { get }
}
