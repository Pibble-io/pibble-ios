//
//  PostsFeedPreviewPresenter.swift
//  Pibble
//
//  Created by Sergey Kazakov on 07/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import AVKit

// MARK: - PostsFeedPreviewPresenter Class


final class PostsFeedPreviewPresenter: Presenter {
  fileprivate var upVoteIndexPath: IndexPath?
  fileprivate var donateIndexPath: IndexPath?
  fileprivate var editPostIndexPath: IndexPath?
  
  fileprivate var upvotedUsersActionAtMyPosting: Bool?
  
  fileprivate var upVoteUser: UserProtocol?
  fileprivate var requestedInvoice: InvoiceProtocol?
  fileprivate var selectedPost: PostingProtocol?
  
  fileprivate var shouldScrollToPost: PostingProtocol?
  fileprivate var shouldEditPost: PostingProtocol?
  fileprivate var shouldScrollToIndexPath: IndexPath?
  
  fileprivate var shouldEditPostAtIndexPath: IndexPath?
  
  fileprivate var selectedItemIndexPath: IndexPath?
  
  fileprivate var locationActionsIndexPath: IndexPath?
  
  fileprivate let promotionDraft: PromotionDraft
  
  
  fileprivate var cachedSectionViewModels: [Int: (vm: [PostsFeed.ItemViewModelType], itemId: Int)] = [:]
  fileprivate let commentDraftScrollingTimeIntreval: TimeInterval = 3.0
  fileprivate var commentDraftScrollingTimer: Timer? {
    didSet {
      oldValue?.invalidate()
    }
  }
  
  fileprivate let expandFundingScrollingTimeIntreval: TimeInterval = 3.0
  fileprivate var expandFundingScrollingTimer: Timer? {
    didSet {
      oldValue?.invalidate()
    }
  }
  
  fileprivate(set) var isWalletPreviewPresented = false
   
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    if shouldScrollToPost != nil {
      viewController.reloadData()
    }
    isWalletPreviewPresented = false
    viewController.setWalletPreviewContainerPresentation(true, animated: false)
    
    
    if let indexPath = shouldScrollToIndexPath {
      viewController.scrollTo(indexPath, animated: false)
    }
    
    setPlaceholderIfNeeded(animated: false)
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    
    interactor.subscribeWebSocketUpdates()
    interactor.initialRefresh()
    
    if let editIndexPath = shouldEditPostAtIndexPath {
      interactor.setBeingEditedStateAt(editIndexPath.section, isBeingEdited: true)
    }
    
    setPlaceholderIfNeeded(animated: true)
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    cachedSectionViewModels.removeAll()
    AVPlayer.pauseCurrentlyPlaying()
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    viewController.setFetchingStarted()
    interactor.initialRefresh()
  }
  
  override func presentInitialState() {
    super.presentInitialState()
    interactor.initialRefresh()
    viewController.scrollToTop(animated: true)
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    
    AVPlayer.pauseCurrentlyPlaying()
    shouldScrollToIndexPath = nil
    interactor.unsubscribeWebSocketUpdates()
  }
  
  init(promotionDraft: PromotionDraft) {
    self.promotionDraft = promotionDraft
  }
}


// MARK: - PostsFeedPreviewPresenter API
extension PostsFeedPreviewPresenter: PostsFeedPresenterApi {
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
  
  func handleCurrentItemAddPromotionAction() {
    guard let index = interactor.indexForSelectedItem else {
      return
    }
    
    guard let post = interactor.itemFor(index) else {
      return
    }
    
    router.routeToAddPromotion(post: post)
  }
  
  func createDigitalGoodPostAction() {
    router.routeToCreateCommercePost()
  }
  
  var navigationBarTitle: String {
    return PostsFeed.Strings.NavigationBarTitles.postPromotionPreview.localize()
  }
  
  func handleZoomActionAt(_ indexPath: IndexPath, mediaItemIndex: Int) {
    
  }
  
  func handleCurrentItemInappropriateReportAction() {
    
  }
  
  func handleCurrentItemSpamReportAction() {
    
  }
  
  func handleCurrentItemBlockReportAction() {
    
  }
  
  func handleLikeInPlaceActionAt(_ indexPath: IndexPath) {
    
  }
  
  func presentInvoicePaymentSuccess() {
    viewController.presentPurchaseSuccessAlert()
  }
  
  func handleCancelCurrentInvoiceAction() {
    
  }
  
