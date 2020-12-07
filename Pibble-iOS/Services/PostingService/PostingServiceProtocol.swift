//
//  PostingServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import MapKit

protocol PostAttributesProtocol {
  var postCaption: String { get }
}

enum FundingFilterType {
  case active
  case ended
  case backed
}

enum PostDraftAttributesType {
  case media
  case charity(DraftFundingCampaignAttributesType?)
  case crowdfunding(DraftFundingCampaignAttributesType?)
  case crowdfundingWithReward(DraftFundingCampaignAttributesType?)
  case commerce(CommercePostDraftAttributesProtocol, DigitalGoodPostAttributesProtocol)
  case goods(GoodsPostDraftAttributesProtocol)
}

//MARK:- PostDraftProtocol

protocol PostDraftProtocol: PostingProtocol {
  var postDraftId: String { get }
  var postCaption: String { get }
  var type: String { get }
  var categoryId: Int { get }
  var postAttributesType: PostDraftAttributesType { get }
  var tags: [String] { get }
  var place: SearchLocationProtocol? { get }
  var media: [String] { get }
  var postUUID: String { get }
  
  var attachedMedia: [MediaType] { get }
}

protocol SearchLocationProtocol: SearchAutocompleteLocationProtocol {
  var coordinates: CLLocationCoordinate2D { get }
}

protocol SearchAutocompleteLocationProtocol {
  //  var jsonDataDict: [String: AnyCodable] { get }
  var googlePlaceId: String { get }
  var locationTitle: String { get }
  var locationDescription: String { get }
  
  
  //  var images: [String] { get }
}

//MARK:- Promotion

protocol CreatePromotionProtocol {
  var budget: Double { get }
  var currency: BalanceCurrency { get }
  var rewardTypeUpVote: Bool { get }
  var rewardTypeShare: Bool { get }
  var rewardTypeCollect: Bool { get }
  var rewardTypeTag: Bool  { get }
}

//MARK:- Funding

enum FundingCampaignDraftType {
  case createNew
  case joinExisting
}

enum DraftFundingCampaignAttributesType {
  case createNew(CampaignDraftProtocol?)
  case createNewWithRewards(CampaignDraftProtocol?, MutableFundingRewardDraftProtocol?)
  case joinExisting(FundingCampaignTeamProtocol?)
}

protocol CampaignDraftProtocol {
  var goal: Double { get }
  var title: String { get }
  var raisingFor: FundRaiseRecipient? { get }
  var category: CategoryProtocol? { get }
  var team: DraftCampaignTeamType? { get }
}

protocol FundingRewardDraftProtocol: class {
  var price: Double? { get }
  var earlyPrice: Double? { get }
  var earlyAmount: Int? { get }
  
  var discoutPrice: Double? { get }
  var discountAmount: Int? { get }
}

protocol CampaignProtocol {
  var goal: Double { get }
  var title: String { get }
  var raisingFor: FundRaiseRecipient { get }
  var category: CategoryProtocol { get }
}

protocol FundingRewardsProtocol {
  var price: Double { get }
  var earlyPrice: Double { get }
  var earlyAmount: Int { get }
  
  var discoutPrice: Double { get }
  var discountAmount: Int { get }
}

//MARK:- Commerce

enum DraftCommercePostType {
  case digitalGoodPost(DigitalGoodPostAttributesProtocol)
  case commercePost
}

protocol CommercePostDraftAttributesProtocol {
  var price: Double? { get }
  var title: String? { get }
  var rewardRate: Double { get }
}

protocol GoodsPostDraftAttributesProtocol {
  var price: Double? { get }
  var title: String? { get }
  var isNew: Bool { get }
  var url: String { get }
  var goodsDescription: String { get }
  
  var hasUserAgreedToEscrowTerms: Bool { get }
}

protocol DigitalGoodPostAttributesProtocol {
  var isCommerial: Bool { get }
  var isEditorialUseAvailable: Bool { get }
  var isRoyaltyFree: Bool { get }
  var isExclusive: Bool { get }
  var isDownloadable: Bool { get }
  
  var hasUserAgreedToTerms: Bool { get }
  var hasUserAgreedToTermsOfResponsibility: Bool { get }
}

protocol PostingServiceProtocol {
  func createPost(postDraft: PostDraftProtocol, complete: @escaping ResultCompleteHandler<PartialPostingProtocol, PibbleError>)
  
  func createTeam(_ team: DraftCampaignTeamProtocol, campaign: CampaignProtocol, fundingType: CampaignType, fundingRewards: FundingRewardsProtocol?, complete: @escaping ResultCompleteHandler<FundingCampaignTeamProtocol, PibbleError>)
  
