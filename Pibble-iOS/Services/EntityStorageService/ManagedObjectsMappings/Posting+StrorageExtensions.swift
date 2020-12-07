//
//  Post+StrorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 03.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension PostingManagedObject: PartiallyUpdatable {
  
}

extension PostingManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: PostingProtocol, in context: NSManagedObjectContext) -> PostingManagedObject {
    
    //PostingManagedObject
    let uuidPredicate = NSPredicate(format: "uuid = %@", object.postUUID)
    let managedObject = PostingManagedObject.findOrCreate(predicate: uuidPredicate, in: context)
    
    if let draft = object.postingDraftAttributes, managedObject.createdAt == nil {
      AppLogger.debug("object.postUUID: \(object.postUUID)")
      managedObject.id = Int32(object.identifier)
      managedObject.uuid = object.postUUID
      
      managedObject.draftProgress = draft.draftProgress
      managedObject.draftId = draft.draftId
      managedObject.draftStatus = Int32(draft.status.rawValue)
      managedObject.isLocallyDeletedPost = object.isPostDeleted
      managedObject.isDraft = true
      managedObject.cachedMainMediaFeedViewModelsCount = Int32(managedObject.evaluatePostsFeedPresenterItemsCount())
      
      return managedObject
    }

    managedObject.isDraft = object.postingDraftAttributes != nil
    
    managedObject.id = Int32(object.identifier)
    managedObject.uuid = object.postUUID
    managedObject.type = object.postingType.rawValue
        
    managedObject.caption = object.postingCaption
    managedObject.upVotesCount = Int32(object.postingUpVotesCount)
    managedObject.upVotesAmount = Int32(object.postingUpVotesAmount)
    managedObject.upVotesAmountDraft = Int32(object.postingUpVotesAmountDraft)
    managedObject.commentsCount = Int32(object.postingCommentsCount)
    managedObject.createdAt = object.postingCreatedAt.toNSDate
    managedObject.upVoted = object.isUpVotedByUser
    
    managedObject.hasActiveTagPromotions = object.isTagPromoted
    managedObject.hasActiveSharePromotions = object.isSharePromoted
    managedObject.hasActiveUpVotePromotions = object.isUpvotePromoted
    managedObject.hasActiveCollectPromotions = object.isCollectPromoted
    
    managedObject.isAddedToFavorites = object.isPostingAddedToFavorites
    managedObject.tagsString = object.postingTags.joined(separator: " ")
    
    managedObject.totalPromotionsBudget = NSDecimalNumber(value: object.postingPromotionsTotalBudget)
    managedObject.totalPromotionsSpentBudget = NSDecimalNumber(value: object.postingPromotionsTotalSpentBudget)
    
    managedObject.isLocallyDeletedPost = object.isPostDeleted
    
    if let isBeingEditedState = object.isBeingEditedState {
       managedObject.isBeingEdited = isBeingEditedState
    }
    
    if let editedCaptionDraft = object.editedCaptionDraft {
      managedObject.captionDraft = editedCaptionDraft
    }
    
