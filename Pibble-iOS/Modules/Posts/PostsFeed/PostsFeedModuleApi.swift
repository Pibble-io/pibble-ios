//
//  PostsFeedModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit


//MARK: - PostsFeedRouter API
protocol PostsFeedRouterApi: RouterProtocol {
  func routeToCommentsFor(_ posting: PostingProtocol)
  func routeToChatRooms()
  func routeToChatRoomsWith(_ transition: GestureInteractionController)
  
  func routeToWallet()
  func routeToPlayRoom()
  func routeToGifts()
  
  func routeToUpVote(delegate: UpVoteDelegateProtocol, purpose: UpVote.UpvotePurpose) 
  func routeToShareControlWith(_ urls: [URL], completion: @escaping ((UIActivity.ActivityType?, Bool) -> Void))
  
  func routeToUpvotedUsersFor(_ posting: PostingProtocol, delegate: UpvotePickDelegateProtocol)
  func routeToWalletPreview(in container: UIView)
  func routeToDonate(delegate: DonateDelegateProtocol)
  func routeToUserProfileFor(_ user: UserProtocol)
  func routeToPostingDetailFor(_ posting: PostingProtocol, currentFeedType: PostsFeed.FeedType)
  func routeToDiscoverPostDetailFor(_ post: PostingProtocol) 
  func routeToPostingsWithTag(_ tag: String, originalPosting: PostingProtocol)
  func routeToPostCaptionEditFor(_ posting: PostingProtocol)
  func routeToTagEdit(_ withDelegate: TagPickDelegateProtocol)
  func routeToLocationPick(_ withDelegate: LocationPickDelegateProtocol)
  func routeToPlaceRelatedPostsFor(_ place: LocationProtocol)
  
  func routeToFundingDetail(_ post: PostingProtocol, shouldPresentFundingControls: Bool, delegate: FundingDetailDelegateProtocol)
  
  func routeToFundingDonators(_ post: PostingProtocol)
  
  func routeToChatRoomsGroupFor(_ post: PostingProtocol)
  func routeToDigitalGoodDetail(_ post: PostingProtocol, commercialInfo: CommerceInfoProtocol, delegate: CommercialPostDetailDelegateProtocol)
  func routeToGoodsDetail(_ post: PostingProtocol, goodsInfo: GoodsProtocol, delegate: CommercialPostDetailDelegateProtocol)
  
  func routeToChatRoomForPost(_ post: PostingProtocol)
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
  
  func routeToPickPostReportReason(delegate: ReportPostDelegateProtocol)
  
  func routeToZoomForPost(_ post: PostingProtocol, media: MediaProtocol)
  func routeToCreateCommercePost()
  
  func routeToAddPromotion(post: PostingProtocol)
  func routeToEngagement(post: PostingProtocol)
  func routeToInsights(promotion: PostPromotionProtocol)
  
  func routeToWebsiteAt(_ url: URL)
  
  func routeToLeaderboard()
  func routeToTopBannerInfo()
  
  func routeToCreateFundingWithCampaignTeam(_ team: FundingCampaignTeamProtocol)
  
  func routeToPostHelpCreationFor(_ post: PostingProtocol, delegate: CreatePostHelpDelegateProtocol)
  func routeToPostHelpAnswersFor(_ postHelpRequest: PostHelpRequestProtocol) 
}



//MARK: - PostsFeedView API
protocol PostsFeedViewControllerApi: ViewControllerProtocol {
//  var hasTopHeaderView: Bool { get }
  func setTopHeaderViewModel(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol?, animated: Bool)
  
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
  
  func showMyPostingOptionsActionSheet()
  func showMyPostingPromotionOptionsActionSheet(_ actions: [PostsFeed.PromotionEventsActions])
  
  func showMyFundingControlsActionSheet()
  
  func showPostingOptionsActionSheet(_ vm: PostsFeedUserViewModelProtocol)
  func showLocationOptionsActionSheet()
  
