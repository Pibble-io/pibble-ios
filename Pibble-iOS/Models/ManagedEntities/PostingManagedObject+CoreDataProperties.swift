//
//  PostingManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PostingManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostingManagedObject> {
        return NSFetchRequest<PostingManagedObject>(entityName: "Posting")
    }

    @NSManaged public var cachedMainMediaFeedViewModelsCount: Int32
    @NSManaged public var caption: String?
    @NSManaged public var captionDraft: String?
    @NSManaged public var commentDraft: String?
    @NSManaged public var commentsCount: Int32
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var discoverDetailFeedForPostId: Int32
    @NSManaged public var draftId: String?
    @NSManaged public var draftProgress: Float
    @NSManaged public var draftStatus: Int32
    @NSManaged public var hasActiveCollectPromotions: Bool
    @NSManaged public var hasActiveSharePromotions: Bool
    @NSManaged public var hasActiveTagPromotions: Bool
    @NSManaged public var hasActiveUpVotePromotions: Bool
    @NSManaged public var hasCommentDraft: Bool
    @NSManaged public var hotFeedSortId: Int32
    @NSManaged public var id: Int32
    @NSManaged public var isActiveFundingsFeed: Bool
    @NSManaged public var isAddedToFavorites: Bool
    @NSManaged public var isBackedByCurrentUserFundingsFeed: Bool
    @NSManaged public var isBeingEdited: Bool
    @NSManaged public var isBlocked: Bool
    @NSManaged public var isDiscoverFeed: Bool
    @NSManaged public var isDraft: Bool
    @NSManaged public var isEndedFundingsFeed: Bool
    @NSManaged public var isFundingPresentationExtended: Bool
    @NSManaged public var isLocallyDeletedPost: Bool
    @NSManaged public var isMainFeed: Bool
    @NSManaged public var isPromotedPost: Bool
    @NSManaged public var isRecommendedInMainFeed: Bool
    @NSManaged public var isTopGroupCoin: Bool
    @NSManaged public var isTopGroupFunding: Bool
    @NSManaged public var isTopGroupHot: Bool
    @NSManaged public var isTopGroupNewbie: Bool
    @NSManaged public var isTopGroupNews: Bool
    @NSManaged public var isTopGroupPromoted: Bool
    @NSManaged public var isTopGroupShop: Bool
    @NSManaged public var isTopGroupWebtoon: Bool
    @NSManaged public var lastTriggeredUpdateDate: NSDate?
    @NSManaged public var mainFeedCursorId: Int32
    @NSManaged public var mainFeedSortId: Int32
    @NSManaged public var prize: NSDecimalNumber?
    @NSManaged public var tagsString: String?
    @NSManaged public var totalPromotionsBudget: NSDecimalNumber?
    @NSManaged public var totalPromotionsSpentBudget: NSDecimalNumber?
    @NSManaged public var type: String?
    @NSManaged public var uniqueUsersView: Int32
    @NSManaged public var upVoted: Bool
    @NSManaged public var upVoteDate: NSDate?
    @NSManaged public var upVoteDateString: String?
    @NSManaged public var upVotesAmount: Int32
    @NSManaged public var upVotesAmountDraft: Int32
    @NSManaged public var upVotesCount: Int32
    @NSManaged public var userPostsFeedForUserId: Int32
    @NSManaged public var uuid: String?
    @NSManaged public var winnerPostsFeedUserId: Int32
    @NSManaged public var chatRoomsGroup: ChatRoomsGroupManagedObject?
    @NSManaged public var comments: NSSet?
    @NSManaged public var commerce: CommerceManagedObject?
    @NSManaged public var commerceTransaction: CommerceTransactionManagedObject?
    @NSManaged public var currentUserPurchaseInvoice: InvoiceManagedObject?
    @NSManaged public var fundingTransactions: NSSet?
    @NSManaged public var goods: GoodsManagedObject?
    @NSManaged public var goodsTransactions: NSSet?
    @NSManaged public var helpRequest: PostHelpRequestManagedObject?
    @NSManaged public var location: LocationManagedObject?
    @NSManaged public var media: NSSet?
    @NSManaged public var notificationMentions: NSSet?
    @NSManaged public var previewComments: NSOrderedSet?
    @NSManaged public var promotion: PromotionManagedObject?
    @NSManaged public var purchasedUsers: NSSet?
    @NSManaged public var purchaseTransactions: NSSet?
    @NSManaged public var quotedChatMessage: NSSet?
    @NSManaged public var relatedChatRooms: NSSet?
    @NSManaged public var relatedFundingCampaign: FundingCampaignManagedObject?
    @NSManaged public var relatedFundingCampaignTeam: FundingCampaignTeamManagedObject?
    @NSManaged public var relatedFundingTransactions: NSSet?
    @NSManaged public var tags: NSSet?
    @NSManaged public var upvotedUsers: NSSet?
    @NSManaged public var upvotes: NSSet?
    @NSManaged public var user: UserManagedObject?

}