  func handleConfirmCurrentInvoiceAction() {
    
  }
  
  func presentCurrentUserProfile(_ user: AccountProfileProtocol) {
    let messagesBadge = user.unreadChatMessagesCount == 0 ? nil : "\(user.unreadChatMessagesCount)"
    let walletBadge = user.activeInvoicesCount == 0 ? nil : "\(user.activeInvoicesCount)"
    
    viewController.setBadges(notificationBadge: messagesBadge, walletBadge: walletBadge)
  }
  
  
  func handleNotificationsActionWith(_ transition: GestureInteractionController) {
    
  }
  
  func handleNotificationsAction() {
    
  }
  
  func handleCommercePostDetailsActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleChatActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleCancelUploadActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleRestartUploadActionAt(_ indexPath: IndexPath) {
    
  }
  
  func presentPostDescriptionEditSuccess() {
    router.dismiss()
  }
  
  func handeEditDoneAction() {
    
  }
  
  func handleEditDescriptionTextChangedAt(_ indexPath: IndexPath, text: String) {
    
  }
  
  func handleCurrentItemEditLocationAction() {
    
  }
  
  func handleCurrentItemRemoveLocationAction() {
    
  }
  
  func handleEditLocationActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleRemoveLocationActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleLocationSelectionActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleCommentSelectionActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleSelectionActionAt(_ indexPath: IndexPath) { }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleUserProfileActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleUpvotedUsersActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleCommentPostingActionAt(_ indexPath: IndexPath, text: String) {
    
  }
  
  func handleAddCommentTextChangedAt(_ indexPath: IndexPath, text: String) {
    
  }
  
  func handleStopScrollingWithVisible(_ indexPaths: [IndexPath]) {
    
  }
  
  func handleStartScrolling() {
  }
  
  func handleTap() {
    
  }
  
  func presentFetchingFinished() {
    viewController.setFetchingFinished()
  }
  
  func handlePullToRefresh() {
    viewController.setFetchingFinished()
  }
  
  func handleFriendActionAt(_ indexPath: IndexPath) {
    
  }
  
  
  func handleCopyLinkActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleShareActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleEditPostCaptionActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleEditPostTagsActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleDeletePostActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleCurrentItemDeletePostCheckFundsActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleReportActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleMuteActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleCurrentItemFollowAction() {
    
  }
  
  func handleCurrentItemFriendAction() {
    
  }
  
  func handleCurrentItemShareAction() {
    
  }
  
  func handleCurrentItemCopyLinkAction() {
    
  }
  
  func handleCurrentItemReportAction() {
    
  }
  
  func handleCurrentItemMuteAction() {
    
  }
  
  func handleCurrentItemEditPostCaptionAction() {
    
  }
  
  func handleCurrentItemEditPostTagsAction() {
    
  }
  
  func handleCurrentItemDeletePostAction() {
    
  }
  
  func handleCurrentItemDeletePostCheckFundsAction() {
    
  }
  
  
  func handleAdditionalActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleFavoritesActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleWalletAction() {
    
  }
  
  func handleLikeActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleFollowActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleShowAllCommentsActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handlePrefetchItemAt(_ indexPath: IndexPath) {
    
  }
  
  func handleCancelPrefetchingItem(_ indexPath: IndexPath) {
    
  }
  
  func handleJoinTeamActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleDonateActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleTagSelectionActionAt(_ indexPath: IndexPath, tagIndexPath: IndexPath) {

  }
  