  func showPostDeleteAlertWith(_ title: String, message: String, canBeDeleted: Bool)
  func showPlaceholder(_ vm: PostsFeedItemsPlaceholderProtocol?, animated: Bool)
  
  func setFetchingFinished()
  func setFetchingStarted()
  func scrollToTop(animated: Bool)
  func scrollTo(_ indexPath: IndexPath, animated: Bool)
  
//  func setUpvoteUsersContainerPresentation(_ hidden: Bool, forIndexPath: IndexPath?, animated: Bool)
  
  func setWalletPreviewContainerPresentation(_ hidden: Bool, animated: Bool)
  
  var walletContainerView: UIView { get }
  
  func setBadges(notificationBadge: String?, walletBadge: String?)
  
  func showConfirmInvoiceAlert(_ title: String)
  func showConfirmGoodsOrderAlert(_ title: String)
  func showConfirmPostHelpCreationOrderAlert(_ title: String)
  
  func presentStopFundingConfirmAlert()
  func presentStopFundingSuccessAlert()
  
  func presentPurchaseSuccessAlert()
  func presentDonationSuccessAlert()
 
  func showReportTypeSelectionAlert()
  func showSpamReportedSuccessAlert()
  
  func showResumePromotionAlert()
  func showPausePromotionAlert()
  func showClosePromotionAlert() 
}


//MARK: - PostsFeedPresenter API
protocol PostsFeedPresenterApi: PresenterProtocol {
  var navigationBarTitle: String { get }
  
  func createDigitalGoodPostAction()
  
  func handleHideAction()
  func handeEditDoneAction()
  
  func handleWalletAction()
  func handleNotificationsAction()
  func handleNotificationsActionWith(_ transition: GestureInteractionController)
  
  func handlePlayRoomAction()
  func handleGiftAction()
  
  
  func handlePrefetchItemAt(_ indexPath: IndexPath)
  func handleCancelPrefetchingItem(_ indexPath: IndexPath)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeed.ItemViewModelType?
  
  func presentCollectionReload()
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  func presentFetchingFinished()
  func presentPostDescriptionEditSuccess()
  
  func handleShowAllCommentsActionAt(_ indexPath: IndexPath)
  func handleLikeActionAt(_ indexPath: IndexPath)
  
  func handleLikeInPlaceActionAt(_ indexPath: IndexPath)
  
  func handleFollowActionAt(_ indexPath: IndexPath)
  func handleFriendActionAt(_ indexPath: IndexPath)
  func handleShareActionAt(_ indexPath: IndexPath)
  func handleReportActionAt(_ indexPath: IndexPath)
//  func handleInappropriateReportActionAt(_ indexPath: IndexPath)
//  func handleSpamReportActionAt(_ indexPath: IndexPath)
  
  func handleMuteActionAt(_ indexPath: IndexPath)
  func handleFavoritesActionAt(_ indexPath: IndexPath)
  func handleAdditionalActionAt(_ indexPath: IndexPath)
  func handleEditPostCaptionActionAt(_ indexPath: IndexPath)
  func handleEditPostTagsActionAt(_ indexPath: IndexPath)
  
  func handleDeletePostActionAt(_ indexPath: IndexPath)
  func handleCurrentItemDeletePostCheckFundsActionAt(_ indexPath: IndexPath)
  
  func handleCancelUploadActionAt(_ indexPath: IndexPath)
  func handleRestartUploadActionAt(_ indexPath: IndexPath)
  
  func handleCommercePostDetailsActionAt(_ indexPath: IndexPath)
  func handleChatActionAt(_ indexPath: IndexPath)
  
  //Promotion
  func handleAddPromotionActionAt(_ indexPath: IndexPath)
  func handleShowEngagementActionAt(_ indexPath: IndexPath)
  func handleShowDestinationActionAt(_ indexPath: IndexPath)
  func handleCurrentItemShowEngagementAction()
  