    if let upVotedDate = object.upVotedDate, let date = upVotedDate.toDateWithCommonFormat() {
      managedObject.upVoteDateString = upVotedDate
      managedObject.upVoteDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    if let hasNewCommentDraft = object.hasNewCommentDraft {
      managedObject.hasCommentDraft = hasNewCommentDraft
    }
    
    if let shouldPresentFundingExtension = object.shouldPresentFundingExtension {
      managedObject.isFundingPresentationExtended = shouldPresentFundingExtension
    }
    
    if let newCommentDraft = object.newCommentDraft {
      managedObject.commentDraft = newCommentDraft
    }
    
    //LocationManagedObject
    
    if let postingPlace = object.postingPlace {
      managedObject.location = LocationManagedObject.replaceOrCreate(with: postingPlace, in: context)
    } else {
      managedObject.location = nil
    }
    
    //UserManagedObject
    
    if let postingUser = object.postingUser {
      if managedObject.user == nil {
        managedObject.triggerRefresh()
      }
  
      managedObject.user = UserManagedObject.replaceOrCreate(with: postingUser, in: context)
    }
    
    managedObject.setValueIfNotNil(\PostingManagedObject.isRecommendedInMainFeed, value: object.isPostRecommendedInMainFeed)
    managedObject.setValueIfNotNil(\PostingManagedObject.uniqueUsersView, value: object.postUniqueUsersViewCount.map { Int32($0) })
    managedObject.setValueIfNotNil(\PostingManagedObject.prize, value: object.winnerPrize.map { NSDecimalNumber(value: $0) })
    
    //Funding
    
    if let funding = object.fundingCampaign {
      managedObject.relatedFundingCampaign = FundingCampaignManagedObject.replaceOrCreate(with: funding, in: context)
    }
    
    if let campaignTeam = object.fundingCampaignTeam {
      let managedTeam = FundingCampaignTeamManagedObject.replaceOrCreate(with: campaignTeam, in: context)
      managedTeam.campaign = managedObject.relatedFundingCampaign
      managedObject.relatedFundingCampaignTeam = managedTeam
    }

    //MediaManagedObject
    
    let _ = object.postingMedia
      .map { return MediaManagedObject.replaceOrCreate(with: $0, in: context) }
      .forEach { $0.posting = managedObject }
    
    //CommentManagedObject
    
    if object.postingCommentsPreview.count > 0,
      let existingCommentsPreview = managedObject.previewComments {
      managedObject.removeFromPreviewComments(existingCommentsPreview)
    }
    
    let _ : [CommentManagedObject] = object.postingCommentsPreview
      .map {
        let comment = CommentManagedObject.replaceOrCreate(with: $0, parentComment: nil, relatedPosting: managedObject, isPreviewComment: true, in: context)
        return comment
      }

    
    //PromotionManagedObject
    
    if let postPromotion = object.postPromotion {
      if managedObject.promotion == nil {
        managedObject.triggerRefresh()
      }
      managedObject.promotion = PromotionManagedObject.replaceOrCreate(with: postPromotion, in: context)
    }
    
    //Commerce
    
    if let commerce = object.commerceInfo {
      managedObject.commerce = CommerceManagedObject.replaceOrCreate(with: commerce, in: context)
    }
    
    if let goodsInfo = object.goodsInfo {
      managedObject.goods = GoodsManagedObject.replaceOrCreate(with: goodsInfo, in: context)
    }
    
    
    //Invoices
    
    if let currentUserInvoice = object.currentUserDigitalGoodPurchaseInvoice {
      let invoice = InvoiceManagedObject.replaceOrCreate(with: currentUserInvoice, in: context)
      managedObject.currentUserPurchaseInvoice = invoice
    }
    
    //Post help
    
    if let postHelp = object.postHelpRequest {
      let shouldTriggerUpdate = postHelp.isHelpClosed != managedObject.helpRequest?.isHelpClosed
      if shouldTriggerUpdate {
        managedObject.triggerRefresh()
      }
      
      managedObject.helpRequest = PostHelpRequestManagedObject.replaceOrCreate(with: postHelp, in: context)
    }
    
    //Cache View Models count for posting
    //should be performed in the end, because depends on posting content
    
    managedObject.cachedMainMediaFeedViewModelsCount = Int32(managedObject.evaluatePostsFeedPresenterItemsCount())
    
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialPostingProtocol, in context: NSManagedObjectContext) -> PostingManagedObject {
    
    //PostingManagedObject
    let uuidPredicate = NSPredicate(format: "uuid = %@", object.postUUID)
    let managedObject = PostingManagedObject.findOrCreate(predicate: uuidPredicate, in: context)
    
    if let draft = object.postingDraftAttributes, managedObject.createdAt == nil {
      AppLogger.debug("object.postUUID: \(object.postUUID)")
      managedObject.id = Int32(object.identifier)
      managedObject.uuid = object.postUUID
      
      managedObject.draftProgress = draft.draftProgress
      managedObject.draftId = draft.draftId
      managedObject.draftStatus = Int32(draft.status.rawValue)
      managedObject.isLocallyDeletedPost = object.isPostDeleted ?? false
      managedObject.isDraft = true
      managedObject.cachedMainMediaFeedViewModelsCount = Int32(managedObject.evaluatePostsFeedPresenterItemsCount())
      
      return managedObject
    }
 
    managedObject.isDraft = object.postingDraftAttributes != nil
    
    managedObject.id = Int32(object.identifier)
    managedObject.uuid = object.postUUID
    
    managedObject.setValueIfNotNil(\PostingManagedObject.type, value: object.postingType?.rawValue)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.caption, value: object.postingCaption)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.upVotesCount, value: object.postingUpVotesCount.map { Int32($0) })
    
    managedObject.setValueIfNotNil(\PostingManagedObject.upVotesAmount, value: object.postingUpVotesAmount.map { Int32($0) })
   
    managedObject.setValueIfNotNil(\PostingManagedObject.upVotesAmountDraft, value: object.postingUpVotesAmountDraft.map { Int32($0) })
    managedObject.setValueIfNotNil(\PostingManagedObject.commentsCount, value: object.postingCommentsCount.map { Int32($0) })
    
    managedObject.setValueIfNotNil(\PostingManagedObject.createdAt, value: object.postingCreatedAt?.toNSDate)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.upVoted, value: object.isUpVotedByUser)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.hasActiveTagPromotions, value: object.isTagPromoted)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.hasActiveSharePromotions, value: object.isSharePromoted)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.hasActiveUpVotePromotions, value: object.isUpvotePromoted)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.hasActiveCollectPromotions, value: object.isCollectPromoted)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.isAddedToFavorites, value: object.isPostingAddedToFavorites)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.tagsString, value: object.postingTags.map { $0.joined(separator: " ") })
    
    managedObject.setValueIfNotNil(\PostingManagedObject.totalPromotionsBudget, value: object.postingPromotionsTotalBudget.map { NSDecimalNumber(value: $0) })
    
   
    managedObject.setValueIfNotNil(\PostingManagedObject.totalPromotionsSpentBudget, value: object.postingPromotionsTotalSpentBudget.map { NSDecimalNumber(value: $0) })
    
    managedObject.setValueIfNotNil(\PostingManagedObject.isLocallyDeletedPost, value: object.isPostDeleted)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.isBeingEdited, value: object.isBeingEditedState)
    
   
    managedObject.setValueIfNotNil(\PostingManagedObject.captionDraft, value: object.editedCaptionDraft)
    
    if let upVotedDate = object.upVotedDate, let date = upVotedDate.toDateWithCommonFormat() {
      managedObject.upVoteDateString = upVotedDate
      managedObject.upVoteDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    
    managedObject.setValueIfNotNil(\PostingManagedObject.hasCommentDraft, value: object.hasNewCommentDraft)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.isFundingPresentationExtended, value: object.shouldPresentFundingExtension)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.commentDraft, value: object.newCommentDraft)
    
    managedObject.setValueIfNotNil(\PostingManagedObject.prize, value: object.winnerPrize.map { NSDecimalNumber(value: $0) })
    
    //LocationManagedObject
    
    if let postingPlace = object.postingPlace {
      managedObject.location = LocationManagedObject.replaceOrCreate(with: postingPlace, in: context)
    } else {
      managedObject.location = nil
    }
    
    //UserManagedObject
    
    if let postingUser = object.postingUser {
      if managedObject.user == nil {
        managedObject.triggerRefresh()
      }
      managedObject.user = UserManagedObject.updateOrCreate(with: postingUser, in: context)
    }
    
    managedObject.setValueIfNotNil(\PostingManagedObject.isRecommendedInMainFeed, value: object.isPostRecommendedInMainFeed)
    managedObject.setValueIfNotNil(\PostingManagedObject.uniqueUsersView, value: object.postUniqueUsersViewCount.map { Int32($0) })
   
    //Funding
    
    if let funding = object.fundingCampaign {
      managedObject.relatedFundingCampaign = FundingCampaignManagedObject.replaceOrCreate(with: funding, in: context)
    }
    
    if let campaignTeam = object.fundingCampaignTeam {
      let managedTeam = FundingCampaignTeamManagedObject.updateOrCreate(with: campaignTeam, in: context)
      managedTeam.campaign = managedObject.relatedFundingCampaign
      managedObject.relatedFundingCampaignTeam = managedTeam
    }
    
    //MediaManagedObject
    
    let _ = object.postingMedia?
      .map { return MediaManagedObject.replaceOrCreate(with: $0, in: context) }
      .forEach { $0.posting = managedObject }
    
    //CommentManagedObject
    
    if let postingCommentsPreview = object.postingCommentsPreview, postingCommentsPreview.count > 0,
      let existingCommentsPreview = managedObject.previewComments {
      managedObject.removeFromPreviewComments(existingCommentsPreview)
    }
    
    object.postingCommentsPreview?
      .forEach {
        let _ = CommentManagedObject.updateOrCreate(with: $0, parentComment: nil, relatedPosting: managedObject, isPreviewComment: true, in: context)
    }
    
    
    //PromotionManagedObject
  
    if let postPromotion = object.postPromotion {
      if managedObject.promotion == nil {
        managedObject.triggerRefresh()
      }
      
      managedObject.promotion = PromotionManagedObject.replaceOrCreate(with: postPromotion, in: context)
    }
    
    //Commerce
    
    if let commerce = object.commerceInfo {
      managedObject.commerce = CommerceManagedObject.replaceOrCreate(with: commerce, in: context)
    }
    
    if let goodsInfo = object.goodsInfo {
      managedObject.goods = GoodsManagedObject.replaceOrCreate(with: goodsInfo, in: context)
    }
    
    //Invoices
    
    if let currentUserInvoice = object.currentUserDigitalGoodPurchaseInvoice {
      let invoice = InvoiceManagedObject.updateOrCreate(with: currentUserInvoice, in: context)
      managedObject.currentUserPurchaseInvoice = invoice
    }
    
    //Post help
    
    if let postHelp = object.postHelpRequest {
      let shouldTriggerUpdate = postHelp.isHelpClosed != managedObject.helpRequest?.isHelpClosed
      if shouldTriggerUpdate {
        managedObject.triggerRefresh()
      }
      
      managedObject.helpRequest = PostHelpRequestManagedObject.updateOrCreate(with: postHelp, in: context)
    }
    
    
    //Cache View Models count for posting
    //should be performed in the end, because depends on posting content
    //triggers post object update
    
    managedObject.cachedMainMediaFeedViewModelsCount = Int32(managedObject.evaluatePostsFeedPresenterItemsCount())
    
    return managedObject
  }
}

