//
//  PostsFeedGridPresenter.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVKit

// MARK: - PostsFeedGridPresenter Class
final class PostsFeedGridPresenter: Presenter {
  fileprivate var upVoteIndexPath: IndexPath?
  fileprivate var donateIndexPath: IndexPath?
  fileprivate var upvotedUsersActionAtMyPosting: Bool?
  
  fileprivate var upVoteUser: UserProtocol?
  fileprivate var additionalActionsIndexPath: IndexPath?
  fileprivate var cachedSectionViewModels: [Int: (vm: PostsFeed.ItemViewModelType, itemId: Int)] = [:]
  
  fileprivate var lastRefreshDate: Date = Date(timeIntervalSince1970: 0.0)
  fileprivate var refreshTimeinterval: TimeInterval = TimeInterval.minutesInterval(5)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    viewController.setWalletPreviewContainerPresentation(true, animated: false)
    
    if abs(lastRefreshDate.timeIntervalSinceNow) > refreshTimeinterval {
      lastRefreshDate = Date()
      interactor.initialRefresh()
    }
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
  }
  
  override func willResignActive() {
    super.willResignActive()
    cachedSectionViewModels.removeAll()
    AVPlayer.pauseCurrentlyPlaying()
    
    lastRefreshDate = Date()
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    //need to always refresh because access token will be refreshed at this moment
    lastRefreshDate = Date()
    viewController.setFetchingStarted()
    interactor.initialRefresh()
  }
  
  override func presentInitialState() {
    super.presentInitialState()
     
    viewController.scrollToTop(animated: true)
    if abs(lastRefreshDate.timeIntervalSinceNow) > refreshTimeinterval {
      lastRefreshDate = Date()
      viewController.setFetchingStarted()
      interactor.initialRefresh()
    }
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    AVPlayer.pauseCurrentlyPlaying()
    
    
    
    lastRefreshDate = Date()
  }
}

// MARK: - PostsFeedGridPresenter API
extension PostsFeedGridPresenter: PostsFeedPresenterApi {
  //not supported
  func handlePlayRoomAction() {
    
  }
  
  //not supported
  func handleGiftAction() {
    
  }
  
  //not supported
  func handleCancelPostHelpCreationAction() {
    
  }
  
  //not supported
  func handleConfirmPostHelpCreationAction() {
    
  }
  
  //not supported
  func handleHelpActionAt(_ indexPath: IndexPath)  {
    
  }
  
  //not supported
  func presentStopFundingSuccess() {
    
  }
  
  //not supported
  func handleCurrentItemStopFundingConfirmAction() {
    
  }
  
  //not supported
  func presentDonationSuccess() {
    
  }
  
  //not supported
  func handleCurrentItemShowFundingDetailsAction() {
    
  }
  
  //not supported
  func handleCurrentItemShowFundingDonatorsAction() {
    
  }
  
  //not supported
  func handleCancelOrderCreationAction() {
    
  }
  
  //not supported
  func handleConfirmOrderCreationAction() {
    
  }
  
  //not supported
  func presentOrderCreationSuccess() {
    
  }
  
  //not supported
  func handleCurrentItemShowEngagementAction() {
    
  }
  
  //not supported
  func handleLeaderbordAction() {
    
  }
  
  //not supported
  func handleTopBannerInfoAction() {
    
  }
  
  //not supported
  func handleTopGroupSelectionAt(_ indexPath: IndexPath) {
    
  }
  
   //not supported
  func presentTopGroups(_ groups: [TopGroup], selectedGroup: TopGroupPostsType?) {
    
  }
  
  
  //not supported
  func handleShowCampaignActionAt(_ indexPath: IndexPath) {
    
  }
  
  // not supported
  func handleCurrentItemPausePromotionConfirmAction() {
    
  }
  
  // not supported
  func handleCurrentItemResumePromotionConfirmAction() {
    
  }
  
  // not supported
  func handleCurrentItemClosePromotionConfirmAction() {
    
  }
  
  // not supported
  func handleShowDestinationActionAt(_ indexPath: IndexPath) {
    
  }
  
  // not supported
  func handleCurrentItemPausePromotionAction() {
    
  }
  
  // not supported
  func handleCurrentItemResumePromotionAction() {
    
  }
  
  // not supported
  func handleCurrentItemStopPromotionAction() {
    
  }
  
  // not supported
  func handleCurrentItemShowInsightAction() {
    
  }
  
  // not supported
  func handlePausePromotionActionAt(_ indexPath: IndexPath) {
    
  }
  
  // not supported
  func handleResumePromotionActionAt(_ indexPath: IndexPath) {
    
  }
  
  // not supported
  func handleStopPromotionActionAt(_ indexPath: IndexPath) {
    
  }
  