  //Invoices
  func handleCancelCurrentInvoiceAction()
  func handleConfirmCurrentInvoiceAction()
  func presentInvoicePaymentSuccess()
  
  //Goods Orders
  func handleCancelOrderCreationAction()
  func handleConfirmOrderCreationAction()
  func presentOrderCreationSuccess()
  
  //Post help
  func handleCancelPostHelpCreationAction()
  func handleConfirmPostHelpCreationAction()
  
  //Promoted posts actions
  
  func handleCurrentItemPausePromotionAction()
  func handleCurrentItemResumePromotionAction()
  func handleCurrentItemStopPromotionAction()
  
  func handleCurrentItemShowInsightAction()
  
  func handlePausePromotionActionAt(_ indexPath: IndexPath)
  func handleResumePromotionActionAt(_ indexPath: IndexPath)
  func handleStopPromotionActionAt(_ indexPath: IndexPath)
  func handleShowInsightActionAt(_ indexPath: IndexPath)
  
  func handleCurrentItemPausePromotionConfirmAction()
  func handleCurrentItemResumePromotionConfirmAction()
  func handleCurrentItemClosePromotionConfirmAction()
  
  //Funding actions
  
  func handleCurrentItemShowFundingDetailsAction()
  func handleCurrentItemShowFundingDonatorsAction()
  
  func presentDonationSuccess()
  func presentStopFundingSuccess()
  
  func handleCurrentItemStopFundingConfirmAction()
  
  //Items actions
  func handleCurrentItemFollowAction()
  func handleCurrentItemFriendAction()
  func handleCurrentItemShareAction()
  func handleCurrentItemReportAction()
  func handleCurrentItemInappropriateReportAction()
  func handleCurrentItemSpamReportAction()
  func handleCurrentItemBlockReportAction()
  
  func handleCurrentItemMuteAction()
  func handleCurrentItemCopyLinkAction()
  func handleCurrentItemEditPostCaptionAction()
  func handleCurrentItemEditPostTagsAction()
  
  func handleCurrentItemDeletePostAction()
  func handleCurrentItemDeletePostCheckFundsAction()
  
  func handleCurrentItemEditLocationAction()
  func handleCurrentItemRemoveLocationAction()
  
  func handlePullToRefresh()
  
  func handleStopScrollingWithVisible(_ indexPaths: [IndexPath])
  func handleStartScrolling()
  func handleTap()
  
  func handleAddCommentTextChangedAt(_ indexPath: IndexPath, text: String)
  func handleCommentPostingActionAt(_ indexPath: IndexPath, text: String)
  
  func handleUpvotedUsersActionAt(_ indexPath: IndexPath)
  func handleHelpActionAt(_ indexPath: IndexPath)
  
  func handleZoomActionAt(_ indexPath: IndexPath, mediaItemIndex: Int)
  
  
  //funding, charity
  func handleJoinTeamActionAt(_ indexPath: IndexPath)
  func handleDonateActionAt(_ indexPath: IndexPath)
  func handleShowCampaignActionAt(_ indexPath: IndexPath)
  
  func handleUserProfileActionAt(_ indexPath: IndexPath)
  
  func handleSelectionActionAt(_ indexPath: IndexPath)
  func handleTagSelectionActionAt(_ indexPath: IndexPath, tagIndexPath: IndexPath)
  func handleCommentSelectionActionAt(_ indexPath: IndexPath)
  func handleLocationSelectionActionAt(_ indexPath: IndexPath)
  
  func handleEditLocationActionAt(_ indexPath: IndexPath)
  func handleRemoveLocationActionAt(_ indexPath: IndexPath)
  
  func handleEditDescriptionTextChangedAt(_ indexPath: IndexPath, text: String)
  
  func presentCurrentUserProfile(_ user: AccountProfileProtocol)
  
  var isWalletPreviewPresented: Bool { get }
  