// MARK: Generated accessors for comments
extension PostingManagedObject {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: CommentManagedObject)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: CommentManagedObject)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

// MARK: Generated accessors for fundingTransactions
extension PostingManagedObject {

    @objc(addFundingTransactionsObject:)
    @NSManaged public func addToFundingTransactions(_ value: FundingTransactionManagedObject)

    @objc(removeFundingTransactionsObject:)
    @NSManaged public func removeFromFundingTransactions(_ value: FundingTransactionManagedObject)

    @objc(addFundingTransactions:)
    @NSManaged public func addToFundingTransactions(_ values: NSSet)

    @objc(removeFundingTransactions:)
    @NSManaged public func removeFromFundingTransactions(_ values: NSSet)

}

// MARK: Generated accessors for goodsTransactions
extension PostingManagedObject {

    @objc(addGoodsTransactionsObject:)
    @NSManaged public func addToGoodsTransactions(_ value: GoodTransactionManagedObject)

    @objc(removeGoodsTransactionsObject:)
    @NSManaged public func removeFromGoodsTransactions(_ value: GoodTransactionManagedObject)

    @objc(addGoodsTransactions:)
    @NSManaged public func addToGoodsTransactions(_ values: NSSet)

    @objc(removeGoodsTransactions:)
    @NSManaged public func removeFromGoodsTransactions(_ values: NSSet)

}

// MARK: Generated accessors for media
extension PostingManagedObject {

    @objc(addMediaObject:)
    @NSManaged public func addToMedia(_ value: MediaManagedObject)

    @objc(removeMediaObject:)
    @NSManaged public func removeFromMedia(_ value: MediaManagedObject)

    @objc(addMedia:)
    @NSManaged public func addToMedia(_ values: NSSet)

    @objc(removeMedia:)
    @NSManaged public func removeFromMedia(_ values: NSSet)

}

// MARK: Generated accessors for notificationMentions
extension PostingManagedObject {

    @objc(addNotificationMentionsObject:)
    @NSManaged public func addToNotificationMentions(_ value: NotificationManagedObject)

    @objc(removeNotificationMentionsObject:)
    @NSManaged public func removeFromNotificationMentions(_ value: NotificationManagedObject)

    @objc(addNotificationMentions:)
    @NSManaged public func addToNotificationMentions(_ values: NSSet)

    @objc(removeNotificationMentions:)
    @NSManaged public func removeFromNotificationMentions(_ values: NSSet)

}

// MARK: Generated accessors for previewComments
extension PostingManagedObject {

    @objc(insertObject:inPreviewCommentsAtIndex:)
    @NSManaged public func insertIntoPreviewComments(_ value: CommentManagedObject, at idx: Int)

    @objc(removeObjectFromPreviewCommentsAtIndex:)
    @NSManaged public func removeFromPreviewComments(at idx: Int)

    @objc(insertPreviewComments:atIndexes:)
    @NSManaged public func insertIntoPreviewComments(_ values: [CommentManagedObject], at indexes: NSIndexSet)

    @objc(removePreviewCommentsAtIndexes:)
    @NSManaged public func removeFromPreviewComments(at indexes: NSIndexSet)

    @objc(replaceObjectInPreviewCommentsAtIndex:withObject:)
    @NSManaged public func replacePreviewComments(at idx: Int, with value: CommentManagedObject)

    @objc(replacePreviewCommentsAtIndexes:withPreviewComments:)
    @NSManaged public func replacePreviewComments(at indexes: NSIndexSet, with values: [CommentManagedObject])

    @objc(addPreviewCommentsObject:)
    @NSManaged public func addToPreviewComments(_ value: CommentManagedObject)

    @objc(removePreviewCommentsObject:)
    @NSManaged public func removeFromPreviewComments(_ value: CommentManagedObject)

    @objc(addPreviewComments:)
    @NSManaged public func addToPreviewComments(_ values: NSOrderedSet)

    @objc(removePreviewComments:)
    @NSManaged public func removeFromPreviewComments(_ values: NSOrderedSet)

}