  // not supported
  func handleShowInsightActionAt(_ indexPath: IndexPath) {
    
  }
  
  // not supported
  func handleAddPromotionActionAt(_ indexPath: IndexPath) {
    
  }
  // not supported
  func handleShowEngagementActionAt(_ indexPath: IndexPath) {
    
  }
  
  var navigationBarTitle: String {
    switch interactor.currentFeedType {
    case .main:
      return ""
    case .userPosts(_):
      return ""
    case .singlePost(_):
      return ""
    case .favoritesPosts(_):
      return ""
    case .upvotedPosts(_):
      return ""
    case .discover, .discoverDetailFeedFor:
      return ""
    case .postsRelatedToTag(_):
      return ""
    case .postsRelatedToPlace(_):
      return ""
    case .currentUserCommercePosts(_):
      return PostsFeed.Strings.NavigationBarTitles.currentUserCommercePosts.localize()
    case .currentUserPurchasedCommercePosts(_):
      return PostsFeed.Strings.NavigationBarTitles.currentUserPurchasedPosts.localize()
    case .userPromotedPosts(_, _):
      return ""
    case .topGroupsPosts:
      return ""
    case .winnerPosts:
      return ""
    case .currentUserActiveFundingPosts(_):
      return ""
    case .currentUserEndedFundingPosts(_):
      return ""
    case .currentUserBackedFundingPosts(_):
      return ""
    }
  }
  

  //action is not supported
  func handleCurrentItemAddPromotionAction() { }
  
  
  //action is not supported
  func createDigitalGoodPostAction() { }
  
  //action is not supported
  func handleZoomActionAt(_ indexPath: IndexPath, mediaItemIndex: Int) {  }
  
  //action is not supported
  func handleReportActionAt(_ indexPath: IndexPath) { }
  
  //action is not supported
  func handleCurrentItemReportAction() { }
  
  //action is not supported
  func handleCurrentItemBlockReportAction() { }
  
  //action is not supported
  func handleInappropriateReportActionAt(_ indexPath: IndexPath) {  }
  
  //action is not supported
  func handleSpamReportActionAt(_ indexPath: IndexPath) {  }
  
  //action is not supported
  func handleCurrentItemInappropriateReportAction() { }
  
  //action is not supported
  func handleCurrentItemSpamReportAction() {   }
  
  //handleLikeInPlaceActionAt is not supported
  func handleLikeInPlaceActionAt(_ indexPath: IndexPath) {  }
  
  //delete is not supported
  func handleCurrentItemDeletePostCheckFundsActionAt(_ indexPath: IndexPath) { }
  
  //delete is not supported
  func handleCurrentItemDeletePostCheckFundsAction() { }
  
   // grid presenter does not support invoice
  func presentInvoicePaymentSuccess() {  }
  
  // grid presenter does not support invoices actions
  func handleCancelCurrentInvoiceAction() {  }
  // grid presenter does not support invoices actions
  func handleConfirmCurrentInvoiceAction() {   }
  
  // grid presenter does not support profile presentation
  func presentCurrentUserProfile(_ user: AccountProfileProtocol) { }
  
  //notifications action is not supported in grid presenter
  func handleNotificationsActionWith(_ transition: GestureInteractionController) {  }
  
  //notifications action is not supported in grid presenter
  func handleNotificationsAction() {  }
  
  //digital good details action is not supported in grid presenter
  func handleCommercePostDetailsActionAt(_ indexPath: IndexPath) { }
  
  //chat action is not supported in grid presenter
  func handleChatActionAt(_ indexPath: IndexPath) {  }
  
  //upload state action is not supported in grid presenter
  func handleCancelUploadActionAt(_ indexPath: IndexPath) {  }
  //upload state action is not supported in grid presenter
  func handleRestartUploadActionAt(_ indexPath: IndexPath) { }
  
  //editing is not supported in grid presenter
  func handleDeletePostActionAt(_ indexPath: IndexPath) {  }
  //editing is not supported in grid presenter
  func handleCurrentItemDeletePostAction() {  }
  
  //editing is not supported in grid presenter
  func presentPostDescriptionEditSuccess() {  }
  
  //editing is not supported in grid presenter
  func handeEditDoneAction() { }
  
  //editing is not supported in grid presenter
  func handleEditDescriptionTextChangedAt(_ indexPath: IndexPath, text: String) { }
  
   //location edit is not supported
  func handleCurrentItemEditLocationAction() {  }
  
  //location edit is not supported
  func handleCurrentItemRemoveLocationAction() {  }
  
  //location edit is not supported
  func handleEditLocationActionAt(_ indexPath: IndexPath) {  }
  