  //top groups feed
  func handleTopGroupSelectionAt(_ indexPath: IndexPath)
  func handleLeaderbordAction()
  func handleTopBannerInfoAction()
  
  func presentTopGroups(_ groups: [TopGroup], selectedGroup: TopGroupPostsType?)
}

//MARK: - PostsFeedInteractor API
protocol PostsFeedInteractorApi: InteractorProtocol {
  func selectTopGroupAt(_ index: Int)
  func deselectTopGroups()
  
  var currentUserAccount: UserProtocol? { get }
  var currentFeedType: PostsFeed.FeedType { get }
  
  func selectItemAt(_ index: Int)
  func deselectItem()
  
  var indexForSelectedItem: Int? { get }
  var currentlySelectedItem: PostingProtocol? { get }
  
  func requestUser(completeHandler: @escaping (UserProtocol) -> Void)
 
  func subscribeWebSocketUpdates()
  func unsubscribeWebSocketUpdates()
  
  func initialFetchData()
  func initialRefresh()
  
  
  
  func itemFor(_ indexPath: Int) -> PostingProtocol?
  func numberOfItems() -> Int
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  
  func performUpVoteAt(_ index: Int, withAmount: Int)
  func performUpVoteInPlaceAt(_ index: Int)
  
  
  func performFollowActionAt(_ index: Int)
  func performFavoritesActionAt(_ index: Int)
  
  func performFriendActionAt(_ index: Int)
  
  func performBlockReportAt(_ index: Int)
  func perforReportAsInappropriateAt(_ index: Int, reason: PostReportReasonProtocol)
  
  func performMuteActionAt(_ index: Int)
  
  func setCommentDraftFor(_ index: Int, text: String)
  func addCommentDraftFor(_ index: Int)
  func performCommentPosting(_ index: Int, text: String)
  
  func performUpVoteUser(_ user: UserProtocol, withAmount: Int)
  func performDonateAt(_ index: Int, withBalance: BalanceProtocol, donatePrice: Double?)
  
  func performStopFundingAt(_ index: Int)
  
  func expandFundingItemFor(_ index: Int)
 
  func trackSharingFor(_ posting: PostingProtocol)
  
  func indexPathFor(_ post: PostingProtocol) -> IndexPath?
  
  func setBeingEditedStateAt(_ index: Int, isBeingEdited: Bool)
  func setPostDescriptionFor(_ index: Int, text: String)
  func applyPostDescriptionChanges(_ index: Int)
  func removeLocationForItemAt(_ index: Int)
  func setLocationForItemAt(_ index: Int, location: SearchLocationProtocol)
  func setTagsForItemAt(_ index: Int, tags: [String])
  
  func performDeletePost(_ index: Int)
  
  func performCancelUploadPost(_ index: Int)
  func performRestartUploadPost(_ index: Int)
  
  func acceptInvoice(_ invoice: InvoiceProtocol, for post: PostingProtocol?)
  
  func createGoodsOrderFor(_ post: PostingProtocol)
  
  func checkIfPostCanBeDeletedAmount(_ post: PostingProtocol) -> (Bool, BalanceProtocol)?
  
  //event tracking
  
  func trackViewItemEventAt(_ index: Int)
  func trackPromoActionTapEventAt(_ index: Int)
  func trackCommentEventAt(_ index: Int)
  func trackUpvoteEventAt(_ index: Int, amount: Int)
  func trackCollectEventAt(_ index: Int)
  func trackViewTagEventAt(_ index: Int)
  func trackViewUserProfileEventAt(_ index: Int)
  func trackFollowEventAt(_ index: Int)
  
  //promoted item actions
  
  func pausePromotionActionAt(_ index: Int)
  func resumePromotionActionAt(_ index: Int)
  func stopPromotionActionAt(_ index: Int)
  
  //post ask help actions
  
  func createPostAskHelpFor(_ post: PostingProtocol, draft: CreatePostHelpProtocol)
}


