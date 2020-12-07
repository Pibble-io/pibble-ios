//
//  PostsFeedPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVKit

// MARK: - PostsFeedPresenter Class
final class PostsFeedPresenter: Presenter {
  
  fileprivate var upvotedUsersActionAtMyPosting: Bool?
  
  fileprivate var upVoteUser: UserProtocol?
  fileprivate var requestedInvoice: InvoiceProtocol?
  fileprivate var selectedPost: PostingProtocol?
  
  fileprivate var createPostHelpDraft: CreatePostHelpProtocol?
  
  fileprivate var shouldScrollToPost: PostingProtocol?
  fileprivate var shouldEditPost: PostingProtocol?
  fileprivate var shouldScrollToIndexPath: IndexPath?
  fileprivate let shouldPresentClosedPromoStatus: Bool
  fileprivate let shouldPresentFundingControls: Bool
  
  fileprivate var shouldEditPostAtIndexPath: IndexPath?
  
  fileprivate var selectedItemIndexPath: IndexPath? {
    set {
      guard let indexPath = newValue else {
        interactor.deselectItem()
        return
      }
      
      interactor.selectItemAt(indexPath.section)
    }
    
    get {
      guard let index = interactor.indexForSelectedItem else {
        return nil
      }
      
      return IndexPath(item: 0, section: index)
    }
  }
  
  
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
  
  fileprivate var lastRefreshDate: Date =  Date(timeIntervalSince1970: 0.0)
  fileprivate var refreshTimeinterval: TimeInterval = TimeInterval.minutesInterval(5)
  
  
  init(options: PostsFeed.PresentationOptions) {
    self.shouldScrollToPost = options.selectionOption.shouldScrollToPost
    self.shouldEditPost = options.selectionOption.shouldEditPost
    self.shouldPresentClosedPromoStatus = options.shouldPresentClosedPromoStatus
    self.shouldPresentFundingControls = options.shouldPresentFundingControls
  }
  
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
    
    if abs(lastRefreshDate.timeIntervalSinceNow) > refreshTimeinterval {
      lastRefreshDate = Date()
      interactor.initialRefresh()
    }
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
   
    interactor.subscribeWebSocketUpdates()
    
    if let editIndexPath = shouldEditPostAtIndexPath {
      interactor.setBeingEditedStateAt(editIndexPath.section, isBeingEdited: true)
    }
    
    setPlaceholderIfNeeded(animated: true)
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    cachedSectionViewModels.removeAll()
    AVPlayer.pauseCurrentlyPlaying()
    
    lastRefreshDate = Date()
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()

    viewController.setFetchingStarted()
    
    //need to always refresh because access token will be refreshed at this moment
    lastRefreshDate = Date()
    interactor.initialRefresh()
  }
 
  override func presentInitialState() {
    super.presentInitialState()
    interactor.deselectTopGroups()
    viewController.scrollToTop(animated: false)
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    
    AVPlayer.pauseCurrentlyPlaying()
    shouldScrollToIndexPath = nil
    shouldScrollToPost = nil
    interactor.unsubscribeWebSocketUpdates()
    
    lastRefreshDate = Date()
  }
}



// MARK: - PostsFeedPresenter API
extension PostsFeedPresenter: PostsFeedPresenterApi {
  func handlePlayRoomAction() {
    router.routeToPlayRoom()
  }
  
  func handleGiftAction() {
    router.routeToGifts()
  }
  
  func handleCancelPostHelpCreationAction() {
    createPostHelpDraft = nil
  }
  
  func handleConfirmPostHelpCreationAction() {
    router.routeToPinCodeUnlock(delegate: self)
  }
  
  func presentStopFundingSuccess() {
    viewController.presentDonationSuccessAlert()
  }
  
  func handleCurrentItemStopFundingConfirmAction() {
    if let indexPath = selectedItemIndexPath {
      interactor.performStopFundingAt(indexPath.section)
      selectedItemIndexPath = nil
    }
  }
  
  func presentDonationSuccess() {
    viewController.presentDonationSuccessAlert()
  }
  
  func presentOrderCreationSuccess() {
    viewController.presentPurchaseSuccessAlert()
  }
  
  func handleLeaderbordAction() {
    router.routeToLeaderboard()
  }
  