  //location edit is not supported
  func handleRemoveLocationActionAt(_ indexPath: IndexPath) {  }
  
  //location selection is not supported
  func handleLocationSelectionActionAt(_ indexPath: IndexPath) {  }
  
  //editing is not supported in grid presenter
  func handleEditPostTagsActionAt(_ indexPath: IndexPath) { }
  
  //editing is not supported in grid presenter
  func handleCurrentItemEditPostTagsAction() { }
  
  //editing is not supported in grid presenter
  func handleEditPostCaptionActionAt(_ indexPath: IndexPath) { }
 
  //editing is not supported in grid presenter
  func handleCurrentItemEditPostCaptionAction() {  }
  
  func handleCommentSelectionActionAt(_ indexPath: IndexPath) {  }
  
  var isWalletPreviewPresented: Bool {
    return false
  }
  
  func handleTagSelectionActionAt(_ indexPath: IndexPath, tagIndexPath: IndexPath) {  }
  
  func handleSelectionActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.item) else {
      return
    }
    
    interactor.trackViewItemEventAt(indexPath.item)
    switch interactor.currentFeedType {
    case .discover:
      router.routeToDiscoverPostDetailFor(item)
    default:
      router.routeToPostingDetailFor(item, currentFeedType: interactor.currentFeedType)
    }
    
    
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleUserProfileActionAt(_ indexPath: IndexPath) {  }
  
  func handleUpvotedUsersActionAt(_ indexPath: IndexPath) {  }
  
  func handleCommentPostingActionAt(_ indexPath: IndexPath, text: String) { }
  
  func handleAddCommentTextChangedAt(_ indexPath: IndexPath, text: String) {  }
  
  func handleStopScrollingWithVisible(_ indexPaths: [IndexPath]) {  }
  
  func handleStartScrolling() {  }
  
  func handleTap() {  }
  
  func presentFetchingFinished() {
    viewController.setFetchingFinished()
  }
  
  func handlePullToRefresh() {
    lastRefreshDate = Date()
    interactor.initialRefresh()
  }
  
  func handleFriendActionAt(_ indexPath: IndexPath) { }
  
  
  //not supported
  func handleCopyLinkActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleShareActionAt(_ indexPath: IndexPath) {  }
  
  func handleMuteActionAt(_ indexPath: IndexPath) {
    interactor.performMuteActionAt(indexPath.section)
  }
  
  func handleCurrentItemFollowAction() {  }
  
  func handleCurrentItemFriendAction() {  }
  
  func handleCurrentItemShareAction() {
    guard let indexPath = additionalActionsIndexPath else {
      return
    }
    
    handleShareActionAt(indexPath)
    additionalActionsIndexPath = nil
  }
  
  func handleCurrentItemCopyLinkAction() {
    
  }
  
  func handleCurrentItemMuteAction() {
    guard let indexPath = additionalActionsIndexPath else {
      return
    }
    
    handleMuteActionAt(indexPath)
    additionalActionsIndexPath = nil
  }
  
  func handleAdditionalActionAt(_ indexPath: IndexPath) {
    guard let vmType = itemViewModelAt(indexPath) else {
      return
    }
    
    guard case let PostsFeed.ItemViewModelType.user(vm) = vmType else {
      return
    }
    
    guard let posting = interactor.itemFor(indexPath.item) else {
      return
    }
    
    additionalActionsIndexPath = indexPath
    
    guard posting.isMyPosting else {
      viewController.showPostingOptionsActionSheet(vm)
      return
    }
    
    viewController.showMyPostingOptionsActionSheet()
  }
  
  func handleFavoritesActionAt(_ indexPath: IndexPath) {   }
  
  func handleWalletAction() { }
  
  func handleLikeActionAt(_ indexPath: IndexPath) {
    upVoteIndexPath = indexPath
    router.routeToUpVote(delegate: self, purpose: .posting)
  }
  
  func handleFollowActionAt(_ indexPath: IndexPath) {  }
  
  func handleShowAllCommentsActionAt(_ indexPath: IndexPath) {
    guard let posting = interactor.itemFor(indexPath.item) else {
      return
    }
   
    router.routeToCommentsFor(posting)
  }
  
  func handlePrefetchItemAt(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.item)
    let _ = prepareSectionViewModelFor(indexPath.item)
  }
  
  func handleCancelPrefetchingItem(_ indexPath: IndexPath) {
    removePreparedSectionViewModelFor(indexPath.item)
    interactor.cancelPrepareItemFor(indexPath.item)
  }
  
  func handleJoinTeamActionAt(_ indexPath: IndexPath) {  }
  
  func handleDonateActionAt(_ indexPath: IndexPath) { }
  
  
  func presentCollectionReload() {
    viewController.reloadData()
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    switch updates {
    case .reloadData:
      cachedSectionViewModels = [:]
      viewController.updateCollection(updates)
    case .beginUpdates:
      viewController.updateCollection(updates)
    case .endUpdates:
      viewController.updateCollection(updates)
    case .insert(let indexPaths):
      indexPaths.forEach {
        cachedSectionViewModels.removeValue(forKey: $0.item)
      }
      viewController.updateCollection(.insert(idx: indexPaths))
    case .delete(let indexPaths):
      indexPaths.forEach {
        cachedSectionViewModels.removeValue(forKey: $0.item)
      }
      viewController.updateCollection(.delete(idx: indexPaths))
    case .insertSections(_):
      break
    case .deleteSections(_):
      break
    case .updateSections(_):
      break
    case .moveSections(_, _):
      break
    case .update(let indexPaths):
      indexPaths.forEach {
        if let posting = interactor.itemFor($0.item),
          let oldVM = cachedSectionViewModels[$0.item],
          oldVM.itemId == posting.identifier {
          cachedSectionViewModels[$0.item]  = nil
          
          if let newViewModel = prepareSectionViewModelFor($0.item),
            newViewModel.identifier != oldVM.vm.identifier {
            viewController.updateCollection(.update(idx: [$0]))
          }
        }
      }
      
    case .move(let from, let to):
      viewController.updateCollection(.move(from: from, to: to))
    }
  }
  
  func numberOfSections() -> Int {
    return 1
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    let numberOfItems = interactor.numberOfItems()
    return numberOfItems
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeed.ItemViewModelType? {
    let itemVM = prepareSectionViewModelFor(indexPath.item)
    return itemVM
  }
}