  func presentCollectionReload() {
    viewController.reloadData()
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    
    //mapping from item-based collection updates to section-based updates
    switch updates {
    case .reloadData:
      cachedSectionViewModels = [:]
      viewController.updateCollection(updates)
    case .beginUpdates:
      viewController.updateCollection(updates)
    case .endUpdates:
      setPlaceholderIfNeeded(animated: true)
      viewController.updateCollection(updates)
    case .insert(let indexPaths):
      let idx = indexPaths.map { return $0.item }
      idx.forEach {
        cachedSectionViewModels.removeValue(forKey: $0)
      }
      viewController.updateCollection(.insertSections(idx: idx))
    case .delete(let indexPaths):
      let idx = indexPaths.map { return $0.item }
      idx.forEach {
        cachedSectionViewModels.removeValue(forKey: $0)
      }
      viewController.updateCollection(.deleteSections(idx: idx))
    case .insertSections(_):
      break
    case .deleteSections(_):
      break
    case .updateSections(_):
      break
    case .moveSections(_, _):
      break
    case .update(let indexPaths):
      indexPaths
        .map { return $0.item }
        .forEach { section in
          
          //evaluate diff only if the item is the same
          if let posting = interactor.itemFor(section),
            let oldVM = cachedSectionViewModels[section],
            oldVM.itemId == posting.identifier {
            
            //invalidate old vm and create new
            cachedSectionViewModels[section] = nil
            let newViewModel = prepareSectionViewModelFor(section)
            
            //evaluate diff
            let diff = newViewModel.diff(before: oldVM.vm)
            let insert = diff.insertedIndices.map { IndexPath(item: $0, section: section) }
            let delete = diff.deletedIndices.map { IndexPath(item: $0, section: section) }
            let update = diff.updateIndices.map { IndexPath(item: $0, section: section) }
            
            let moves = diff.movedIndices.map {
              return CollectionViewModelUpdate.move(from: IndexPath(item: $0.from, section: section),
                                                    to:  IndexPath(item: $0.to, section: section))
            }
            
            viewController.updateCollection(.insert(idx: insert))
            viewController.updateCollection(.delete(idx: delete))
            viewController.updateCollection(.update(idx: update))
            moves.forEach {
              viewController.updateCollection($0)
            }
            
          } else {
            cachedSectionViewModels[section]  = nil
            viewController.updateCollection(.updateSections(idx: [section]))
          }
      }
    case .move(let from, let to):
      cachedSectionViewModels[from.item] = nil
      cachedSectionViewModels[to.item] = nil
      viewController.updateCollection(.moveSections(from: from.item, to: to.item))
    }
  }
  