extension PostingManagedObject: PostingProtocol {
  var postHelpRequest: PostHelpRequestProtocol? {
    return helpRequest
  }
  
  var goodsInfo: GoodsProtocol? {
    return goods
  }
  
  var winnerPrize: Double? {
    return prize?.doubleValue
  }
  
  var postUniqueUsersViewCount: Int? {
    return Int(uniqueUsersView)
  }
  
  var cursorIdInMainFeed: Int? {
    return Int(mainFeedCursorId)
  }
  
  var sortIdInMainFeed: Int? {
    return Int(mainFeedSortId)
  }
  
  var isPromotedInsertedPost: Bool? {
    return isPromotedPost
  }
  
  var postPromotion: PostPromotionProtocol? {
    return promotion
  }
  
  var isPostRecommendedInMainFeed: Bool? {
    return isRecommendedInMainFeed
  }
  
  var currentUserDigitalGoodPurchaseInvoice: InvoiceProtocol? {
    return currentUserPurchaseInvoice
  }
  
  
  var postingType: PostType {
    return PostType(rawValue: type ?? "")
  }
  
  var commerceInfo: CommerceInfoProtocol? {
    return commerce
  }
  
  var postUUID: String {
    return uuid ?? ""
  }
  
  var postingDraftAttributes: PostDraftAttributes? {
    guard isDraft,
      let draftId = draftId,
      let status = PostCreationStatus(rawValue: Int(draftStatus))
    else {
      return nil
    }
    
    let attributes = PostDraftAttributes(draftId: draftId,
                                         draftProgress: draftProgress,
                                         status: status)
    return attributes
  }
  
