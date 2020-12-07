//
//  PostsFeedInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - PostsFeedInteractor Class
final class PostsFeedInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let postingService: PostingServiceProtocol
  fileprivate let mediaCachingService: MediaCachingServiceProtocol
  fileprivate let userInteractionsService: UserInteractionServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let createPostService: CreatePostServiceProtocol
  fileprivate let promotionService: PromotionServiceProtocol
  fileprivate let webSocketsNotificationSubscribeService: WebSocketsNotificationSubscribeServiceProtocol
  
  fileprivate let topGroupPostsService: TopGroupPostsServiceProtocol
  
  fileprivate let eventTrackingService: EventsTrackingServiceProtocol
  fileprivate let postHelpService: PostHelpServiceProtocol
  
  fileprivate let tagService: TagServiceProtocol
  fileprivate let placeService: PlaceServiceProtocol
  fileprivate let walletService: WalletServiceProtocol
  
  fileprivate var currentFeed: PostsFeed.FeedType
  
  fileprivate let itemsSection = 0
  fileprivate let paginationType: PostsFeed.PaginationType
  
  fileprivate let inPlaceUpvoteAmount = 10
  
  fileprivate var selectedPost: PostingManagedObject?
  fileprivate var lastTrackedViewAtIndex: Int?
  
  fileprivate var paginationController: PaginationControllerProtocol
  
  fileprivate var topGroups: [TopGroup]?
  
  fileprivate lazy var fetchResultController: NSFetchedResultsController<PostingManagedObject> = {
    let fetchRequest: NSFetchRequest<PostingManagedObject> = PostingManagedObject.fetchRequest()
    fetchRequest.predicate = fetchPredicate(for: currentFeed)
    fetchRequest.sortDescriptors = sortDesriptors(for: currentFeed)
    fetchRequest.fetchBatchSize = 100
    fetchRequest.returnsObjectsAsFaults = true
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil,
                                                              cacheName: cacheName(for: currentFeed))
    
    fetchedResultsController.delegate = fetchedResultsControllerDelegateProxy
    return fetchedResultsController
  }()
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       postingService: PostingServiceProtocol,
       mediaCachingService: MediaCachingServiceProtocol,
       userInteractionsService: UserInteractionServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       tagService: TagServiceProtocol,
       placeService: PlaceServiceProtocol,
       walletService: WalletServiceProtocol,
       createPostService: CreatePostServiceProtocol,
       webSocketsNotificationSubscribeService: WebSocketsNotificationSubscribeServiceProtocol,
       eventTrackingService: EventsTrackingServiceProtocol,
       promotionService: PromotionServiceProtocol,
       topGroupPostsService: TopGroupPostsServiceProtocol,
       postHelpService: PostHelpServiceProtocol,
       
       feedType: PostsFeed.FeedType,
       paginationConfig: PostsFeed.PaginationType) {
    self.coreDataStorage = coreDataStorage
    self.postingService = postingService
    self.mediaCachingService = mediaCachingService
    self.userInteractionsService = userInteractionsService
    self.accountProfileService = accountProfileService
    self.createPostService = createPostService
    self.walletService = walletService
    self.eventTrackingService = eventTrackingService
    self.promotionService = promotionService
    self.topGroupPostsService = topGroupPostsService
    self.postHelpService = postHelpService
    
    self.webSocketsNotificationSubscribeService = webSocketsNotificationSubscribeService
    
    self.tagService = tagService
    self.placeService = placeService
    self.currentFeed = feedType
    self.paginationType = paginationConfig
    
    self.paginationController = PostsFeedInteractor.paginationControllerForFeedType(feedType, config: paginationConfig)
    
    super.init()
    self.paginationController.delegate = self
  }
}

//MARK:- PostsFeedInteractor static helpers