// MARK: Generated accessors for purchasedUsers
extension PostingManagedObject {

    @objc(addPurchasedUsersObject:)
    @NSManaged public func addToPurchasedUsers(_ value: UserManagedObject)

    @objc(removePurchasedUsersObject:)
    @NSManaged public func removeFromPurchasedUsers(_ value: UserManagedObject)

    @objc(addPurchasedUsers:)
    @NSManaged public func addToPurchasedUsers(_ values: NSSet)

    @objc(removePurchasedUsers:)
    @NSManaged public func removeFromPurchasedUsers(_ values: NSSet)

}

// MARK: Generated accessors for purchaseTransactions
extension PostingManagedObject {

    @objc(addPurchaseTransactionsObject:)
    @NSManaged public func addToPurchaseTransactions(_ value: DigitalGoodTransactionManagedObject)

    @objc(removePurchaseTransactionsObject:)
    @NSManaged public func removeFromPurchaseTransactions(_ value: DigitalGoodTransactionManagedObject)

    @objc(addPurchaseTransactions:)
    @NSManaged public func addToPurchaseTransactions(_ values: NSSet)

    @objc(removePurchaseTransactions:)
    @NSManaged public func removeFromPurchaseTransactions(_ values: NSSet)

}

// MARK: Generated accessors for quotedChatMessage
extension PostingManagedObject {

    @objc(addQuotedChatMessageObject:)
    @NSManaged public func addToQuotedChatMessage(_ value: PostChatMessageManagedObject)

    @objc(removeQuotedChatMessageObject:)
    @NSManaged public func removeFromQuotedChatMessage(_ value: PostChatMessageManagedObject)

    @objc(addQuotedChatMessage:)
    @NSManaged public func addToQuotedChatMessage(_ values: NSSet)

    @objc(removeQuotedChatMessage:)
    @NSManaged public func removeFromQuotedChatMessage(_ values: NSSet)

}

// MARK: Generated accessors for relatedChatRooms
extension PostingManagedObject {

    @objc(addRelatedChatRoomsObject:)
    @NSManaged public func addToRelatedChatRooms(_ value: ChatRoomManagedObject)

    @objc(removeRelatedChatRoomsObject:)
    @NSManaged public func removeFromRelatedChatRooms(_ value: ChatRoomManagedObject)

    @objc(addRelatedChatRooms:)
    @NSManaged public func addToRelatedChatRooms(_ values: NSSet)

    @objc(removeRelatedChatRooms:)
    @NSManaged public func removeFromRelatedChatRooms(_ values: NSSet)

}

// MARK: Generated accessors for relatedFundingTransactions
extension PostingManagedObject {

    @objc(addRelatedFundingTransactionsObject:)
    @NSManaged public func addToRelatedFundingTransactions(_ value: BaseFundingTransactionManagedObject)

    @objc(removeRelatedFundingTransactionsObject:)
    @NSManaged public func removeFromRelatedFundingTransactions(_ value: BaseFundingTransactionManagedObject)

    @objc(addRelatedFundingTransactions:)
    @NSManaged public func addToRelatedFundingTransactions(_ values: NSSet)

    @objc(removeRelatedFundingTransactions:)
    @NSManaged public func removeFromRelatedFundingTransactions(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension PostingManagedObject {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagManagedObject)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagManagedObject)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for upvotedUsers
extension PostingManagedObject {

    @objc(addUpvotedUsersObject:)
    @NSManaged public func addToUpvotedUsers(_ value: UserManagedObject)

    @objc(removeUpvotedUsersObject:)
    @NSManaged public func removeFromUpvotedUsers(_ value: UserManagedObject)

    @objc(addUpvotedUsers:)
    @NSManaged public func addToUpvotedUsers(_ values: NSSet)

    @objc(removeUpvotedUsers:)
    @NSManaged public func removeFromUpvotedUsers(_ values: NSSet)

}

// MARK: Generated accessors for upvotes
extension PostingManagedObject {

    @objc(addUpvotesObject:)
    @NSManaged public func addToUpvotes(_ value: UpvoteManagedObject)

    @objc(removeUpvotesObject:)
    @NSManaged public func removeFromUpvotes(_ value: UpvoteManagedObject)

    @objc(addUpvotes:)
    @NSManaged public func addToUpvotes(_ values: NSSet)

    @objc(removeUpvotes:)
    @NSManaged public func removeFromUpvotes(_ values: NSSet)

}