  func handleTopBannerInfoAction() {
    router.routeToTopBannerInfo()
  }
  
  func handleTopGroupSelectionAt(_ indexPath: IndexPath) {
    interactor.selectTopGroupAt(indexPath.item)
  }
  
  func presentTopGroups(_ groups: [TopGroup], selectedGroup: TopGroupPostsType?) {
    let viewModel = PostsFeed.HomeTopGroupsHeaderViewModel(groups, selectedGroupType: selectedGroup)
    viewController.setTopHeaderViewModel(viewModel, animated: isPresented)
  }
  
  func presentCollectionReload() {
    viewController.reloadData()
  }
  
  func handleAddPromotionActionAt(_ indexPath: IndexPath) {
    guard let post = interactor.itemFor(indexPath.section) else {
      return
    }
    
    guard post.isMyPosting else {
      return
    }
    
    router.routeToAddPromotion(post: post)
  }
  
  func handleCurrentItemShowEngagementAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleShowEngagementActionAt(indexPath)
  }
  
  func handleShowEngagementActionAt(_ indexPath: IndexPath) {
    guard let post = interactor.itemFor(indexPath.section) else {
      return
    }
    
    guard post.isMyPosting else {
      return
    }
    
    router.routeToEngagement(post: post)
  }
  
  func handleShowDestinationActionAt(_ indexPath: IndexPath) {
    guard let post = interactor.itemFor(indexPath.section) else {
      return
    }
  
    guard let promotion = post.postPromotion else {
      return
    }
    
    interactor.trackPromoActionTapEventAt(indexPath.section)
    
    switch promotion.promotionDestination {
    case .site:
      if let promotionUrl = promotion.promotionUrl {
        router.routeToWebsiteAt(promotionUrl)
      }
    case .profile:
      if let user = post.postingUser {
        router.routeToUserProfileFor(user)
      }
    }
  }
 

  func createDigitalGoodPostAction() {
    router.routeToCreateCommercePost()
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
  
  func handleZoomActionAt(_ indexPath: IndexPath, mediaItemIndex: Int) {
    guard let post = interactor.itemFor(indexPath.section),
      mediaItemIndex < post.postingMedia.count else {
      return
    }
    
    let media = post.postingMedia[mediaItemIndex]
    router.routeToZoomForPost(post, media: media)
  }

  func handleCurrentItemInappropriateReportAction() {
    router.routeToPickPostReportReason(delegate: self)
  }
  
  func handleCurrentItemSpamReportAction() {
    guard let _ = interactor.indexForSelectedItem else {
      return
    }
    
    viewController.showSpamReportedSuccessAlert()
  }
  
  func handleCurrentItemBlockReportAction() {
    guard let index = interactor.indexForSelectedItem else {
      return
    }
    
    interactor.performBlockReportAt(index)
  }
  
  func handleLikeInPlaceActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
    
    guard !item.isMyPosting else {
      return
    }
    
    guard !item.isUpVotedByUser else {
      return
    }
  
    interactor.performUpVoteInPlaceAt(indexPath.section)
  }
  
  func presentInvoicePaymentSuccess() {
    viewController.presentPurchaseSuccessAlert()
  }
  
  func handleCancelCurrentInvoiceAction() {
    requestedInvoice = nil
    selectedPost = nil
  }
  
  func handleConfirmCurrentInvoiceAction() {
    router.routeToPinCodeUnlock(delegate: self)
  }
  
  func handleConfirmOrderCreationAction() {
    router.routeToPinCodeUnlock(delegate: self)
  }
  
  func handleCancelOrderCreationAction() {
    selectedPost = nil
  }
  
  func presentCurrentUserProfile(_ user: AccountProfileProtocol) {
    let messagesBadge = user.unreadChatMessagesCount == 0 ? nil : "\(user.unreadChatMessagesCount)"
    let walletBadge = user.activeInvoicesCount == 0 ? nil : "\(user.activeInvoicesCount)"
    
    viewController.setBadges(notificationBadge: messagesBadge, walletBadge: walletBadge)
  }
  
  
  func handleNotificationsActionWith(_ transition: GestureInteractionController) {
    router.routeToChatRoomsWith(transition)
  }
  
  func handleNotificationsAction() {
    router.routeToChatRooms()
  }
  
  func handleCommercePostDetailsActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
    
    guard !item.isMyPosting else {
      router.routeToChatRoomsGroupFor(item)
      return
    }
    
    switch item.postingType {
    case .media:
      break
    case .funding, .charity, .crowdfundingWithReward:
      break
    case .commercial:
      guard let commercialInfo = item.commerceInfo else {
        return
      }
      
      guard let invoice = item.currentUserDigitalGoodPurchaseInvoice,
        invoice.walletActivityStatus == .accepted
        else {
          selectedPost = item
          router.routeToDigitalGoodDetail(item, commercialInfo: commercialInfo, delegate: self)
          return
      }
      
      selectedPost = item
      router.routeToChatRoomForPost(item)
    case .goods:
      guard let goodsInfo = item.goodsInfo else {
        return
      }
      
      selectedPost = item
      router.routeToGoodsDetail(item, goodsInfo: goodsInfo, delegate: self)
    }
  }
  
  func handleChatActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleCancelUploadActionAt(_ indexPath: IndexPath) {
    interactor.performCancelUploadPost(indexPath.section)
  }
  
  func handleRestartUploadActionAt(_ indexPath: IndexPath) {
    interactor.performRestartUploadPost(indexPath.section)
  }
  
  func presentPostDescriptionEditSuccess() {
    router.dismiss()
  }
  
  func handeEditDoneAction() {
    if let editIndexPath = shouldEditPostAtIndexPath {
      interactor.applyPostDescriptionChanges(editIndexPath.section)
    }
  }
  
  func handleEditDescriptionTextChangedAt(_ indexPath: IndexPath, text: String) {
    interactor.setPostDescriptionFor(indexPath.section, text: text)
  }
  
  func handleCurrentItemEditLocationAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleEditLocationActionAt(indexPath)
  }
  
  func handleCurrentItemRemoveLocationAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleRemoveLocationActionAt(indexPath)
  }
  
  func handleEditLocationActionAt(_ indexPath: IndexPath) {
    selectedItemIndexPath = indexPath
    router.routeToLocationPick(self)
  }
  
  func handleRemoveLocationActionAt(_ indexPath: IndexPath) {
    interactor.removeLocationForItemAt(indexPath.section)
  }
  
  func handleLocationSelectionActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
    
    guard shouldEditPost?.identifier == item.identifier else {
      guard let place = item.postingPlace else {
        return
      }
      
      router.routeToPlaceRelatedPostsFor(place)
      return
    }
    
    selectedItemIndexPath = indexPath
    viewController.showLocationOptionsActionSheet()
  }
  
  func handleCommentSelectionActionAt(_ indexPath: IndexPath) {
    guard let itemViewModel = itemViewModelAt(indexPath),
      case let PostsFeed.ItemViewModelType.comment(vm) = itemViewModel else {
      return
    }
    
    let idx = vm.commentIndex
    
    guard let item = interactor.itemFor(indexPath.section),
      idx >= 0, idx < item.postingCommentsPreview.count
    else {
      return
    }
    
    guard let commentUser = item.postingCommentsPreview[idx].commentUser else {
      return
    }
    
    router.routeToUserProfileFor(commentUser)
  }
  
  func handleSelectionActionAt(_ indexPath: IndexPath) { }
  
  func handleHideAction() {
    if let editIndexPath = shouldEditPostAtIndexPath {
      interactor.setBeingEditedStateAt(editIndexPath.section, isBeingEdited: false)
    }
    router.dismiss()
  }
  
  func handleUserProfileActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section),
      let user = item.postingUser
    else {
      return
    }
    
    interactor.trackViewUserProfileEventAt(indexPath.section)
    router.routeToUserProfileFor(user)
  }
  
  func handleUpvotedUsersActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section),
      item.postingUpVotesCount > 0
    else {
      return
    }
  
    router.routeToUpvotedUsersFor(item, delegate: self)
  }
  
  func handleCommentPostingActionAt(_ indexPath: IndexPath, text: String) {
    interactor.performCommentPosting(indexPath.section, text: text)
  }
  
  func handleAddCommentTextChangedAt(_ indexPath: IndexPath, text: String) {
    interactor.setCommentDraftFor(indexPath.section, text: text)
  }
  
  func handleStopScrollingWithVisible(_ indexPaths: [IndexPath]) {
    commentDraftScrollingTimer = Timer.scheduledTimer(withTimeInterval: commentDraftScrollingTimeIntreval, repeats: false, block: { [weak self](_) in
      self?.presentAddCommentFor(indexPaths)
    })
    
    expandFundingScrollingTimer = Timer.scheduledTimer(withTimeInterval: expandFundingScrollingTimeIntreval, repeats: false, block: { [weak self](_) in
      self?.expandFundingItemFor(indexPaths)
    })
    
    trackViewEventFor(indexPaths)
  }
  
  
  
  func handleStartScrolling() {
    commentDraftScrollingTimer = nil
  }
  
  func handleTap() {
    
  }
  
  func presentFetchingFinished() {
    viewController.setFetchingFinished()
  }
  
  func handlePullToRefresh() {
    lastRefreshDate = Date()
    interactor.initialRefresh()
  }
  
  func handleFriendActionAt(_ indexPath: IndexPath) {
    interactor.performFriendActionAt(indexPath.section)
  }
  
  func handleCopyLinkActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
    
    UIPasteboard.general.urls = [item.sharingUrl]
  }
  
  func handleShareActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
 
    router.routeToShareControlWith([item.sharingUrl]) { [weak self] (activityType, success) in
      guard success else {
        return
      }
      
      self?.interactor.trackSharingFor(item)
    }
  }
  
  func handleEditPostCaptionActionAt(_ indexPath: IndexPath) {
    selectedItemIndexPath = indexPath
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
    router.routeToPostCaptionEditFor(item)
  }
  
  func handleEditPostTagsActionAt(_ indexPath: IndexPath) {
    selectedItemIndexPath = indexPath
    router.routeToTagEdit(self)
  }
  
  func handleDeletePostActionAt(_ indexPath: IndexPath) {
    interactor.performDeletePost(indexPath.section)
  }
  
  func handleCurrentItemDeletePostCheckFundsActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
    
    guard let canBeDeleted = interactor.checkIfPostCanBeDeletedAmount(item) else {
      return
    }
    
    guard canBeDeleted.0 else {
      viewController.showPostDeleteAlertWith(PostsFeed.Strings.notEnoughFundsForPostDelete(canBeDeleted.1),
                                             message: PostsFeed.Strings.alertMessageForPostDelete(canBeDeleted.1),
                                             canBeDeleted: canBeDeleted.0)
      return
    }
    
    viewController.showPostDeleteAlertWith(PostsFeed.Strings.deletePostConfirmation.localize(),
                                           message: PostsFeed.Strings.alertMessageForPostDelete(canBeDeleted.1),
                                           canBeDeleted: canBeDeleted.0)
  }
  
  func handleReportActionAt(_ indexPath: IndexPath) {
    selectedItemIndexPath = indexPath
    viewController.showReportTypeSelectionAlert()
  }
  
  func handleMuteActionAt(_ indexPath: IndexPath) {
    interactor.performMuteActionAt(indexPath.section)
  }
  
  func handleCurrentItemFollowAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleFollowActionAt(indexPath)
  }
  
  func handleCurrentItemFriendAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleFriendActionAt(indexPath)
  }
  
  func handleCurrentItemShareAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleShareActionAt(indexPath)
  }
  
  func handleCurrentItemCopyLinkAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleCopyLinkActionAt(indexPath)
  }
  
  func handleCurrentItemReportAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleReportActionAt(indexPath)
  }
  
  func handleCurrentItemMuteAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleMuteActionAt(indexPath)
  }
  
  func handleCurrentItemEditPostCaptionAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
   
    handleEditPostCaptionActionAt(indexPath)
  }
  
  
  
  func handleCurrentItemEditPostTagsAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleEditPostTagsActionAt(indexPath)
  }
  
  func handleCurrentItemDeletePostAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleDeletePostActionAt(indexPath)
  }
  
  func handleCurrentItemDeletePostCheckFundsAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleCurrentItemDeletePostCheckFundsActionAt(indexPath)
  }

  
  func handleAdditionalActionAt(_ indexPath: IndexPath) {
    guard let vmType = itemViewModelAt(indexPath),
      case let PostsFeed.ItemViewModelType.user(vm) = vmType else {
      return
    }
    
    guard let posting = interactor.itemFor(indexPath.section) else {
      return
    }
    
    selectedItemIndexPath = indexPath
    viewController.scrollTo(indexPath, animated: true)
    
    guard posting.isMyPosting else {
      viewController.showPostingOptionsActionSheet(vm)
      return
    }
    
    guard case let PostsFeed.FeedType.userPromotedPosts(_, promotionStatus) = interactor.currentFeedType else {
      viewController.showMyPostingOptionsActionSheet()
      return
    }
    
    switch promotionStatus {
    case .active:
      viewController.showMyPostingPromotionOptionsActionSheet([.pause, .close, .insight])
    case .paused:
      viewController.showMyPostingPromotionOptionsActionSheet([.resume, .close, .insight])
    case .closed:
      viewController.showMyPostingPromotionOptionsActionSheet([.insight])
    }
  }
  
  func handleFavoritesActionAt(_ indexPath: IndexPath) {
    interactor.performFavoritesActionAt(indexPath.section)
  }
  
  
  func handleHelpActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
    
    guard let postHelpRequest = item.postHelpRequest else {
      selectedPost = item
      router.routeToPostHelpCreationFor(item, delegate: self)
      return
    }
    
    router.routeToPostHelpAnswersFor(postHelpRequest)
  }

  
  func handleWalletAction() {
    isWalletPreviewPresented = !isWalletPreviewPresented
    viewController.setWalletPreviewContainerPresentation(!isWalletPreviewPresented, animated: true)
    guard isWalletPreviewPresented else {
      return
    }
    
    router.routeToWalletPreview(in: viewController.walletContainerView)
  }
  
  func handleLikeActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section) else {
      return
    }
    
    guard !item.isMyPosting else {
      return
    }
    
    guard !item.isUpVotedByUser else {
      return
    }
    
    selectedItemIndexPath = indexPath
    router.routeToUpVote(delegate: self, purpose: .posting)
  }
  
  func handleFollowActionAt(_ indexPath: IndexPath) {
    interactor.performFollowActionAt(indexPath.section)
  }
  
  func handleShowAllCommentsActionAt(_ indexPath: IndexPath) {
    guard let posting = interactor.itemFor(indexPath.section) else {
      return
    }
    
    router.routeToCommentsFor(posting)
  }
  
  func handlePrefetchItemAt(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.section)
    let _ = prepareSectionViewModelFor(indexPath.section)
  }
  
  func handleCancelPrefetchingItem(_ indexPath: IndexPath) {
//    removePreparedSectionViewModelFor(indexPath.section)
    interactor.cancelPrepareItemFor(indexPath.section)
  }
  
  func handleJoinTeamActionAt(_ indexPath: IndexPath) {
    
  }
  
  func handleDonateActionAt(_ indexPath: IndexPath) {
    selectedItemIndexPath = indexPath
    router.routeToDonate(delegate: self)
  }
  
  func handleShowCampaignActionAt(_ indexPath: IndexPath) {
    //    expandFundingItemFor([indexPath])
    guard let postingItem = interactor.itemFor(indexPath.section) else {
      return
    }
    
    switch postingItem.postingType {
    case .media, .commercial, .goods:
      return
    case .funding, .charity, .crowdfundingWithReward:
      guard shouldPresentFundingControls else {
        selectedItemIndexPath = indexPath
        router.routeToFundingDetail(postingItem, shouldPresentFundingControls: shouldPresentFundingControls, delegate: self)
        return
      }
      
      selectedItemIndexPath = indexPath
      viewController.showMyFundingControlsActionSheet()
    }
  }
  
  func handleCurrentItemShowFundingDetailsAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    guard let postingItem = interactor.itemFor(indexPath.section) else {
      return
    }
    
    switch postingItem.postingType {
    case .media, .commercial, .goods:
      return
    case .funding, .charity, .crowdfundingWithReward:
      selectedItemIndexPath = indexPath
      router.routeToFundingDetail(postingItem, shouldPresentFundingControls: shouldPresentFundingControls, delegate: self)
    }
  }
  
  func handleCurrentItemShowFundingDonatorsAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    guard let postingItem = interactor.itemFor(indexPath.section) else {
      return
    }
    
    switch postingItem.postingType {
    case .media, .commercial, .goods:
      return
    case .funding, .charity, .crowdfundingWithReward:
      router.routeToFundingDonators(postingItem)
    }
  }
  
  
  func handleTagSelectionActionAt(_ indexPath: IndexPath, tagIndexPath: IndexPath) {
    guard let postingItem = interactor.itemFor(indexPath.section) else {
      return
    }
    
    
    if tagIndexPath.item < postingItem.postingTags.count {
      let tag = postingItem.postingTags[tagIndexPath.item]
      
      interactor.trackViewTagEventAt(indexPath.section)
      router.routeToPostingsWithTag(tag, originalPosting: postingItem)
    }
  }
  
  //Promoted posts actions
  func handleCurrentItemPausePromotionConfirmAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handlePausePromotionActionAt(indexPath)
  }
  
  func handleCurrentItemResumePromotionConfirmAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleResumePromotionActionAt(indexPath)
  }
  
  func handleCurrentItemClosePromotionConfirmAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleStopPromotionActionAt(indexPath)
  }
 
  func handleCurrentItemPausePromotionAction() {
    viewController.showPausePromotionAlert()
  }
  
  func handleCurrentItemResumePromotionAction() {
    viewController.showResumePromotionAlert()
  }
  
  func handleCurrentItemStopPromotionAction() {
    viewController.showClosePromotionAlert()
  }
  
  func handleCurrentItemShowInsightAction() {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    handleShowInsightActionAt(indexPath)
  }
  
  func handlePausePromotionActionAt(_ indexPath: IndexPath) {
    interactor.pausePromotionActionAt(indexPath.section)
  }
  
  func handleResumePromotionActionAt(_ indexPath: IndexPath) {
    interactor.resumePromotionActionAt(indexPath.section)
  }
  
  func handleStopPromotionActionAt(_ indexPath: IndexPath) {
    interactor.stopPromotionActionAt(indexPath.section)
  }
  
  func handleShowInsightActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemFor(indexPath.section),
      let promotion = item.postPromotion
    else {
      return
    }
    
    router.routeToInsights(promotion: promotion)
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
fileprivate extension PostsFeedPresenter {
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


extension PostsFeedPresenter {
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

extension PostsFeedPresenter {
  fileprivate func prepareSectionViewModelFor(_ section: Int) -> [PostsFeed.ItemViewModelType] {
    guard let posting = interactor.itemFor(section) else {
      return []
    }
   
    guard let cachedViewModels = cachedSectionViewModels[section],
        cachedViewModels.itemId == posting.identifier
    else {
      let viewModels = PostsFeed.ItemViewModelType.sectionViewModelFor(posting,
                                                                       shouldPresentClosedPromoStatus: shouldPresentClosedPromoStatus,
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
  
  fileprivate func trackViewEventFor(_ indexPath: [IndexPath]) {
    guard indexPath.count > 0 else {
      return
    }
    
    let midElementIndex = Int(Double(indexPath.count - 1) / 2.0)
    let targetItem = indexPath[midElementIndex]
    
    interactor.trackViewItemEventAt(targetItem.section)
  }
  
  fileprivate func presentAddCommentFor(_ indexPath: [IndexPath]) {
    guard indexPath.count > 0 else {
      return
    }
    
    let midElementIndex = Int(Double(indexPath.count - 1) / 2.0)
    let targetItem = indexPath[midElementIndex]
    
    interactor.addCommentDraftFor(targetItem.section)
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

extension PostsFeedPresenter: UpvotePickDelegateProtocol {
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

extension PostsFeedPresenter: UpVoteDelegateProtocol {
  func isPromoted() -> Bool {
    guard let indexPath = selectedItemIndexPath else {
      return false
    }
    
    guard let item = interactor.itemFor(indexPath.section) else {
      return false
    }
    
    return item.postingPromotions.count > 0
  }
    
  func shouldUpVoteWithAmount(_ amount: Int) {
    if let indexPath = selectedItemIndexPath {
      interactor.performUpVoteAt(indexPath.section, withAmount: amount)
      selectedItemIndexPath = nil
      return
    }
    
    if let user = upVoteUser {
      interactor.performUpVoteUser(user, withAmount: amount)
      upVoteUser = nil
      return
    }
  }
}


//MARK:- TagPickDelegateProtocol

extension PostsFeedPresenter: TagPickDelegateProtocol {
  func didSelectTags(_ tags: TagPick.PickedTags) {
    guard let indexPath = selectedItemIndexPath else {
      return
    }
    
    interactor.setTagsForItemAt(indexPath.section, tags: tags.tags)
  }
  
  func selectedTags() -> TagPick.PickedTags {
    guard let indexPath = selectedItemIndexPath else {
      return TagPick.PickedTags(tags: [])
    }
    
    guard let item = interactor.itemFor(indexPath.section) else {
      return TagPick.PickedTags(tags: [])
    }
    
    return TagPick.PickedTags(tags: item.postingTags)
  }
}

//MARK:- DonateDelegateProtocol, FundingDetailDelegateProtocol

extension PostsFeedPresenter: DonateDelegateProtocol, FundingDetailDelegateProtocol {
  func shouldCreateFundingPostWithTeam(_ team: FundingCampaignTeamProtocol) {
    router.routeToCreateFundingWithCampaignTeam(team)
  }
  
  func shouldStopFindingCampaign() {
    viewController.presentStopFundingConfirmAlert()
  }
  
  func shouldDonateWithBalance(_ balance: BalanceProtocol, price: Double?) {
    if let indexPath = selectedItemIndexPath {
      interactor.performDonateAt(indexPath.section, withBalance: balance, donatePrice: price)
      selectedItemIndexPath = nil
    }
  }
}

//MARK:- LocationPickDelegateProtocol

extension PostsFeedPresenter: LocationPickDelegateProtocol {
  func didSelectLocation(_ location: SearchLocationProtocol) {
    if let indexPath = selectedItemIndexPath {
      interactor.setLocationForItemAt(indexPath.section, location: location)
    }
  }
}


//MARK:- CreatePostHelpDelegateProtocol

extension PostsFeedPresenter: CreatePostHelpDelegateProtocol {
  func shouldCreatePostHelpWith(_ draft: CreatePostHelpProtocol) {
    createPostHelpDraft = draft
    viewController.showConfirmPostHelpCreationOrderAlert(PostsFeed.Strings.alertTitleForPostHelp(draft))
  }
}

//MARK:- DigitalGoodDetailDelegateProtocol

extension PostsFeedPresenter: CommercialPostDetailDelegateProtocol {
  func shouldCreateGoodsOrderFor() {
    guard let selectedPost = selectedPost,
      let goodsInfo = selectedPost.goodsInfo
    else {
      return
    }
    
    viewController.showConfirmGoodsOrderAlert(PostsFeed.Strings.alertTitleForGoodsInfo(goodsInfo))
  }
  
  func didRequestedInvoice(_ invoice: InvoiceProtocol) {
    requestedInvoice = invoice
    guard invoice.walletActivityStatus == .requested else {
      return
    }
    viewController.showConfirmInvoiceAlert(PostsFeed.Strings.alertTitleForInvoice(invoice))
  }
}

//MARK:- WalletPinCodeUnlockDelegateProtocol

extension PostsFeedPresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    guard let selectedPost = selectedPost else {
      return
    }
    
    if let draft = createPostHelpDraft {
      interactor.createPostAskHelpFor(selectedPost, draft: draft)
      createPostHelpDraft = nil
      return
    }
    
    switch selectedPost.postingType {
    case .media, .funding, .charity, .crowdfundingWithReward:
      return
    case .commercial:
      guard let invoice = requestedInvoice else {
        return
      }
      
      interactor.acceptInvoice(invoice, for: selectedPost)
    case .goods:
      interactor.createGoodsOrderFor(selectedPost)
    }
  }
  
  func walletDidFailToUnlock() {
    requestedInvoice = nil
    selectedPost = nil
  }
}



// MARK: - ReportPostDelegateProtocol
extension PostsFeedPresenter: ReportPostDelegateProtocol {
  func didSelectReason(_ reason: PostReportReasonProtocol) {
    guard let index = interactor.indexForSelectedItem else {
      return
    }
    
    interactor.perforReportAsInappropriateAt(index, reason: reason)
  }
}