  var isPostDeleted: Bool {
    return isLocallyDeletedPost
  }
  
  var editedCaptionDraft: String? {
    return captionDraft
  }
  
  var isBeingEditedState: Bool? {
    return isBeingEdited
  }
  
  var isTagPromoted: Bool {
    return hasActiveTagPromotions
  }
  
  var isSharePromoted: Bool {
    return hasActiveSharePromotions
  }
  
  var isUpvotePromoted: Bool {
    return hasActiveUpVotePromotions
  }
  
  var isCollectPromoted: Bool {
    return hasActiveCollectPromotions
  }
  
  var postingPromotionsTotalBudget: Double {
    return totalPromotionsBudget?.doubleValue ?? 0.0
  }
  
  var postingPromotionsTotalSpentBudget: Double {
    return totalPromotionsSpentBudget?.doubleValue ?? 0.0
  }
 
  var postingPromotions: [PromotionProtocol] {
    return []
  }
  
  var shouldPresentFundingExtension: Bool? {
    return isFundingPresentationExtended
  }
  
  var fundingCampaignTeam: FundingCampaignTeamProtocol? {
    return relatedFundingCampaignTeam
  }
  
  var upVotedDate: String? {
    return upVoteDateString
  }
  
  var fundingCampaign: FundingCampaignProtocol? {
    return relatedFundingCampaign
  }
  