extension PostsFeedInteractor {
  fileprivate static func paginationControllerForFeedType(_ feedType: PostsFeed.FeedType, config: PostsFeed.PaginationType) -> PaginationControllerProtocol {
    switch feedType {
    case .main:
      return CursorPaginationController(requestItems: config.requestItems, shouldRefreshInTheMiddle: true)
    case .userPosts(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .singlePost(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .favoritesPosts(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .upvotedPosts(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .discover, .discoverDetailFeedFor:
      return CursorPaginationController(requestItems: config.requestItems, shouldRefreshInTheMiddle: false)
    case .postsRelatedToTag(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .postsRelatedToPlace(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .currentUserCommercePosts(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .currentUserPurchasedCommercePosts(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .userPromotedPosts(_, _):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .topGroupsPosts(let groupType):
      switch groupType {
      case .news, .coin, .webtoon, .newbie, .funding, .promoted, .shop:
        return CursorPaginationController(requestItems: config.requestItems, shouldRefreshInTheMiddle: true)
      case .hot:
        return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
      }
    case .winnerPosts:
      return CursorPaginationController(requestItems: config.requestItems, shouldRefreshInTheMiddle: true)
      
    case .currentUserActiveFundingPosts(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .currentUserEndedFundingPosts(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    case .currentUserBackedFundingPosts(_):
      return PaginationController(itemsPerPage: config.itemsPerPage, requestItems: config.requestItems, shouldRefreshTop: false)
    }
  }
}

// MARK: - PostsFeedInteractor API

extension PostsFeedInteractor: PostsFeedInteractorApi {
  func createPostAskHelpFor(_ post: PostingProtocol, draft: CreatePostHelpProtocol) {
    postHelpService.createPostHelpFor(post, postHelp: draft) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      if let error = $0 {
        strongSelf.presenter.handleError(error)
        return
      }
      
      strongSelf.requestPost(post)
    }
  }
  
  func createGoodsOrderFor(_ post: PostingProtocol) {
    guard let goodsInfo = post.goodsInfo else {
      return
    }
    
    walletService.createOrderFor(post: post, goodsInfo: goodsInfo) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(_):
        strongSelf.presenter.presentOrderCreationSuccess()
        strongSelf.requestPost(post)
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  func deselectTopGroups() {
    guard let _ = currentFeed.selectedGroup, let topGroups = topGroups else {
      return
    }
    
    performChangeFeedTypeTo(.main)
    presenter.presentTopGroups(topGroups, selectedGroup: nil)
  }
  
  func selectTopGroupAt(_ index: Int) {
    guard let topGroups = topGroups, index < topGroups.count else {
      return
    }
    
    let groupToSelect = topGroups[index]
    
    guard groupToSelect.type == currentFeed.selectedGroup else {
      performChangeFeedTypeTo(.topGroupsPosts(groupToSelect.type))
      presenter.presentTopGroups(topGroups, selectedGroup: groupToSelect.type)
      return
    }
    
    presenter.presentTopGroups(topGroups, selectedGroup: nil)
    performChangeFeedTypeTo(.main)
  }
  
  fileprivate func performChangeFeedTypeTo(_ feedType: PostsFeed.FeedType) {
    fetchedResultsControllerDelegateProxy.isEnabled = false
    
    
    let predicate = fetchPredicate(for: feedType)
    fetchResultController.fetchRequest.predicate = predicate
    fetchResultController.fetchRequest.sortDescriptors = sortDesriptors(for: feedType)
    NSFetchedResultsController<PostingManagedObject>.deleteCache(withName: fetchResultController.cacheName)
    perfromFRCFetch()
    fetchedResultsControllerDelegateProxy.isEnabled = true
    
    currentFeed = feedType
    paginationController = PostsFeedInteractor.paginationControllerForFeedType(feedType, config: paginationType)
    paginationController.delegate = self
   
    initialRefreshCollection()
  }
  
  func pausePromotionActionAt(_ index: Int) {
    guard let item = itemIfExistFor(index),
      let promotion = item.promotion
    
    else {
      return
    }
    promotion.changePauseStatus()
    
    coreDataStorage.batchUpdateStorage(with: [promotion])
    promotionService.changePauseStateForPromotion(promotion) { [weak self] in
      switch $0 {
      case .success(let promo):
        self?.coreDataStorage.batchUpdateStorage(with: [promo])
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func resumePromotionActionAt(_ index: Int) {
    pausePromotionActionAt(index)
  }
  
  func stopPromotionActionAt(_ index: Int) {
    guard let item = itemIfExistFor(index),
      let promotion = item.promotion
      
      else {
        return
    }
    let currentStatus = promotion.promotionStatus
    promotion.setStatus(.closed)
    
    coreDataStorage.batchUpdateStorage(with: [promotion])
    promotionService.closePromotion(promotion) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
        promotion.setStatus(currentStatus)
        self?.coreDataStorage.batchUpdateStorage(with: [promotion])
      }
    }
  }
  
  func trackViewItemEventAt(_ index: Int) {
    guard shouldTrackEventOnCurrentFeedType(.impression, for: currentFeed),
      let post = itemIfExistFor(index),
      let user = currentUserAccount,
      lastTrackedViewAtIndex != index
      else {
        return
    }
    lastTrackedViewAtIndex = index
    eventTrackingService.trackEvent(InteractionEvent(type: .impression, postId: post.identifier, userId: user.identifier, promoId: post.promotion?.identifier))
  }
  
  func trackPromoActionTapEventAt(_ index: Int) {
    guard shouldTrackEventOnCurrentFeedType(.actionButtonTap, for: currentFeed),
      let post = itemIfExistFor(index),
      let user = currentUserAccount
      else {
        return
    }
    
    eventTrackingService.trackEvent(InteractionEvent(type: .actionButtonTap, postId: post.identifier, userId: user.identifier, promoId: post.promotion?.identifier))
  }
  
  func trackCommentEventAt(_ index: Int) {
    guard shouldTrackEventOnCurrentFeedType(.comment, for: currentFeed),
      let post = itemIfExistFor(index),
      let user = currentUserAccount
      else {
        return
    }
    
    eventTrackingService.trackEvent(InteractionEvent(type: .comment, postId: post.identifier, userId: user.identifier, promoId: post.promotion?.identifier))
  }
  
  func trackUpvoteEventAt(_ index: Int, amount: Int) {
    guard shouldTrackEventOnCurrentFeedType(.upvote, for: currentFeed),
      let post = itemIfExistFor(index),
      let user = currentUserAccount
      else {
        return
    }
    
    eventTrackingService.trackEvent(InteractionEvent(type: .upvote, postId: post.identifier, userId: user.identifier, promoId: post.promotion?.identifier, value: Double(amount)))
  }
  
  func trackCollectEventAt(_ index: Int) {
    guard shouldTrackEventOnCurrentFeedType(.collect, for: currentFeed),
      let post = itemIfExistFor(index),
      let user = currentUserAccount
      else {
        return
    }
    
    eventTrackingService.trackEvent(InteractionEvent(type: .collect, postId: post.identifier, userId: user.identifier, promoId: post.promotion?.identifier))
  }
  
  func trackViewTagEventAt(_ index: Int) {
    guard shouldTrackEventOnCurrentFeedType(.tag, for: currentFeed),
      let post = itemIfExistFor(index),
      let user = currentUserAccount
      else {
        return
    }
    
    eventTrackingService.trackEvent(InteractionEvent(type: .tag, postId: post.identifier, userId: user.identifier, promoId: post.promotion?.identifier))
  }
  
  func trackViewUserProfileEventAt(_ index: Int) {
    guard shouldTrackEventOnCurrentFeedType(.profileView, for: currentFeed),
      let post = itemIfExistFor(index),
      let user = currentUserAccount
      else {
        return
    }
    
    eventTrackingService.trackEvent(InteractionEvent(type: .profileView, postId: post.identifier, userId: user.identifier, promoId: post.promotion?.identifier))
  }
  
  func trackFollowEventAt(_ index: Int) {
    guard shouldTrackEventOnCurrentFeedType(.following, for: currentFeed),
      let post = itemIfExistFor(index),
      let user = currentUserAccount
      else {
        return
    }
    
    eventTrackingService.trackEvent(InteractionEvent(type: .following, postId: post.identifier, userId: user.identifier, promoId: post.promotion?.identifier))
  }
  
  fileprivate func shouldTrackEventOnCurrentFeedType(_ eventType: TrackedEventType, for feedType: PostsFeed.FeedType) -> Bool {
    switch feedType {
    case .main:
      return true
    case .userPosts(_):
      return true
    case .singlePost(_):
      return false
    case .favoritesPosts(_):
      return false
    case .upvotedPosts(_):
      return true
    case .discover, .discoverDetailFeedFor:
      return true
    case .postsRelatedToTag(_):
      return false
    case .postsRelatedToPlace(_):
      return false
    case .currentUserCommercePosts(_):
      return false
    case .currentUserPurchasedCommercePosts(_):
      return false
    case .userPromotedPosts(_, _):
      return false
    case .topGroupsPosts(_):
      return true
    case .winnerPosts:
      return true
    case .currentUserActiveFundingPosts(_):
      return false
    case .currentUserEndedFundingPosts(_):
      return false
    case .currentUserBackedFundingPosts(_):
      return false
    }
  }
  
  var currentlySelectedItem: PostingProtocol? {
    return selectedPost
  }
  
  func selectItemAt(_ index: Int) {
    selectedPost = itemIfExistFor(index)
  }
  
  func deselectItem() {
    selectedPost = nil
  }
  
  var indexForSelectedItem: Int? {
    guard let item = selectedPost else {
      return nil
    }
    
    return fetchResultController.indexPath(forObject: item)?.item
  }
  
  
  func performUpVoteInPlaceAt(_ index: Int) {
    performUpVoteAt(index, withAmount: inPlaceUpvoteAmount)
  }
  
  func checkIfPostCanBeDeletedAmount(_ post: PostingProtocol) -> (Bool, BalanceProtocol)? {
    guard post.isMyPosting else {
      return nil
    }
    
    guard let user = post.postingUser else {
      return nil
    }
    
    let amount = post.deleteCostAmount
    
    return (!user.redBrushWalletBalance.isLess(than: amount.value), amount)
  }
  
  
  func acceptInvoice(_ invoice: InvoiceProtocol, for post: PostingProtocol?) {
    walletService.acceptInvoice(invoice.identifier) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(_):
        strongSelf.presenter.presentInvoicePaymentSuccess()
        strongSelf.requestPost(post)
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  func subscribeWebSocketUpdates() {
    webSocketsNotificationSubscribeService.subscribe(self)
  }
  
  func unsubscribeWebSocketUpdates() {
    webSocketsNotificationSubscribeService.unsubscribe()
  }
  
  func performCancelUploadPost(_ index: Int) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    createPostService.cancelUploadingTask(post: item)
    item.setLocallyDeleted(true)
    coreDataStorage.batchUpdateStorage(with: [item])
  }
  
  func performRestartUploadPost(_ index: Int) {
    AppLogger.error("performRestartUploadPost is not implemented")
  }
  
  func performDeletePost(_ index: Int) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    item.setLocallyDeleted(true)
    coreDataStorage.batchUpdateStorage(with: [item])
    postingService.deletePost(post: item) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  func setTagsForItemAt(_ index: Int, tags: [String]) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    postingService.changeTagsForPost(post: item, tags: tags) { [weak self] in
      switch $0 {
      case .success(let updatedPost):
        self?.coreDataStorage.updateStorage(with: [updatedPost])
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func applyPostDescriptionChanges(_ index: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    let oldCaption = posting.postingCaption
    let captionDraft = posting.editedCaptionDraft ?? ""
    posting.caption = captionDraft
    posting.setBeingEditedState(false)
    postingService.changeCaptionForPost(post: posting, caption: captionDraft) { [weak self] in
      switch $0 {
      case .success(let updatedPost):
        self?.coreDataStorage.updateStorage(with: [updatedPost])
        self?.presenter.presentPostDescriptionEditSuccess()
      case .failure(let error):
        posting.caption = oldCaption
        self?.presenter.handleError(error)
      }
    }
  }
  
  func setPostDescriptionFor(_ index: Int, text: String) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    posting.setPostCaptionDraft(text)
    guard let isBeingEditedState = posting.isBeingEditedState, isBeingEditedState else {
      posting.setBeingEditedState(true)
      coreDataStorage.updateStorage(with: [posting])
      return
    }
  }
  
  func removeLocationForItemAt(_ index: Int) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    postingService.removePlaceForPost(post: item) { [weak self] in
      switch $0 {
      case .success(let post):
        self?.coreDataStorage.batchUpdateStorage(with: [post])
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func setLocationForItemAt(_ index: Int, location: SearchLocationProtocol) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    postingService.changePlaceForPost(post: item, place: location) { [weak self] in
      switch $0 {
      case .success(let post):
        self?.coreDataStorage.batchUpdateStorage(with: [post])
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func setBeingEditedStateAt(_ index: Int, isBeingEdited: Bool) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    posting.setBeingEditedState(isBeingEdited)
    coreDataStorage.batchUpdateStorage(with: [posting])
  }
  
  func trackSharingFor(_ posting: PostingProtocol) {
    postingService.trackSharingFor(postId: posting.identifier) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  func requestUser(completeHandler: @escaping (UserProtocol) -> Void) {
    guard let userProfile = currentUserAccount else {
      accountProfileService.getProfile(complete: {
        switch $0 {
        case .success(let userProfile):
          completeHandler(userProfile)
        case .failure(_):
          break
        }
      })
      return
    }
    
    completeHandler(userProfile)
  }
  
  func performUpVoteUser(_ user: UserProtocol, withAmount: Int) {
    userInteractionsService.upvote(user: user, amount: withAmount) { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
      }
    }
  }
  
  var currentUserAccount: UserProtocol? {
    return accountProfileService.currentUserAccount
  }
  
  func performCommentPosting(_ index: Int, text: String) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    let storageService = coreDataStorage
    
    let commentBody = text.cleanedFromExtraNewLines()
    let commentDraft = CommentDraft(commentUser: accountProfileService.currentUserAccount, commentBody: commentBody)
    
    let commentDraftWithPost = CommentsRelations.commentForPost(comment: commentDraft, posting: posting, isPreviewComment: true)
    posting.commentDraft = ""
    
    
    storageService.updateStorage(with: [commentDraftWithPost])
    
    postingService.createCommentFor(postId: posting.identifier, body: commentBody) { [weak self] in
      
      commentDraft.setLocallyDeleted(true)
      
      guard let strongSelf = self else {
        storageService.updateStorage(with: [commentDraft])
        return
      }
      
      switch $0 {
      case .success(_):
       
       
//        posting.hasCommentDraft = false
//        posting.cachedPostsFeedViewModelsCount = Int16(posting.evaluatePostsFeedPresenterItemsCount())
//
        
        strongSelf.postingService.showPosting(postId: posting.identifier) { [weak self] in
          switch $0 {
          case .success(let updatedPosting):
            storageService.updateStorage(with: [updatedPosting, commentDraft])
          case .failure(let error):
            storageService.updateStorage(with: [commentDraft])
            self?.presenter.handleError(error)
          }
        }
      case .failure(let error):
        storageService.updateStorage(with: [commentDraft])
        self?.presenter.handleError(error)
      }
    }
    
    trackCommentEventAt(index)
  }
  
  func addCommentDraftFor(_ index: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    guard !posting.hasCommentDraft else {
      return
    }
    
    posting.commentDraft = ""
    
    posting.addCommentDraft()
    coreDataStorage.updateStorage(with: [posting])
  }
    
  func setCommentDraftFor(_ index: Int, text: String) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    posting.commentDraft = text
    
    if !posting.hasCommentDraft {
      posting.addCommentDraft()
      coreDataStorage.updateStorage(with: [posting])
    }
  }
  
  func expandFundingItemFor(_ index: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    guard let _ = posting.fundingCampaign else {
      return
    }
    
    if !posting.isFundingPresentationExtended {
      posting.extendFundingItem()
      coreDataStorage.updateStorage(with: [posting])
    }
  }
  
  func performFriendActionAt(_ index: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    guard let user = posting.postingUser else {
      return
    }
    
    guard !posting.isMyPosting else {
      return
    }
    
    userInteractionsService.requestFriendship(user: user) { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
        return
      }
    }
  }
  
  func performBlockReportAt(_ index: Int) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    
    item.isBlocked = true
    coreDataStorage.updateStorage(with: [item])
    
    postingService.reportToBlockPost(item) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  func perforReportAsInappropriateAt(_ index: Int, reason: PostReportReasonProtocol) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    
    item.isBlocked = true
    coreDataStorage.updateStorage(with: [item])
    
    postingService.reportAsInappropriatePost(item, reason: reason) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  func performMuteActionAt(_ index: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    guard let user = posting.user else {
      return
    }
    
    guard !posting.isMyPosting else {
      return
    }
    
    let newMuteState = true
  
    let completeBlock: CompleteHandler = { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
        user.setMuteState(!newMuteState)
        self?.coreDataStorage.updateStorage(with: [user])
        return
      }
    }
    
    user.setMuteState(newMuteState)
    coreDataStorage.updateStorage(with: [user])
    userInteractionsService.setMuteUserSettingsOnMainFeed(user, muted: newMuteState, complete: completeBlock)
  }
  
  func performFavoritesActionAt(_ index: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    let isAddedToFavoritesNow = posting.isAddedToFavorites
    posting.isAddedToFavorites = !isAddedToFavoritesNow
    
    let completeBlock: CompleteHandler = { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
        posting.isAddedToFavorites = isAddedToFavoritesNow
        return
      }
    }
    
    if isAddedToFavoritesNow {
      postingService.removeFromFavorites(postId: posting.identifier, complete: completeBlock)
    } else {
      postingService.addToFavorites(postId: posting.identifier, complete: completeBlock)
      trackCollectEventAt(index)
    }
  }
  
  func performFollowActionAt(_ index: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    guard let postingUser = posting.user else {
      return
    }
    
    guard !posting.isMyPosting else {
      return
    }
    
    let isFollowingNow = postingUser.isFollowedByCurrentUser
    
    let getPostWithCorrectState = { [weak self] in
      self?.postingService.showPosting(postId: posting.identifier) { [weak self] in
        switch $0 {
        case .success(let updatedPost):
          self?.coreDataStorage.updateStorage(with: [updatedPost])
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
  
    let completeBlock: CompleteHandler = { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
      }
      
      getPostWithCorrectState()
    }
    
    postingUser.setFollowState(!isFollowingNow)
    coreDataStorage.updateStorage(with: [postingUser])
    
    if isFollowingNow {
      userInteractionsService.unfollow(user: postingUser, complete: completeBlock)
    } else {
      userInteractionsService.follow(user: postingUser, complete: completeBlock)
      trackFollowEventAt(index)
    }
  }
  
  func performDonateAt(_ index: Int, withBalance: BalanceProtocol, donatePrice: Double?) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    let completeBlock: CompleteHandler = { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
        return
      }
      
      self?.postingService.showPosting(postId: posting.identifier) { [weak self] in
        switch $0 {
        case .success(let posting):
          guard let strongSelf = self else {
            return
          }
          strongSelf.presenter.presentDonationSuccess()
          strongSelf.coreDataStorage.updateStorage(with: [posting])
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
    
    postingService.donate(postId: posting.identifier, amount: Int(withBalance.value), currency: withBalance.currency, donatePrice: donatePrice, complete: completeBlock)
  }
  
  func performStopFundingAt(_ index: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    
    let completeBlock: CompleteHandler = { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
        return
      }
      
      self?.postingService.showPosting(postId: posting.identifier) { [weak self] in
        switch $0 {
        case .success(let posting):
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.coreDataStorage.updateStorage(with: [posting])
          strongSelf.presenter.presentStopFundingSuccess()
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
    
    postingService.stopFundingCampaign(postId: posting.identifier, complete: completeBlock)
  }
  
  func performUpVoteAt(_ index: Int, withAmount: Int) {
    guard let posting = itemIfExistFor(index) else {
      return
    }
    guard !posting.upVoted else {
      return
    }
    let upVoteAmount = Int32(withAmount)
    posting.upVotesAmountDraft += upVoteAmount
    posting.upVoted = true
    
    let completeBlock: CompleteHandler = { [weak self] in
      if let err = $0 {
        self?.presenter.handleError(err)
        posting.upVotesAmountDraft -= upVoteAmount
        posting.upVoted = false
        return
      }
      
      self?.postingService.showPosting(postId: posting.identifier) { [weak self] in
        switch $0 {
        case .success(let posting):
          guard let strongSelf = self else {
            return
          }
          strongSelf.coreDataStorage.updateStorage(with: [posting])
        case .failure(let error):
          self?.presenter.handleError(error)
          posting.upVotesAmountDraft -= upVoteAmount
          posting.upVoted = false
        }
      }
    }
    
    trackUpvoteEventAt(index, amount: withAmount)
    postingService.upVote(postId: posting.identifier, amount: withAmount, complete: completeBlock)
  }
  
  func prepareItemFor(_ index: Int) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    
    paginationController.paginateBy(index, identifier: cursorFor(item.sortKeys, for: currentFeed))
    prepareMediaFor([item], shouldPrepareContentType: [.image, .video])
  }
  
  func cancelPrepareItemFor(_ index: Int) {
    guard let item = itemIfExistFor(index) else {
      return
    }
    item.postingMedia
      .map { return $0.mediaUrl }
      .forEach { mediaCachingService.cancelPreparingMediaFor($0) }
  }
  
  fileprivate func firstItemIdentifier() -> Int? {
    return itemIfExistFor(0)?.identifier
  }
  
  func performFetchPostingsAndSaveToStorage(cursorId: Int?, perPage: Int) {
    AppLogger.debug("performFetchPostingsAndSaveToStorage id: \(String(describing: cursorId))")
    let isInitialFetch = cursorId == nil
    let feed = currentFeed
    
    switch feed {
    case .main:
      postingService.getMainFeedPosts(cursorId: cursorId, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          strongSelf.prepareMediaFor(postings.0)
          let firstItemId = postings.0.first?.identifier
          let mainFeedPosts: [(relation: PostingsRelations, sortKey: PostSortingKeys)] = postings.0
            .enumerated()
            .map {
              let sortKeys = PostSortingKeys(postIdentifier: $0.element.identifier,
                                              isRecommended: $0.element.isPostRecommendedInMainFeed ?? false,
                                              cursorId: firstItemId ?? $0.element.identifier,
                                              sortId: $0.offset,
                                              isPromo: false,
                                              upvotesCount: $0.element.postingUpVotesCount ?? 0,
                                              prize: $0.element.winnerPrize ?? 0)
              let relation = PostingsRelations.mainFeed(posting: $0.element, sortingKeys: sortKeys)
              
              return (relation, sortKeys)
          }
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: mainFeedPosts.map { $0.relation })
          strongSelf.paginationController.updatePaginationInfo(mainFeedPosts.map { strongSelf.cursorFor($0.sortKey, for: feed) }, paginationInfo: postings.1)
          
          strongSelf.presenter.presentFetchingFinished()
          
          //request and merge promo items
          let requestPromoItemsCount = strongSelf.paginationType.requestPromoItemsForPostsRequested(perPage)
          strongSelf.postingService.fetchPromotedPosts(count: requestPromoItemsCount) { [weak self] in
            guard let strongSelf = self else {
              return
            }
            switch $0 {
            case .success(let promoPosts):
              let mainFeedPromotedPosts: [(relation: PostingsRelations, sortKey: PostSortingKeys)] = zip(mainFeedPosts, promoPosts)
                .map {
                  let sortKeys =
                    PostSortingKeys(postIdentifier: $0.0.sortKey.postIdentifier,
                                    isRecommended: $0.0.sortKey.isRecommended,
                                    cursorId: $0.0.sortKey.cursorId,
                                    sortId: $0.0.sortKey.sortId,
                                    isPromo: true,
                                    upvotesCount: $0.0.sortKey.upvotesCount,
                                    prize: $0.0.sortKey.prize)
                  
                  let relation = PostingsRelations.mainFeed(posting: $0.1, sortingKeys: sortKeys)
                  return (relation, sortKeys)
              }
              strongSelf.coreDataStorage.batchUpdateStorage(with: mainFeedPromotedPosts.map { $0.relation })
            case .failure(let error):
              strongSelf.presenter.handleError(error)
            }
          }
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
      
    case .userPosts(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .singlePost(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .favoritesPosts(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .upvotedPosts(_):
      fatalError("Cursor based pagination is not supported for current feed type")
      
    case .discoverDetailFeedFor(let post):
      let initialPostCursorId = post.identifier + 1 //to get current post also
      let cursorIdOrInitialPostCurrsor = cursorId ?? initialPostCursorId
      
      postingService.getDiscoverPosts(cursorId: cursorIdOrInitialPostCurrsor, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          let relations = postings.0.map { PostingsRelations.discoverDetailedFeed(posting: $0, for: post) }
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: relations)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
        
      }
    case .discover:
      postingService.getDiscoverPosts(cursorId: cursorId, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          let relations = postings.0.map { PostingsRelations.discoverFeed(posting: $0) }
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: relations)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .postsRelatedToTag(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .postsRelatedToPlace(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .currentUserCommercePosts(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .currentUserPurchasedCommercePosts(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .userPromotedPosts(_, _):
      fatalError("Cursor based pagination is not supported for current feed type")
      
    case .topGroupsPosts(let groupType):
      switch groupType {
      case .news, .coin, .webtoon, .newbie, .funding, .promoted, .shop:
        break
      case .hot:
        fatalError("Cursor based pagination is not supported for current feed type")
      }
      
      topGroupPostsService.getTopGroupPostsFor(groupType, cursorId: cursorId, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          let relations: [PostingsRelations]
          
          switch groupType {
          case .news, .coin, .webtoon, .newbie, .funding, .promoted, .shop:
            relations = postings.0.map { PostingsRelations.topGroupFeed(posting: $0, groupType: groupType, sortingKeys: nil) }
          case .hot:
            relations = postings.0.map {
              let sortKeys = PostSortingKeys(postIdentifier: $0.identifier)
              return PostingsRelations.topGroupFeed(posting: $0, groupType: groupType, sortingKeys: sortKeys)
            }
          }
          
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: relations)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .winnerPosts(let user):
      userInteractionsService.getWinnerPostsForUser(username: user.userName, cursor: cursorId, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          let relations = postings.0.map { PostingsRelations.winnerPosts(posting: $0) }
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: relations)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .currentUserActiveFundingPosts(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .currentUserEndedFundingPosts(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    case .currentUserBackedFundingPosts(_):
      fatalError("Cursor based pagination is not supported for current feed type")
    }
    
    
  }
  
  func performFetchPostingsAndSaveToStorage(page: Int, perPage: Int) {
    AppLogger.debug("performFetchPostingsAndSaveToStorage \(page)")
    let isInitialFetch = page == 0
    
    let feed = currentFeed
    switch currentFeed {
    case .main:
      postingService.getMainFeedPosts(page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):

          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()

          strongSelf.prepareMediaFor(postings.0)
          
          let firstItemId = postings.0.first?.identifier
          let mainFeedPosts: [(relation: PostingsRelations, sortKey: PostSortingKeys)] = postings.0
            .enumerated()
            .map {
              let sortKeys = PostSortingKeys(postIdentifier: $0.element.identifier,
                                              isRecommended: $0.element.isPostRecommendedInMainFeed ?? false,
                                              cursorId: firstItemId ?? $0.element.identifier,
                                              sortId: $0.offset,
                                              isPromo: false,
                                              upvotesCount: $0.element.postingUpVotesCount ?? 0,
                                              prize: $0.element.winnerPrize ?? 0)
              let relation = PostingsRelations.mainFeed(posting: $0.element, sortingKeys: sortKeys)
              
              return (relation, sortKeys)
          }
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: mainFeedPosts.map { $0.relation })
          strongSelf.paginationController.updatePaginationInfo(mainFeedPosts.map { strongSelf.cursorFor($0.sortKey, for: feed) }, paginationInfo: postings.1)
          
          
          //request and merge promo items
          let requestPromoItemsCount = strongSelf.paginationType.requestPromoItemsForPostsRequested(perPage)
          strongSelf.postingService.fetchPromotedPosts(count: requestPromoItemsCount) { [weak self] in
            guard let strongSelf = self else {
              return
            }
            switch $0 {
            case .success(let promoPosts):
              let mainFeedPromotedPosts: [(relation: PostingsRelations, sortKey: PostSortingKeys)] = zip(mainFeedPosts, promoPosts)
                .map {
                  let sortKeys =
                    PostSortingKeys(postIdentifier: $0.0.sortKey.postIdentifier,
                                    isRecommended: $0.0.sortKey.isRecommended,
                                    cursorId: $0.0.sortKey.cursorId,
                                    sortId: $0.0.sortKey.sortId,
                                    isPromo: true,
                                    upvotesCount: $0.0.sortKey.upvotesCount,
                                    prize: $0.0.sortKey.prize)
                  
                  let relation = PostingsRelations.mainFeed(posting: $0.1, sortingKeys: sortKeys)
                  return (relation, sortKeys)
              }
              strongSelf.coreDataStorage.batchUpdateStorage(with: mainFeedPromotedPosts.map { $0.relation })
            case .failure(let error):
              strongSelf.presenter.handleError(error)
            }
          }
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .userPosts(let user):
      userInteractionsService.getPostsForuser(username: user.userName, page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          strongSelf.coreDataStorage.batchUpdateStorage(with: postings.0)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
          
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .singlePost(let targetPost):
      postingService.showPosting(postId: targetPost.identifier) { [weak self] in
        switch $0 {
        case .success(let post):
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation([post]))
          
          strongSelf.presenter.presentFetchingFinished()
         
          strongSelf.prepareMediaFor([post])
          strongSelf.coreDataStorage.batchUpdateStorage(with: [post])
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .favoritesPosts:
      postingService.fetchFavoritesPostings(page: page, perPage: perPage) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let postings):
          strongSelf.presenter.presentFetchingFinished()
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          strongSelf.prepareMediaFor(postings.0)
          strongSelf.coreDataStorage.batchUpdateStorage(with: postings.0)
          
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .upvotedPosts(let user):
      userInteractionsService.getUpvotedPostsForuser(username: user.userName,
                                                   page: page,
                                                   perPage: perPage) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let postings):
        if isInitialFetch {
          strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
        }
        
        strongSelf.presenter.presentFetchingFinished()
       
        let relations = postings.0.map { PartialUserRelations.upvotedPostings(user, posting: $0) }
        
        strongSelf.prepareMediaFor(postings.0)
        strongSelf.coreDataStorage.batchUpdateStorage(with: relations)
        strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
      case .failure(let error):
        self?.presenter.handleError(error)
        self?.presenter.presentFetchingFinished()
        }
      }
    case .discoverDetailFeedFor:
      fatalError("Page based pagination is not supported for current feed type")
    case .discover:
      postingService.getDiscoverPosts(page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
         
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          let relations = postings.0.map { PostingsRelations.discoverFeed(posting: $0) }
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: relations)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
        
      }
    case .postsRelatedToTag(let tag):
      tagService.getRelatedPostsFor(tag, page: page, perPage: perPage) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        
        
        switch $0 {
        case .success(let tag, _, let posts, let paginationInfo):
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(posts))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(posts)
          
          let postsRelation = TagsRelations.tagPosts(tag: tag, posts: posts)
          strongSelf.coreDataStorage.batchUpdateStorage(with: [postsRelation])
          strongSelf.paginationController.updatePaginationInfo(posts.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: paginationInfo)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .postsRelatedToPlace(let place):
      placeService.getRelatedPostsFor(place, page: page, perPage: perPage) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(_, let posts, let paginationInfo):
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(posts))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(posts)
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: posts)
          strongSelf.paginationController.updatePaginationInfo(posts.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: paginationInfo)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .currentUserCommercePosts(_):
      postingService.getCurrentUserCommercePosts(page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          strongSelf.coreDataStorage.batchUpdateStorage(with: postings.0)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
          
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .currentUserPurchasedCommercePosts(let user):
      postingService.getCurrentUserPurchasedCommercePosts(page: page, perPage: perPage) { [weak self] in
          guard let strongSelf = self else {
            return
          }
        
          switch $0 {
          case .success(let postings):
            if isInitialFetch {
              strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
            }
            strongSelf.presenter.presentFetchingFinished()
            
            let relations = postings.0.map { PartialUserRelations.purchasedCommercePosts(user, posting: $0) }
            
            strongSelf.prepareMediaFor(postings.0)
            strongSelf.coreDataStorage.batchUpdateStorage(with: relations)
            strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
          case .failure(let error):
            self?.presenter.handleError(error)
            self?.presenter.presentFetchingFinished()
          }
      }
    case .userPromotedPosts(_, let status):
      postingService.getCurrentUserPromotedPostsWithPromotionStatus(status, page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          strongSelf.coreDataStorage.batchUpdateStorage(with: postings.0)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .topGroupsPosts(let groupType):
      switch groupType {
      case .news, .coin, .webtoon, .newbie, .funding, .promoted, .shop:
        fatalError("Page based pagination is not supported for current feed type")
      case .hot:
        break
      }
      
      topGroupPostsService.getTopGroupPostsFor(groupType, page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          let relations: [PostingsRelations]
          let pageIndex = page * perPage
          switch groupType {
          case .news, .coin, .webtoon, .newbie, .funding, .promoted, .shop:
            relations = postings.0.map { PostingsRelations.topGroupFeed(posting: $0, groupType: groupType, sortingKeys: nil) }
          case .hot:
            relations = postings.0
              .enumerated()
              .map {
                let sortKeys = PostSortingKeys(postIdentifier: $0.element.identifier, hotFeedSortId: pageIndex + $0.offset)
                return PostingsRelations.topGroupFeed(posting: $0.element, groupType: groupType, sortingKeys: sortKeys)
            }
          }
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: relations)
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .winnerPosts:
      fatalError("Page based pagination is not supported for current feed type")
    case .currentUserActiveFundingPosts(let currentUser):
      postingService.getCurrentUserFundingPostsWith(.active, page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          strongSelf.coreDataStorage.batchUpdateStorage(with: postings.0.map { PostingsRelations.userActiveFundingPosts(posting: $0) })
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .currentUserEndedFundingPosts(let currentUser):
      postingService.getCurrentUserFundingPostsWith(.ended, page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          
          strongSelf.coreDataStorage.batchUpdateStorage(with: postings.0.map { PostingsRelations.userEndedFundingPosts(posting: $0) })
          
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    case .currentUserBackedFundingPosts(_):
      postingService.getCurrentUserFundingPostsWith(.backed, page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let postings):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performOldObjectsCacheInvalidationRequest(for: feed, skip: strongSelf.postIdsToSkipCacheInvalidation(postings.0))
          }
          
          strongSelf.presenter.presentFetchingFinished()
          
          strongSelf.prepareMediaFor(postings.0)
          strongSelf.coreDataStorage.batchUpdateStorage(with: postings.0.map { PostingsRelations.userBackedPosts(posting: $0) })
          strongSelf.paginationController.updatePaginationInfo(postings.0.map { strongSelf.cursorFor($0.sortKeys, for: feed) }, paginationInfo: postings.1)
        case .failure(let error):
          self?.presenter.handleError(error)
          self?.presenter.presentFetchingFinished()
        }
      }
    }
  }
  
  fileprivate func perfromFRCFetch() {
    do {
      try fetchResultController.performFetch()
    } catch {
      presenter.handleError(error)
    }
  }
  
  fileprivate func fetchTopGroupsIfNeeded() {
    let feed = currentFeed
    if shouldFetchGroupsFor(feed) {
      topGroupPostsService.getTopGroups { [weak self] in
        switch $0 {
        case .success(let topGroups):
          self?.topGroups = topGroups
          self?.presenter.presentTopGroups(topGroups, selectedGroup: feed.selectedGroup)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
  }
  
  func initialRefresh() {
    fetchTopGroupsIfNeeded()
   
    accountProfileService.getProfile { [weak self] in
      switch $0 {
      case .success(let profile):
        self?.presenter.presentCurrentUserProfile(profile)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
    
    initialRefreshCollection()
  }
  
  fileprivate func initialRefreshCollection() {
    paginationController.initialRequest()
  }
  
  fileprivate func itemIfExistFor(_ indexPath: Int) -> PostingManagedObject? {
    let idx = IndexPath(item: indexPath, section: 0)
    
    guard idx.section < fetchResultController.sections?.count ?? 0,
      idx.item < fetchResultController.sections?[idx.section].numberOfObjects ?? 0 else {
        return nil
    }
    
    let item = fetchResultController.object(at: idx)
    return item
  }
  
  func itemFor(_ indexPath: Int) -> PostingProtocol? {
    return itemIfExistFor(indexPath)
  }
  
  func numberOfItems() -> Int {
    return fetchResultController.sections?[itemsSection].numberOfObjects ?? 0
  }
  
  func initialFetchData() {
    fetchTopGroupsIfNeeded()
    perfromFRCFetch()
  }
}

// MARK: - Interactor Viper Components Api
private extension PostsFeedInteractor {
  var presenter: PostsFeedPresenterApi {
    return _presenter as! PostsFeedPresenterApi
  }
}

// MARK: - Helpers

extension PostsFeedInteractor {
  fileprivate func requestPost(_ post: PostingProtocol?) {
    guard let post = post else {
      return
    }
    
    postingService.showPosting(postId: post.identifier) { [weak self] in
      switch $0 {
      case .success(let updatedPosting):
        self?.coreDataStorage.updateStorage(with: [updatedPosting])
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func indexPathFor(_ post: PostingProtocol) -> IndexPath? {
    let managedObject = PostingManagedObject.replaceOrCreate(with: post, in: fetchResultController.managedObjectContext)
    return fetchResultController.indexPath(forObject: managedObject)
  }
  
  var currentFeedType: PostsFeed.FeedType {
    return currentFeed
  }
  
  fileprivate func prepareMediaFor(_ items: [PostingProtocol], shouldPrepareContentType: [ContentType] = [.image]) {
    prepareMediaFor(items,
                    prepareMediaContentUrlType: paginationType.prefetchMediaContentUrlType,
                    shouldPrepareContentType: shouldPrepareContentType)
  }
  
  fileprivate func prepareMediaFor(_ items: [PostingProtocol],
                                   prepareMediaContentUrlType: PostsFeed.PrefetchMediaContentUrlType,
                                   shouldPrepareContentType: [ContentType]) {
    
    let contentTypesToPrepare = Set(shouldPrepareContentType)
    let _ = items.compactMap {
      return $0.postingMedia
        .first
        .map {
          switch prepareMediaContentUrlType {
          case .mediaUrl:
            if contentTypesToPrepare.contains($0.contentType) {
              mediaCachingService.prepareMediaFor($0.mediaUrl, type: $0.contentType)
            } else {
              mediaCachingService.prepareMediaFor($0.posterUrl, type: .image)
            }
          case .thumbnail:
             mediaCachingService.prepareMediaFor($0.thumbnailUrl, type: .image)
          }
      }
    }
  }
  
  fileprivate func prepareMediaFor(_ items: [PartialPostingProtocol], shouldPrepareContentType: [ContentType] = [.image])  {
    prepareMediaFor(items,
                    prepareMediaContentUrlType: paginationType.prefetchMediaContentUrlType,
                    shouldPrepareContentType: shouldPrepareContentType)
  }
  
  fileprivate func prepareMediaFor(_ items: [PartialPostingProtocol],
                                   prepareMediaContentUrlType: PostsFeed.PrefetchMediaContentUrlType,
                                   shouldPrepareContentType: [ContentType]) {
    
    let contentTypesToPrepare = Set(shouldPrepareContentType)
    
    let _ = items.compactMap {
      return $0.postingMedia?
        .first
        .map {
          switch prepareMediaContentUrlType {
          case .mediaUrl:
            if contentTypesToPrepare.contains($0.contentType) {
              mediaCachingService.prepareMediaFor($0.mediaUrl, type: $0.contentType)
            } else {
              mediaCachingService.prepareMediaFor($0.posterUrl, type: .image)
            }
          case .thumbnail:
            mediaCachingService.prepareMediaFor($0.thumbnailUrl, type: .image)
          }
      }
    }
  }
  
  fileprivate func predicateForCacheInvalidation(for feedType: PostsFeed.FeedType) -> NSPredicate {
    let isNotDraftPredicate = NSPredicate(format: "isDraft == %@", NSNumber(value: false))
    let plainFetchPredicate = plainFetchPredicatate(for: feedType)
    return NSCompoundPredicate(andPredicateWithSubpredicates: [isNotDraftPredicate, plainFetchPredicate])
  }
  
  fileprivate func plainFetchPredicatate(for feedType: PostsFeed.FeedType) -> NSPredicate {
    //plain predicate do not require joins of table
    //needed to be able to perform batch operations
    
    var predicates: [NSPredicate] = []
    
    let isNotDeletedPredicate = NSPredicate(format: "isLocallyDeletedPost == %@", NSNumber(value: false))
    predicates.append(isNotDeletedPredicate)
    
    let isNotBlockedPredicate = NSPredicate(format: "isBlocked == %@", NSNumber(value: false))
    
    predicates.append(isNotBlockedPredicate)
    
    let isNotDraftPredicate = NSPredicate(format: "isDraft == %@", NSNumber(value: false))
    
    switch feedType {
    case .main:
      //we show drafts only in main feed
      break
    case .userPosts(_):
      predicates.append(isNotDraftPredicate)
    case .singlePost(_):
      predicates.append(isNotDraftPredicate)
    case .favoritesPosts(_):
      predicates.append(isNotDraftPredicate)
    case .upvotedPosts(_):
      predicates.append(isNotDraftPredicate)
    case .discover:
      predicates.append(isNotDraftPredicate)
    case .discoverDetailFeedFor:
      predicates.append(isNotDraftPredicate)
    case .postsRelatedToTag(_):
      predicates.append(isNotDraftPredicate)
    case .postsRelatedToPlace(_):
      predicates.append(isNotDraftPredicate)
    case .currentUserCommercePosts(_):
      predicates.append(isNotDraftPredicate)
    case .currentUserPurchasedCommercePosts(_):
      predicates.append(isNotDraftPredicate)
    case .userPromotedPosts(_, _):
      predicates.append(isNotDraftPredicate)
    case .topGroupsPosts(_):
      predicates.append(isNotDraftPredicate)
    case .winnerPosts(_):
      predicates.append(isNotDraftPredicate)
    case .currentUserActiveFundingPosts(_):
      predicates.append(isNotDraftPredicate)
    case .currentUserEndedFundingPosts(_):
      predicates.append(isNotDraftPredicate)
    case .currentUserBackedFundingPosts(_):
      predicates.append(isNotDraftPredicate)
    }
    
    if let feedPredicate = feedTypeFetchPredicate(for: feedType) {
      predicates.append(feedPredicate)
    }
    
    return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
  }
  
  fileprivate func fetchPredicate(for feedType: PostsFeed.FeedType) -> NSPredicate {
    var predicates: [NSPredicate] = []
    
    let plainPredicate = plainFetchPredicatate(for: feedType)
    predicates.append(plainPredicate)
    
    let isNotMutedUserPredicate = NSPredicate(format: "user.isMuted == %@", NSNumber(value: false))
    
    switch feedType {
    case .main:
      let isDraftPredicate = NSPredicate(format: "isDraft == %@", NSNumber(value: true))
      let notMutedOrDraftPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [isNotMutedUserPredicate, isDraftPredicate])
      predicates.append(notMutedOrDraftPredicate)
    case .userPosts(_):
      break
    case .singlePost(_):
      break
    case .favoritesPosts(_):
      break
    case .upvotedPosts(_):
      break
    case .discover, .discoverDetailFeedFor:
      break
    case .postsRelatedToTag(_):
      break
    case .postsRelatedToPlace(_):
      break
    case .currentUserCommercePosts(_):
      break
    case .currentUserPurchasedCommercePosts(_):
      break
    case .userPromotedPosts(_, _):
      break
    case .topGroupsPosts(_):
      predicates.append(isNotMutedUserPredicate)
    case .winnerPosts(_):
      break
    case .currentUserActiveFundingPosts(_):
      break
    case .currentUserEndedFundingPosts(_):
      break
    case .currentUserBackedFundingPosts(_):
      break
    }
    
    return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
  }
  
  fileprivate func feedTypeFetchPredicate(for feedType: PostsFeed.FeedType) -> NSPredicate? {
    switch feedType {
    case .main:
      return NSPredicate(format: "isMainFeed == %@", NSNumber(value: true))
    case .userPosts(let user):
      return NSPredicate(format: "user.id = \(user.identifier)")
    case .singlePost(let post):
      return NSPredicate(format: "id = \(post.identifier)")
    case .favoritesPosts:
      return NSPredicate(format: "isAddedToFavorites == %@", NSNumber(value: true))
    case .upvotedPosts(let user):
      return NSPredicate(format: "ANY upvotedUsers.id = \(user.identifier)")
    case .discover:
      return NSPredicate(format: "isDiscoverFeed == %@", NSNumber(value: true))
    case .discoverDetailFeedFor(let post):
      let postIdEqualPredicate = NSPredicate(format: "id == \(post.identifier)")
      
      let feedPredicate = NSPredicate(format: "discoverDetailFeedForPostId = \(post.identifier)")
      let postIdLessPredicate = NSPredicate(format: "id < \(post.identifier)")
      let relatedPostsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [feedPredicate, postIdLessPredicate])
      return NSCompoundPredicate(orPredicateWithSubpredicates: [postIdEqualPredicate, relatedPostsPredicate])
    case .postsRelatedToTag(let tag):
      return NSPredicate(format: "ANY tags.id = \(tag.identifier)")
    case .postsRelatedToPlace(let place):
      return NSPredicate(format: "location.id = \(place.identifier)")
    case .currentUserCommercePosts(let user):
      let userPredicate = NSPredicate(format: "user.id = \(user.identifier)")
      let postTypePredicate = NSPredicate(format: "type = %@", PostType.commercial.rawValue)
      return NSCompoundPredicate(andPredicateWithSubpredicates: [postTypePredicate, userPredicate])
    case .currentUserPurchasedCommercePosts(let user):
      return NSPredicate(format: "ANY purchasedUsers.id = \(user.identifier)")
    case .userPromotedPosts(let user, let promotionStatus):
      let userPredicate = NSPredicate(format: "user.id = \(user.identifier)")
      let promotionStatusPredicate = NSPredicate(format: "promotion.status = %@", promotionStatus.rawValue)
      switch promotionStatus {
      case .active:
        let datePredicate = NSPredicate(format: "promotion.expirationDate > %@", NSDate())
        return NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, promotionStatusPredicate, datePredicate])
      case .paused:
        let datePredicate = NSPredicate(format: "promotion.expirationDate > %@", NSDate())
        return NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, promotionStatusPredicate, datePredicate])
      case .closed:
        let datePredicate = NSPredicate(format: "promotion.expirationDate < %@", NSDate())
        let dateOrStatusPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [datePredicate, promotionStatusPredicate])
        return NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, dateOrStatusPredicate])
      }
    case .topGroupsPosts(let groupType):
      switch groupType {
      case .news:
        return NSPredicate(format: "isTopGroupNews == %@", NSNumber(value: true))
      case .coin:
        return NSPredicate(format: "isTopGroupCoin == %@", NSNumber(value: true))
      case .webtoon:
        return NSPredicate(format: "isTopGroupWebtoon == %@", NSNumber(value: true))
      case .newbie:
        return NSPredicate(format: "isTopGroupNewbie == %@", NSNumber(value: true))
      case .funding:
        return NSPredicate(format: "isTopGroupFunding == %@", NSNumber(value: true))
      case .promoted:
        return NSPredicate(format: "isTopGroupPromoted == %@", NSNumber(value: true))
      case .shop:
        return NSPredicate(format: "isTopGroupShop == %@", NSNumber(value: true))
      case .hot:
        return NSPredicate(format: "isTopGroupHot == %@", NSNumber(value: true))
      }
    case .winnerPosts(let user):
      return NSPredicate(format: "winnerPostsFeedUserId = \(user.identifier)")
    case .currentUserActiveFundingPosts(let user):
      let fundingTypePredicate = NSPredicate(format: "type = %@", PostType.funding.rawValue)
      let charityTypePredicate = NSPredicate(format: "type = %@", PostType.charity.rawValue)
      let rewardFundingTypePredicate = NSPredicate(format: "type = %@", PostType.crowdfundingWithReward.rawValue)
      let fundingPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [fundingTypePredicate, charityTypePredicate, rewardFundingTypePredicate])
      
      let fundingFeedPredicate = NSPredicate(format: "isActiveFundingsFeed = %@", NSNumber(value: true))
      
      return NSCompoundPredicate(andPredicateWithSubpredicates: [fundingPredicate, fundingFeedPredicate])
      
    case .currentUserEndedFundingPosts(let user):
      let fundingTypePredicate = NSPredicate(format: "type = %@", PostType.funding.rawValue)
      let charityTypePredicate = NSPredicate(format: "type = %@", PostType.charity.rawValue)
      let rewardFundingTypePredicate = NSPredicate(format: "type = %@", PostType.crowdfundingWithReward.rawValue)
      let fundingPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [fundingTypePredicate, charityTypePredicate, rewardFundingTypePredicate])
      
      let fundingFeedPredicate = NSPredicate(format: "isEndedFundingsFeed = %@", NSNumber(value: true))
      
      return NSCompoundPredicate(andPredicateWithSubpredicates: [fundingPredicate, fundingFeedPredicate])
    case .currentUserBackedFundingPosts(_):
      let fundingTypePredicate = NSPredicate(format: "type = %@", PostType.funding.rawValue)
      let charityTypePredicate = NSPredicate(format: "type = %@", PostType.charity.rawValue)
      let rewardFundingTypePredicate = NSPredicate(format: "type = %@", PostType.crowdfundingWithReward.rawValue)
      let fundingPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [fundingTypePredicate, charityTypePredicate, rewardFundingTypePredicate])
      
      let backedFeedPredicate = NSPredicate(format: "isBackedByCurrentUserFundingsFeed == %@", NSNumber(value: true))
      
      return NSCompoundPredicate(andPredicateWithSubpredicates: [fundingPredicate, backedFeedPredicate])
    }
  }
  
  fileprivate func cursorFor(_ sortingKeys: PostSortingKeys, for feedType: PostsFeed.FeedType) -> Cursor {
    switch feedType {
    case .main:
      let isRecommendedKey = (sortingKeys.isRecommended ?? false) ? 1 : 0
      let isPromoKey = (sortingKeys.isPromo ?? false) ? 1 : 0
      
      let sortIds: [Int] = [isRecommendedKey,
                             sortingKeys.cursorId ?? sortingKeys.postIdentifier,
                             -(sortingKeys.sortId ?? sortingKeys.postIdentifier),
                             -isPromoKey]
      
      return Cursor(id: sortingKeys.postIdentifier, sortIds: sortIds)
    case .userPosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .singlePost(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .favoritesPosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .upvotedPosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [-sortingKeys.postIdentifier])
    case .discover:
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .discoverDetailFeedFor:
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .postsRelatedToTag(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .postsRelatedToPlace(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .currentUserCommercePosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .currentUserPurchasedCommercePosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .userPromotedPosts(_, _):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .topGroupsPosts(let groupType):
      switch groupType {
      case .news:
        return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
      case .coin:
        return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
      case .webtoon:
        return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
      case .newbie:
        return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
      case .funding:
        return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
      case .promoted:
        return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
      case .shop:
        return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
      case .hot:
        return Cursor(id: sortingKeys.postIdentifier, sortIds: [-(sortingKeys.hotFeedSortId ?? 0)])
      }
      
    case .winnerPosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .currentUserActiveFundingPosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .currentUserEndedFundingPosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    case .currentUserBackedFundingPosts(_):
      return Cursor(id: sortingKeys.postIdentifier, sortIds: [sortingKeys.postIdentifier])
    }
  }
  
  fileprivate func cacheName(for feed: PostsFeed.FeedType) -> String {
    switch feed {
    case .main:
      return "PostsFeedCache"
    case .userPosts(let user):
      return "UserMediaFeedCache_\(user.identifier)"
    case .singlePost(let post):
      return "SinglePostCache_\(post.identifier)"
    case .favoritesPosts(let user):
      return "UserFavoritesCache_\(user.identifier)"
    case .upvotedPosts(let user):
      return "UserUpvotedCache_\(user.identifier)"
    case .discover:
      return "DiscoverMediaFeedCache"
    case .discoverDetailFeedFor(let post):
      return "DiscoverDetailMediaFeedForPostCache_\(post.identifier)"
    case .postsRelatedToTag(let tag):
      return "PostsRelatedToTag\(tag.identifier)"
    case .postsRelatedToPlace(let place):
      return "PostsRelatedToPace\(place.identifier)"
    case .currentUserCommercePosts(let user):
      return "UserCommerceCache_\(user.identifier)"
    case .currentUserPurchasedCommercePosts(let user):
      return "UserPurchasesCache_\(user.identifier)"
    case .userPromotedPosts(let user, let promotionStatus):
      return "UserPromotedPostsCache_\(user.identifier)_\(promotionStatus.rawValue)"
    case .topGroupsPosts(let groupType):
      return "TopGroupsPostsCache_\(groupType.rawValue)"
    case .winnerPosts(let user):
      return "UserWinsPostsFeedCache_\(user.identifier)"
    case .currentUserActiveFundingPosts(let user):
      return "UserActiveFundingCache_\(user.identifier)"
    case .currentUserEndedFundingPosts(let user):
      return "UserEndedFundingCache_\(user.identifier)"
    case .currentUserBackedFundingPosts(let user):
      return "UserBackedFundingCache_\(user.identifier)"
    }
  }
  
  fileprivate func sortDesriptors(for feedType: PostsFeed.FeedType) -> [NSSortDescriptor] {
    switch feedType {
    case .main:
      return [
        //sort descriptors to keep uploading post on top
        NSSortDescriptor(key: #keyPath(PostingManagedObject.isDraft), ascending: false),
        
        NSSortDescriptor(key: #keyPath(PostingManagedObject.isRecommendedInMainFeed), ascending: false),
        NSSortDescriptor(key: #keyPath(PostingManagedObject.mainFeedCursorId), ascending: false),
        NSSortDescriptor(key: #keyPath(PostingManagedObject.mainFeedSortId), ascending: true),
        NSSortDescriptor(key: #keyPath(PostingManagedObject.isPromotedPost), ascending: true),
       
        //sort descriptors to keep uploading posts in order by status and uuid
        NSSortDescriptor(key: #keyPath(PostingManagedObject.draftStatus), ascending: false),
        NSSortDescriptor(key: #keyPath(PostingManagedObject.uuid), ascending: false)]
    case .userPosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .singlePost(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .favoritesPosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .upvotedPosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: true)]
    case .discover, .discoverDetailFeedFor:
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .postsRelatedToTag(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false),
              NSSortDescriptor(key: #keyPath(PostingManagedObject.upVotesAmount), ascending: false),
              NSSortDescriptor(key: #keyPath(PostingManagedObject.totalPromotionsBudget), ascending: false)]
    case .postsRelatedToPlace(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false),
              NSSortDescriptor(key: #keyPath(PostingManagedObject.upVotesAmount), ascending: false),
              NSSortDescriptor(key: #keyPath(PostingManagedObject.totalPromotionsBudget), ascending: false)]
    case .currentUserCommercePosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .currentUserPurchasedCommercePosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .userPromotedPosts(_, _):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .topGroupsPosts(let groupType):
      switch groupType {
      case .news:
        return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
      case .coin:
        return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
      case .webtoon:
        return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
      case .newbie:
        return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
      case .funding:
        return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
      case .promoted:
        return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
      case .shop:
        return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
      case .hot:
        return [NSSortDescriptor(key: #keyPath(PostingManagedObject.hotFeedSortId), ascending: true)]
      }
    case .winnerPosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .currentUserActiveFundingPosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .currentUserEndedFundingPosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    case .currentUserBackedFundingPosts(_):
      return [NSSortDescriptor(key: #keyPath(PostingManagedObject.id), ascending: false)]
    }
  }
  
  
  fileprivate func propertiesToUpdateForCacheInvalidation(for feedType: PostsFeed.FeedType) -> [String: Any]? {
    switch feedType {
    case .main:
      return ["isMainFeed": NSNumber(value: false)]
    case .userPosts(_):
      return nil
    case .singlePost(_):
      return nil
    case .favoritesPosts(_):
      return nil
    case .upvotedPosts(_):
      return nil
    case .discover:
      return ["isDiscoverFeed": NSNumber(value: false)]
    case .discoverDetailFeedFor:
      return ["discoverDetailFeedForPostId": NSNumber(value: 0)]
    case .postsRelatedToTag(_):
      return nil
    case .postsRelatedToPlace(_):
      return nil
    case .currentUserCommercePosts(_):
      return nil
    case .currentUserPurchasedCommercePosts(_):
      return nil
    case .userPromotedPosts(_, _):
      return nil
    case .topGroupsPosts(let groupType):
      switch groupType {
      case .news:
        return ["isTopGroupNews": NSNumber(value: false)]
      case .coin:
        return ["isTopGroupCoin": NSNumber(value: false)]
      case .webtoon:
        return ["isTopGroupWebtoon": NSNumber(value: false)]
      case .newbie:
        return ["isTopGroupNewbie": NSNumber(value: false)]
      case .funding:
        return ["isTopGroupFunding": NSNumber(value: false)]
      case .promoted:
        return ["isTopGroupPromoted": NSNumber(value: false)]
      case .shop:
        return ["isTopGroupShop": NSNumber(value: false)]
      case .hot:
        return ["isTopGroupHot": NSNumber(value: false)]
      }
    case .winnerPosts(_):
      return ["winnerPostsFeedUserId": NSNumber(value: -1)]
    case .currentUserActiveFundingPosts(_):
      return ["isActiveFundingsFeed": NSNumber(value: false)]
    case .currentUserEndedFundingPosts(_):
      return ["isEndedFundingsFeed": NSNumber(value: false)]
    case .currentUserBackedFundingPosts(_):
      return ["isBackedByCurrentUserFundingsFeed": NSNumber(value: false)]
    }
  }
  
  fileprivate func shouldFetchGroupsFor(_ feed: PostsFeed.FeedType) -> Bool {
    switch feed {
    case .main:
      return true
    case .topGroupsPosts(_):
      return true
    default:
      return false
    }
  }
  
  fileprivate func offsetForCacheInvalidation(for feedType: PostsFeed.FeedType) -> Int {
    switch feedType {
    case .main:
      return paginationType.requestItems
    case .discover:
      return 30
    default:
      return 30
    }
  }
  
  fileprivate func postIdsToSkipCacheInvalidation(_ posts: [PostingProtocol]) -> [Int] {
    return posts.map { $0.identifier }
  }
  
  fileprivate func postIdsToSkipCacheInvalidation(_ posts: [PartialPostingProtocol]) -> [Int] {
    return posts.map { $0.identifier }
  }
  
  fileprivate func performOldObjectsCacheInvalidationRequest(for feedType: PostsFeed.FeedType, skip postIds: [Int]) {
    AppLogger.debug("performOldObjectsCacheInvalidationRequest")
    guard let propertiesToUpdate = propertiesToUpdateForCacheInvalidation(for: feedType) else {
      return
    }
    
    let predicate: NSPredicate = predicateForCacheInvalidation(for: feedType)
    guard postIds.count > 0 else {
      coreDataStorage.batchUpdateObjects(PostingManagedObject.self, predicate: predicate, propertiesToUpdate: propertiesToUpdate)
      return
    }
    
    let skipObjectsPredicate =  NSPredicate(format: "NOT (id IN %@)", postIds )
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [skipObjectsPredicate, predicate])
    coreDataStorage.batchUpdateObjects(PostingManagedObject.self, predicate: compoundPredicate, propertiesToUpdate: propertiesToUpdate)
  }
}

//MARK:- FetchedResultsControllerDelegate

extension PostsFeedInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

//MARK:- WebSocketsNotificationDelegateProtocol

extension PostsFeedInteractor: WebSocketsNotificationDelegateProtocol {
  func handleEvent(_ event: WebSocketsEvent) {
    switch event {
    case .newMessage:
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let profile):
          self?.presenter.presentCurrentUserProfile(profile)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
  }
}

//MARK:- PaginationControllerDelegate

extension PostsFeedInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchPostingsAndSaveToStorage(page: page, perPage: perPage)
  }
  
  func request(cursorId: Int, perPage: Int) {
    performFetchPostingsAndSaveToStorage(cursorId: cursorId, perPage: perPage)
  }
  
  func requestInitial(perPage: Int) {
    performFetchPostingsAndSaveToStorage(cursorId: nil, perPage: perPage)
  }
}

//extension PostSortingKeys {
//  var mainFeedCursorSortingArrayKeys: [Int] {
//    let isRecommendedKey = isRecommended ? 1 : 0
//    let isPromoKey = isPromo ? 1 : 0
//
//    return [isRecommendedKey, cursorId, -sortId, -isPromoKey]
//  }
//}

extension PostsFeed.FeedType {
  fileprivate var selectedGroup: TopGroupPostsType? {
    switch self {
    
    case .topGroupsPosts(let groupType):
      return groupType
    default:
      return nil
    }
  }
}
