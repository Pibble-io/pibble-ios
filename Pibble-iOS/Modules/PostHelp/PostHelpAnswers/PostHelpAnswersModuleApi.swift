//
//  PostHelpAnswersModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - PostHelpAnswersRouter API
protocol PostHelpAnswersRouterApi: RouterProtocol {
  func routeToUpVote(delegate: UpVoteDelegateProtocol)
  func routeToUserProfileFor(_ user: UserProtocol)
}

//MARK: - PostHelpAnswersView API
protocol PostHelpAnswersViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func cleanUpCommentInputField()
  func setUserPic(_ urlString: String, placeHolderImage: UIImage?)
  func setCommentInputText(_ text: String)
  func setBeginEditingAndScrollTo(_ indexPath: IndexPath)
  func setHeaderViewModel(vm: PostHelpAnswersHeaderViewModelProtocol?, animated: Bool)
  
  func showDeleteAlert()
}

//MARK: - PostHelpAnswersPresenter API
protocol PostHelpAnswersPresenterApi: PresenterProtocol {
  var canPickAnswers: Bool { get }
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> PostHelpAnswerViewModelProtocol
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func handleAnswerTextChanged(_ text: String)
  func handleSendAnswerAction(_ text: String)
 
  func handleSelectReplyActionAt(_ indexPath: IndexPath)
  func handleUpvoteActionAt(_ indexPath: IndexPath)
  func handleShowUserActionAt(_ indexPath: IndexPath)
  
  func handleShowPostHelpAuthorUser()
  
  func handleDeleteItemActionAt(_ indexPath: IndexPath)
  func handleDeleteCurrentItemAction()
  
  func handlePickItemActionAt(_ indexPath: IndexPath)
  
  
  func presentAnswerSendSuccess()
  func presentUserProfile(_ user: UserProtocol)
  
  func presentCleanedAnswerText(_ text: String)
  
  func presentPostHelpRequest(_ postHelpRequest: PostHelpRequestProtocol?)
}

//MARK: - PostHelpAnswersInteractor API
protocol PostHelpAnswersInteractorApi: InteractorProtocol {
  var indexPathForSelectedItem: IndexPath? { get }
  func selectItemAt(_ indexPath: IndexPath?)
  
  var currentPostHelpRequest: PostHelpRequestProtocol { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> PostHelpAnswerProtocol
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  func refreshPostHelpRequestItem()
  
  func createAnswerWith(_ text: String)
  func setAnswerText(_ text: String)
  
  func isSelectedReplyItemAt(_ indexPath: IndexPath) -> Bool
  func changeSelectedReplyStateForItemAt(_ indexPath: IndexPath)
  func performUpVoteAt(_ indexPath: IndexPath, withAmount: Int)
  
  func performDeleteItemAt(_ indexPath: IndexPath)
  
  func performPickAnswerItemAt(_ indexPath: IndexPath)
}

protocol PostHelpAnswersHeaderViewModelProtocol {
  var userpicPlaceholder: UIImage? { get }
  var userPic: String { get }
  var attrubutedBody: NSAttributedString { get }
  var date: String { get }
}

protocol PostHelpAnswerViewModelProtocol {
  var username: String { get }
  var userpicPlaceholder: UIImage? { get }
  var userPic: String { get }
  var body: String { get }
  var createdAt: String { get }
  var attrubutedBody: NSAttributedString { get }
  var isReplyAnswer: Bool { get }
  var isSelectedToReply: Bool { get }
  var isUpVoted: Bool { get }
  var brushedCountTitle: String { get }
  var isUpVoteEnabled: Bool { get }
  
  var helpRewardAmount: String { get }
  
  var canBeEdited: Bool { get }
  var canBePicked: Bool { get }
  
  var isPicked: Bool { get }
  
  var isInteractionEnabled: Bool { get }
}