  func checkTeamNameIsAvailable(teamName: String, complete: @escaping ResultCompleteHandler<Bool, PibbleError>)
  
  func getFundingTeams(name: String?, page: Int, perPage: Int, campaignType: CampaignType?, complete: @escaping
    ResultCompleteHandler<([FundingCampaignTeamProtocol], PaginationInfoProtocol), PibbleError>)
  
  func searchTag(_ tag: String, complete: @escaping
    ResultCompleteHandler<[TagProtocol], PibbleError>)
  
  func getMainFeedPosts(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getMainFeedPosts(cursorId: Int?, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
 
  func getDiscoverPosts(page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getDiscoverPosts(cursorId: Int?, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func fetchFavoritesPostings(page: Int, perPage: Int, complete: @escaping (Result<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>) -> ())
  
  func showPosting(postId: Int, complete: @escaping
    ResultCompleteHandler<PartialPostingProtocol, PibbleError>)
  
  func fetchCommentsFor(postId: Int, page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialCommentProtocol], PaginationInfoProtocol), PibbleError>)
  
  func createCommentFor(postId: Int, body: String, complete: @escaping
    ResultCompleteHandler<PartialCommentProtocol, PibbleError>)
  
  func upVoteComment(postId: Int, commentId: Int, amount: Int, complete: @escaping CompleteHandler)
  
  func createCommentReplyFor(postId: Int, commentId: Int, body: String, complete: @escaping ResultCompleteHandler<PartialCommentProtocol, PibbleError>)
  
  func showComment(postId: Int, commentId: Int, complete: @escaping ResultCompleteHandler<PartialCommentProtocol, PibbleError>)
 
  func createPromotionFor(postId: Int, promotionConfig: CreatePromotionProtocol, complete: @escaping ResultCompleteHandler<PromotionProtocol, PibbleError>)
  
  func upVote(postId: Int, amount: Int, complete: @escaping CompleteHandler)
  
  func donate(postId: Int, amount: Int, currency: BalanceCurrency, donatePrice: Double?, complete: @escaping CompleteHandler)
  
  func stopFundingCampaign(postId: Int, complete: @escaping CompleteHandler) 
  
  func addToFavorites(postId: Int, complete: @escaping CompleteHandler)
  
  func removeFromFavorites(postId: Int, complete: @escaping CompleteHandler)
  
  func getUpvotesFor(postId: Int, page: Int, perPage: Int, complete: @escaping  ResultCompleteHandler<([UpvoteProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getCategories(_ type: CampaignType, complete: @escaping ResultCompleteHandler<(recent: [CategoryProtocol], all: [CategoryProtocol]), PibbleError>)
  
  func createPostUUID(callbackQueue: DispatchQueue, complete: @escaping ResultCompleteHandler<String, PibbleError>)
  
  func trackSharingFor(postId: Int, complete: @escaping CompleteHandler)
  
  func removePlaceForPost(post: PostingProtocol, complete: @escaping ResultCompleteHandler<PartialPostingProtocol, PibbleError>)
  
  func changePlaceForPost(post: PostingProtocol, place: SearchLocationProtocol, complete: @escaping ResultCompleteHandler<PartialPostingProtocol, PibbleError>)
  
  func changeTagsForPost(post: PostingProtocol, tags: [String], complete: @escaping ResultCompleteHandler<PartialPostingProtocol, PibbleError>)
  
  func changeCaptionForPost(post: PostingProtocol, caption: String, complete: @escaping ResultCompleteHandler<PartialPostingProtocol, PibbleError>)
  
  func deletePost(post: PostingProtocol, complete: @escaping CompleteHandler)
  
  func deleteComment(post: PostingProtocol, comment: CommentProtocol, complete: @escaping CompleteHandler)
  
  func reportToBlockPost(_ post: PostingProtocol, complete: @escaping CompleteHandler)
  
  func reportAsInappropriatePost(_ post: PostingProtocol, reason: PostReportReasonProtocol, complete: @escaping CompleteHandler)
  
  func getPostReportReasons(complete: @escaping
    ResultCompleteHandler<([PostReportReasonProtocol]), PibbleError>)
  
  func getCurrentUserCommercePosts(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getCurrentUserPurchasedCommercePosts(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getCurrentUserFundingPostsWith(_ fundingFilterType: FundingFilterType, page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getCurrentUserPromotedPostsWithPromotionStatus(_ promotionStatus: PromotionStatus, page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialPostingProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getStatisticsFor(_ post: PostingProtocol, complete: @escaping
    ResultCompleteHandler<(EngagementStatisticsProtocol), PibbleError>)
  
  func fetchPromotedPosts(count: Int, complete: @escaping
    ResultCompleteHandler<([PartialPostingProtocol]), PibbleError>)
  
}