  func numberOfSections() -> Int {
    let numberOfItems = interactor.numberOfItems()
    return numberOfItems
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    let items = prepareSectionViewModelFor(section)
    return items.count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeed.ItemViewModelType? {
    let items = prepareSectionViewModelFor(indexPath.section)
    guard indexPath.item < items.count else {
      return nil
    }
    
    return items[indexPath.item]
  }
}

// MARK: - PostsFeed Viper Components
fileprivate extension PostsFeedPreviewPresenter {
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

//Mark:- Helpers


extension PostsFeedPreviewPresenter {
  func setPlaceholderIfNeeded(animated: Bool) {
    let shouldPresentPlaceholder = interactor.numberOfItems() == 0
    guard shouldPresentPlaceholder else {
      viewController.showPlaceholder(nil, animated: animated)
      return
    }
    
    switch interactor.currentFeedType {
    case .main:
      viewController.showPlaceholder(nil, animated: animated)
    case .userPosts(_):
      viewController.showPlaceholder(nil, animated: animated)
    case .singlePost(_):
      viewController.showPlaceholder(nil, animated: animated)
    case .favoritesPosts(_):
      viewController.showPlaceholder(nil, animated: animated)
    case .upvotedPosts(_):
      viewController.showPlaceholder(nil, animated: animated)
    case .discover, .discoverDetailFeedFor:
      viewController.showPlaceholder(nil, animated: animated)
    case .postsRelatedToTag(_):
      viewController.showPlaceholder(nil, animated: animated)
    case .postsRelatedToPlace(_):
      viewController.showPlaceholder(nil, animated: animated)
    case .currentUserCommercePosts(_):
      viewController.showPlaceholder(PostsFeed.PostsFeedPlaceholderViewModel.currentUserGoods, animated: animated)
    case .currentUserPurchasedCommercePosts(_):
      viewController.showPlaceholder(PostsFeed.PostsFeedPlaceholderViewModel.currentPurchasedGoods, animated: animated)
    case .userPromotedPosts(_, let status):
      viewController.showPlaceholder(PostsFeed.PostsFeedPlaceholderViewModel.usersPromotedPosts(status), animated: animated)
    case .topGroupsPosts:
      viewController.showPlaceholder(nil, animated: animated)
    case .winnerPosts:
      viewController.showPlaceholder(nil, animated: animated)
    case .currentUserActiveFundingPosts(_):
      viewController.showPlaceholder(PostsFeed.PostsFeedPlaceholderViewModel.currentUserActiveFundings, animated: animated)
    case .currentUserEndedFundingPosts(_):
      viewController.showPlaceholder(PostsFeed.PostsFeedPlaceholderViewModel.currentUserEndedFundings, animated: animated)
    case .currentUserBackedFundingPosts(_):
      viewController.showPlaceholder(PostsFeed.PostsFeedPlaceholderViewModel.currentUserDonatedFundings, animated: animated)
    }
  }
}

extension PostsFeedPreviewPresenter {
  fileprivate func prepareSectionViewModelFor(_ section: Int) -> [PostsFeed.ItemViewModelType] {
    guard let posting = interactor.itemFor(section) else {
      return []
    }
    
    guard let cachedViewModels = cachedSectionViewModels[section],
      cachedViewModels.itemId == posting.identifier
      else {
        
        let viewModels = PostsFeed.ItemViewModelType.sectionPromotionPreviewViewModelFor(posting, promotionDraft: promotionDraft,
                                                                         userRequest: interactor.requestUser)
        cachedSectionViewModels[section] = (viewModels, posting.identifier)
        
        if viewModels.count > 0 {
          if shouldScrollToPost?.identifier == posting.identifier {
            shouldScrollToIndexPath = IndexPath(item: 0, section: section)
          }
          
          if shouldEditPost?.identifier == posting.identifier {
            shouldEditPostAtIndexPath = IndexPath(item: 0, section: section)
          }
        }
        
        return viewModels
    }
    
    if cachedViewModels.vm.count > 0 {
      if shouldScrollToPost?.identifier == posting.identifier {
        shouldScrollToIndexPath = IndexPath(item: 0, section: section)
      }
      
      if shouldEditPost?.identifier == posting.identifier {
        shouldEditPostAtIndexPath = IndexPath(item: 0, section: section)
      }
    }
    
    return cachedViewModels.vm
  }
  
  fileprivate func removePreparedSectionViewModelFor(_ section: Int) {
    cachedSectionViewModels.removeValue(forKey: section)
  }
  
  fileprivate func presentAddCommentFor(_ indexPath: [IndexPath]) {
    guard indexPath.count > 0 else {
      return
    }
    
    let midElementIndex = Int(Double(indexPath.count - 1) / 2.0)
    let targetItem = indexPath[midElementIndex]
    
    interactor.setCommentDraftFor(targetItem.section, text: "")
  }
  
  fileprivate func expandFundingItemFor(_ indexPath: [IndexPath]) {
    guard indexPath.count > 0 else {
      return
    }
    
    let midElementIndex = Int(Double(indexPath.count - 1) / 2.0)
    let targetItem = indexPath[midElementIndex]
    
    interactor.expandFundingItemFor(targetItem.section)
  }
}

extension PostsFeedPreviewPresenter: UpvotePickDelegateProtocol {
  func didSelectPostUpvote(upvote: UpvoteProtocol) {
    
  }
}

//MARK:- UpVoteDelegateProtocol

extension PostsFeedPreviewPresenter: UpVoteDelegateProtocol {
  func isPromoted() -> Bool {
    return false
  }
 
  func shouldUpVoteWithAmount(_ amount: Int) {
    
  }
}


//MARK:- TagPickDelegateProtocol

extension PostsFeedPreviewPresenter: TagPickDelegateProtocol {
  func didSelectTags(_ tags: TagPick.PickedTags) {
    
  }
  
  func selectedTags() -> TagPick.PickedTags {
    return TagPick.PickedTags(tags: [])
  }
}

//MARK:- DonateDelegateProtocol

extension PostsFeedPreviewPresenter: DonateDelegateProtocol, FundingDetailDelegateProtocol {
  //not supported
  func shouldCreateFundingPostWithTeam(_ team: FundingCampaignTeamProtocol) {
    
  }
  
  func shouldStopFindingCampaign() {
    //not supported
  }
  
  func shouldDonateWithBalance(_ balance: BalanceProtocol, price: Double?) {
    //donation is not supported in this presenter
  }
  
  
}

//MARK:- LocationPickDelegateProtocol

extension PostsFeedPreviewPresenter: LocationPickDelegateProtocol {
  func didSelectLocation(_ location: SearchLocationProtocol) {
    
  }
}


//MARK:- DigitalGoodDetailDelegateProtocol

extension PostsFeedPreviewPresenter: CommercialPostDetailDelegateProtocol {
  func shouldCreateGoodsOrderFor() {
     
  }
  
  func shouldCreateOrderFor(_ post: PostingProtocol) {
    
  }
  
  func didRequestedInvoice(_ invoice: InvoiceProtocol) {
    
  }
}

extension PostsFeedPreviewPresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    
  }
  
  func walletDidFailToUnlock() {
    
  }
}