  var postingUpVotesAmountDraft: Int {
    return Int(upVotesAmountDraft)
  }
  
  var newCommentDraft: String? {
    return commentDraft
  }
  
  var hasNewCommentDraft: Bool? {
    return hasCommentDraft
  }
  
  var postingUpVotesAmount: Int {
    return Int(upVotesAmount)
  }

  var isMyPosting: Bool {
    return postingUser?.isCurrent ?? false
  }
 
  var isPostingAddedToFavorites: Bool {
    return isAddedToFavorites
  }
  
  var isUpVotedByUser: Bool {
    return upVoted
  }
  
  var postingCreatedAt: Date {
    return createdAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var postingCommentsCount: Int {
    return Int(commentsCount)
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  
  var postingCaption: String {
    return caption ?? ""
  }
  
  var postingCategory: CategoryProtocol? {
    return nil
  }
  
  var postingUser: UserProtocol? {
    return user
  }
  
  var postingMedia: [MediaProtocol] {
    let managedMedia = media?.allObjects as? [MediaManagedObject]
    return managedMedia?.sorted { $0.sortId < $1.sortId || $0.identifier < $1.identifier } ?? []
  }
  
  var postingTags: [String] {
    return tagsString?.split(separator: " ").map { String($0) } ?? []
  }
  
  var postingCommentsPreview: [CommentProtocol] {
    return previewComments?.array as? [CommentManagedObject] ?? []
  }
  
  var postingUpVotesCount: Int {
    return Int(upVotesCount)
  }
  
  var postingPlace: LocationProtocol? {
    return location
  }
}

//Helpers
extension PostingProtocol {
  var canBePersisted: Bool {
    return postUUID.count > 0
  }
}

extension PostingProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostingManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostingManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialPostingProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostingManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostingManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PostingManagedObject {
  func triggerRefresh() {
    lastTriggeredUpdateDate = NSDate()
  }
  
  func setLocallyDeleted(_ deleted: Bool) {
    isLocallyDeletedPost = deleted
  }
  
  func setPostCaptionDraft(_ text: String) {
    captionDraft = text
  }
  
  func setBeingEditedState(_ isBeingEdited: Bool) {
    self.isBeingEdited = isBeingEdited
//    cachedMainMediaFeedViewModelsCount = Int16(evaluatePostsFeedPresenterItemsCount())
  }
  
  func addCommentDraft() {
    hasCommentDraft = true
//    cachedMainMediaFeedViewModelsCount = Int16(evaluatePostsFeedPresenterItemsCount())
  }
  
  func extendFundingItem() {
    isFundingPresentationExtended = true
//    cachedMainMediaFeedViewModelsCount = Int16(evaluatePostsFeedPresenterItemsCount())
  }
}

enum PostingsRelations: CoreDataStorableRelation {
  case mainFeed(posting: PartialPostingProtocol, sortingKeys: PostSortingKeys?)
  case discoverFeed(posting: PartialPostingProtocol)
  case discoverDetailedFeed(posting: PartialPostingProtocol, for: PostingProtocol)
  case topGroupFeed(posting: PartialPostingProtocol, groupType: TopGroupPostsType, sortingKeys: PostSortingKeys?)
  case postDraft(posting: PostingProtocol)
  case winnerPosts(posting: PartialPostingProtocol)
  
  case userActiveFundingPosts(posting: PartialPostingProtocol)
  case userEndedFundingPosts(posting: PartialPostingProtocol)
  case userBackedPosts(posting: PartialPostingProtocol)
  
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .mainFeed(let post, let sortingKeys):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.isMainFeed = true
      if let sortingKeys = sortingKeys {
        managedPosting.setValueIfNotNil(\PostingManagedObject.isRecommendedInMainFeed, value: sortingKeys.isRecommended)
        managedPosting.setValueIfNotNil(\PostingManagedObject.mainFeedCursorId, value: sortingKeys.cursorId.map { Int32($0) })
        managedPosting.setValueIfNotNil(\PostingManagedObject.mainFeedSortId, value: sortingKeys.sortId.map { Int32($0) })
        managedPosting.setValueIfNotNil(\PostingManagedObject.isPromotedPost, value: sortingKeys.isPromo)
        managedPosting.setValueIfNotNil(\PostingManagedObject.hotFeedSortId, value: sortingKeys.hotFeedSortId.map { Int32($0) })
      }
     
    case .discoverFeed(let posting):
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedPosting.isDiscoverFeed = true
    case .discoverDetailedFeed(let post, let detailForPost):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.discoverDetailFeedForPostId = Int32(detailForPost.identifier)
    case .postDraft(let posting):
      guard posting.canBePersisted else {
        return
      }
      let managedPosting = PostingManagedObject.replaceOrCreate(with: posting, in: context)
      managedPosting.isMainFeed = true
      managedPosting.isDraft = true
    case .topGroupFeed(let posting, let groupType, let sortingKeys):
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      switch groupType {
      case .news:
        managedPosting.isTopGroupNews = true
      case .coin:
        managedPosting.isTopGroupCoin = true
      case .webtoon:
        managedPosting.isTopGroupWebtoon = true
      case .newbie:
        managedPosting.isTopGroupNewbie = true
      case .funding:
        managedPosting.isTopGroupFunding = true
      case .promoted:
        managedPosting.isTopGroupPromoted = true
      case .shop:
        managedPosting.isTopGroupShop = true
      case .hot:
        managedPosting.isTopGroupHot = true
      }
      
      if let sortingKeys = sortingKeys {
        managedPosting.setValueIfNotNil(\PostingManagedObject.isRecommendedInMainFeed, value: sortingKeys.isRecommended)
        managedPosting.setValueIfNotNil(\PostingManagedObject.mainFeedCursorId, value: sortingKeys.cursorId.map { Int32($0) })
        managedPosting.setValueIfNotNil(\PostingManagedObject.mainFeedSortId, value: sortingKeys.sortId.map { Int32($0) })
        managedPosting.setValueIfNotNil(\PostingManagedObject.isPromotedPost, value: sortingKeys.isPromo)
        managedPosting.setValueIfNotNil(\PostingManagedObject.hotFeedSortId, value: sortingKeys.hotFeedSortId.map { Int32($0) })
      }
      
    case .winnerPosts(let post):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.winnerPostsFeedUserId = managedPosting.user?.id ?? -1
    case .userActiveFundingPosts(let post):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.isActiveFundingsFeed = true
    case .userEndedFundingPosts(let post):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.isEndedFundingsFeed = true
    case .userBackedPosts(let post):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.isBackedByCurrentUserFundingsFeed = true
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .mainFeed(let post, _):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.isMainFeed = false
    case .discoverFeed(let posting):
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedPosting.isDiscoverFeed = false
    case .discoverDetailedFeed(let posting, _):
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      managedPosting.discoverDetailFeedForPostId = Int32(posting.identifier)
    case .postDraft(let posting):
      let managedPosting = PostingManagedObject.replaceOrCreate(with: posting, in: context)
      managedPosting.isMainFeed = false
      managedPosting.isLocallyDeletedPost = true
    case .topGroupFeed(let posting, let groupType, _):
      let managedPosting = PostingManagedObject.updateOrCreate(with: posting, in: context)
      switch groupType {
      case .news:
        managedPosting.isTopGroupNews = false
      case .coin:
        managedPosting.isTopGroupCoin = false
      case .webtoon:
        managedPosting.isTopGroupWebtoon = false
      case .newbie:
        managedPosting.isTopGroupNewbie = false
      case .funding:
        managedPosting.isTopGroupFunding = false
      case .promoted:
        managedPosting.isTopGroupPromoted = false
      case .shop:
        managedPosting.isTopGroupShop = false
      case .hot:
        managedPosting.isTopGroupHot = false
      }
    case .winnerPosts(let post):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.winnerPostsFeedUserId = -1
    case .userActiveFundingPosts(let post):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.isActiveFundingsFeed = false
    case .userEndedFundingPosts(let post):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.isEndedFundingsFeed = false
    case .userBackedPosts(let post):
      let managedPosting = PostingManagedObject.updateOrCreate(with: post, in: context)
      managedPosting.isBackedByCurrentUserFundingsFeed = false
    }
  }
}

 