protocol PostsFeedUserViewModelProtocol: DiffableProtocol {
  var username: String { get }
  var userPic: String { get }
  var userpicPlaceholder: UIImage? { get }
  var userScores: String { get }
  var followingTitle: String { get }
  var followingTitleColor: UIColor { get }
  
  var followActionTitle: String { get }
  var friendActionTitle: String { get }
  var muteActionTitle: String { get }
  
  var prizeImage: UIImage? { get }
  var prizeAmount: String { get }
}

protocol PostsFeedContentViewModelProtocol: DiffableProtocol {
  var contentSize: CGSize { get }
  var content: [PostsFeed.ContentViewModelType] { get }
  
  var soundHelpInfo: String { get }
  var noSoundInfo: String { get }
  var shouldPresentHelpForCurrentUserRequestClojure: UserLevelRequestClojure { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  
  func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeed.ContentViewModelType
}

protocol PostsFeedImageViewModelProtocol {
  var contentSize: CGSize { get }
  var urlString: String { get }
  var shouldPresentVerificationWarning: Bool { get }
}

protocol PostsFeedVideoViewModelProtocol {
  var contentSize: CGSize { get }
  var urlString: String { get }
  var thumbnailImageUrlString: String { get }
}

protocol PostsFeedActionsViewModelProtocol: DiffableProtocol {
  var likesTitleString: String { get }
  var likesCount: Int { get }
  var likesCountOldValue: Int { get }
  var shouldAnimateLikesCount: Bool { get }
  
  var shopItemsCount: String { get }
  var isShopItem: Bool { get }
  var commentsCount: String { get }
  var isLiked: Bool { get }
  var isAddedToFavorites: Bool { get }
  
  var isCollectPromoted: Bool { get }
  var isUpvotePromoted: Bool { get }
  
  var isWinAmountVisible: Bool { get }
  var winAmount: String { get }
  
  var postHelpRequestReward: String { get }
  var hasPostHelpRequest: Bool { get }
  var isPostHelpRequestActive: Bool { get }
}

protocol PostsFeedDescriptionViewModelProtocol: DiffableProtocol {
  var caption: String { get }
  var postingDateTitle: String { get }
  var attributedCaption: NSAttributedString { get }
}

protocol PostsFeedEditDescriptionViewModelProtocol: DiffableProtocol {
  var caption: String { get }
}

protocol PostsFeedDateViewModelProtocol: DiffableProtocol {
  var postingDateTitle: String { get }
  var brushedCountTitle: String { get }
  var brushedCountAttributedTitle: NSAttributedString { get }
}

protocol PostsFeedTagViewModelProtocol {
  var isPromoted: Bool { get }
  var tagTitle: String { get }
  var attributedTagTitle: NSAttributedString { get }
}

protocol PostsFeedTagContainerViewModelProtocol: DiffableProtocol {
  var isPromoted: Bool { get }

  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  
  func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeedTagViewModelProtocol
}

protocol PostsFeedCommentViewModelProtocol: DiffableProtocol {
  var username: String { get }
  var userPic: String { get }
  var body: String { get }
  var isReply: Bool { get }
  var isPending: Bool { get }
  
  var isFirst: Bool { get }
  var isLast: Bool { get }
  var commentIndex: Int { get }
  