// MARK: - PostsFeed Viper Components
fileprivate extension PostsFeedGridPresenter {
  var viewController: PostsFeedViewControllerApi {
    return _viewController as! PostsFeedViewControllerApi
  }
  var interactor: PostsFeedInteractorApi {
    return _interactor as! PostsFeedInteractorApi
  }
  var router: PostsFeedRouterApi {
    return _router as! PostsFeedRouterApi
  }
}

//MARK:- Optimisation PostingProtocol extension


extension PostsFeedGridPresenter {
  fileprivate func prepareSectionViewModelFor(_ itemIndex: Int) -> PostsFeed.ItemViewModelType? {
    guard let posting = interactor.itemFor(itemIndex) else {
      return nil
    }
    
    guard let itemVMType = cachedSectionViewModels[itemIndex],
      itemVMType.itemId == posting.identifier
    else {
      let itemVM = PostsFeed.ItemViewModelType.gridItemViewModelFor(posting,
                                                                      userRequest: interactor.requestUser)
      cachedSectionViewModels[itemIndex] = (itemVM, posting.identifier)
      return itemVM
    }
   
    return itemVMType.vm
  }
  
  fileprivate func removePreparedSectionViewModelFor(_ itemIndex: Int) {
    cachedSectionViewModels.removeValue(forKey: itemIndex)
  }
  
  fileprivate func presentAddCommentFor(_ indexPath: [IndexPath]) {
    guard indexPath.count > 0 else {
      return
    }
    
    let midElementIndex = Int(Double(indexPath.count - 1) / 2.0)
    let targetItem = indexPath[midElementIndex]
    
    interactor.setCommentDraftFor(targetItem.section, text: "")
  }
}

extension PostsFeedGridPresenter: UpvotePickDelegateProtocol {
  func didSelectPostUpvote(upvote: UpvoteProtocol) {
    guard let selectedPostUpvoteAtMyPosting = upvotedUsersActionAtMyPosting, selectedPostUpvoteAtMyPosting else {
      return
    }
    upvotedUsersActionAtMyPosting = nil
    upVoteUser = upvote.upvotedUser
  
    router.routeToUpVote(delegate: self, purpose: UpVote.UpvotePurpose.user(upvote.upvoteAmount))
  }
}

//MARK:- UpVoteDelegateProtocol

extension PostsFeedGridPresenter: UpVoteDelegateProtocol {
  func isPromoted() -> Bool {
    return false
  }

  func shouldUpVoteWithAmount(_ amount: Int) {
    
  }
}

//MARK:- DonateDelegateProtocol

extension PostsFeedGridPresenter: DonateDelegateProtocol, FundingDetailDelegateProtocol {
  //not supported
  func shouldCreateFundingPostWithTeam(_ team: FundingCampaignTeamProtocol) {
    
  }
  
  func shouldStopFindingCampaign() {
    //not supported
  }
  
  func shouldDonateWithBalance(_ balance: BalanceProtocol, price: Double?) {
    //donates are not supported for this presenter
  }
}