  var atrributedCommentWithUsername: NSAttributedString { get }
}

protocol PostsFeedAllCommentsViewModelProtocol: DiffableProtocol {
  var showAllCommentsTitle: String { get }
  var shouldPresentShowAllTitle: Bool { get }
}

typealias AvatarRequestCompletion = (String, UIImage?) -> Void
typealias AvatarRequestClojure = (@escaping AvatarRequestCompletion) -> Void

typealias UserLevelRequestCompletion = (Bool) -> Void
typealias UserLevelRequestClojure = (@escaping UserLevelRequestCompletion) -> Void

protocol PostsFeedAddCommentViewModelProtocol: DiffableProtocol {
//  var userpic: String { get }
//  var userpicPlaceholder: UIImage? { get }
  var commentText: String { get }
  var isSendButtonActive: Bool { get }
  var currentUserAvatarRequestClojure: AvatarRequestClojure { get }
}


protocol PostsFeedItemLocationViewModelProtocol: DiffableProtocol {
  var locationDescription: String { get }
  var isHighlighted: Bool { get }
}

protocol PostsFeedFundingCampaignStatusViewModelProtocol: DiffableProtocol {
  var raisedPerCent: String { get }
  var campaignProgress: Double { get }
  var raisedAmount: String { get }
  var goalAmount: String { get }
}

protocol PostsFeedFundingCampaignTitleViewModelProtocol: DiffableProtocol {
  var campaignTitle: String { get }
  
  var campaignDonateActionName: String { get }
  var campaignEndingDate: String { get }
  var isActive: Bool { get }
   
}

protocol PostsFeedFundingCampaignTeamViewModelProtocol: DiffableProtocol {
  var teamLogoURLString: String? { get }
  var teamName: String { get }
  var teamInfo: String { get }
}

protocol PostsFeedItemPromotionViewModelProtocol: DiffableProtocol {
  var actionTitle: String { get }
  var backgroundColor: UIColor { get }
  var statusTitle: String { get }
}

protocol PostsFeedAddPromotionViewModelProtocol: DiffableProtocol {
  var isAddButtonVisible: Bool { get }
  var addButtonColor: UIColor { get }
}

protocol PostsFeedUploadingViewModelProtocol: DiffableProtocol {
  var stateTitle: String { get }
  var progress: CGFloat { get }
  var cancelButtonEnabled: Bool { get }
  var restartButtonEnabled: Bool { get }
  var shouldPresentProgress: Bool  { get }
}

protocol PostsFeedCommercialInfoViewModelProtocol: DiffableProtocol {
  var commercialPostTitle: String { get }
  var commercialPostPrice: String { get }
  var rewardAmountLabel: String { get }
  var isStatusEnabled: Bool { get }

  var status: String { get }
}

protocol PostsFeedGoodsInfoViewModelProtocol: DiffableProtocol {
  var commercialPostPrice: String { get }
  var commercialPostSalesCount: String { get }
  
  var isNewGood: Bool { get }
  var isAvailabilityStatusVisible: Bool { get }
  var availabilityStatusString: String { get }
}

protocol PostsFeedCommercialErrorViewModelProtocol: DiffableProtocol {
  var errorMessage: String { get }
}

protocol PostsFeedItemsPlaceholderProtocol {
  var image: UIImage? { get }
  var title: String { get }
  var subTitle: String { get }
  var isCreateButtonEnabled: Bool { get }
}


protocol PostsFeedTopGroupItemViewModelProtocol: DiffableProtocol {
  var title: String { get }
  var image: UIImage? { get }
  var isSelected: Bool { get }
   
  var expirationDate: Date? { get }
  var bannerMessage: String { get }
  
  var bannerImageURLString: String { get }
  var hasBannerImage: Bool { get }
  var hasBannerMessage: Bool { get }
}


protocol PostsFeedHomeTopGroupsHeaderViewModelProtocol {
  var groupViewModels: [PostsFeedTopGroupItemViewModelProtocol] { get }
  func diffWithPrevious(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol) -> [CollectionViewModelUpdate]
  
  var bannerImageURLString: String { get }
  var expirationDate: Date? { get }
  var bannerMessage: String { get }
  
  var shouldShowBanner: Bool { get }
  var shouldShowFooter: Bool { get }
  var shouldShowBannerMessage: Bool { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeedTopGroupItemViewModelProtocol
  
  func timerLabelForTimeInterval(_ timeinterval: TimeInterval) -> String
}

extension PostsFeedHomeTopGroupsHeaderViewModelProtocol {
  var isExtended: Bool {
    return shouldShowBanner || shouldShowFooter
  }
}

