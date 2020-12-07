//
//  UserManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 07/10/2019.
//
//

import Foundation
import CoreData


extension UserManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserManagedObject> {
        return NSFetchRequest<UserManagedObject>(entityName: "User")
    }

    @NSManaged public var availablePoints: Int32
    @NSManaged public var avatar: String?
    @NSManaged public var btcBalance: NSDecimalNumber?
    @NSManaged public var earnedRewards: NSDecimalNumber?
    @NSManaged public var ethBalance: NSDecimalNumber?
    @NSManaged public var followersCount: Int32
    @NSManaged public var followingsCount: Int32
    @NSManaged public var friendsCount: Int32
    @NSManaged public var greenBrushBalance: NSDecimalNumber?
    @NSManaged public var id: Int32
    @NSManaged public var isBanned: Bool
    @NSManaged public var isFollowedByMe: Bool
    @NSManaged public var isFollowingMe: Bool
    @NSManaged public var isFriend: Bool
    @NSManaged public var isFriendshipDenied: Bool
    @NSManaged public var isInboundFriendRequested: Bool
    @NSManaged public var isMe: Bool
    @NSManaged public var isMuted: Bool
    @NSManaged public var isOutboundFriendRequested: Bool
    @NSManaged public var klaytnBalance: NSDecimalNumber?
    @NSManaged public var level: Int32
    @NSManaged public var name: String?
    @NSManaged public var necessaryPoints: Int32
    @NSManaged public var pibBalance: NSDecimalNumber?
    @NSManaged public var pibKlaytnBalance: NSDecimalNumber?
    @NSManaged public var postsCount: Int32
    @NSManaged public var prizeWon: NSDecimalNumber?
    @NSManaged public var profileDescription: String?
    @NSManaged public var profileFirstName: String?
    @NSManaged public var profileLastName: String?
    @NSManaged public var profileSiteAddress: String?
    @NSManaged public var redBrushBalance: NSDecimalNumber?
    @NSManaged public var rewardsLimit: NSDecimalNumber?
    @NSManaged public var uuid: String?
    @NSManaged public var wallCover: String?
    @NSManaged public var email: String?
    @NSManaged public var airdropTransactions: NSSet?
    @NSManaged public var chatRooms: NSSet?
    @NSManaged public var chatRoomsGroups: NSSet?
    @NSManaged public var comments: NSSet?
    @NSManaged public var feedNotifications: NSSet?
    @NSManaged public var followedBy: NSSet?
    @NSManaged public var followedTags: NSSet?
    @NSManaged public var follows: NSSet?
    @NSManaged public var friends: NSSet?
    @NSManaged public var fundingCampaignTeams: NSSet?
    @NSManaged public var incomingDigitalGoodTransactions: NSSet?
    @NSManaged public var incomingGoodTransactions: NSSet?
    @NSManaged public var incomingInternalTransactions: NSSet?
    @NSManaged public var incomingInvoices: NSSet?
    @NSManaged public var incomingNotifications: NSSet?
    @NSManaged public var incomingPromotionTransactions: NSSet?
    @NSManaged public var incomingRewards: NSSet?
    @NSManaged public var leaderboardEntries: NSSet?
    @NSManaged public var mediaPostings: NSSet?
    @NSManaged public var mutedByUsers: NSSet?
    @NSManaged public var mutedUsers: NSSet?
    @NSManaged public var notificationMentions: NSSet?
    @NSManaged public var outcomingCommerceTransactions: NSSet?
    @NSManaged public var outcomingDigitalGoodTransactions: NSSet?
    @NSManaged public var outcomingDonateTransactions: NSSet?
    @NSManaged public var outcomingFundingTransactions: NSSet?
    @NSManaged public var outcomingGoodTransactions: NSSet?
    @NSManaged public var outcomingInternalTransactions: NSSet?
    @NSManaged public var outcomingInvoices: NSSet?
    @NSManaged public var outcomingMessages: NSSet?
    @NSManaged public var outcomingNotifications: NSSet?
    @NSManaged public var outcomingPromotionTransactions: NSSet?
    @NSManaged public var outcomingRewards: NSSet?
    @NSManaged public var outcomingUpvotes: NSSet?
    @NSManaged public var postHelpAnswers: NSSet?
    @NSManaged public var postHelpRequests: NSSet?
    @NSManaged public var purchasedCommercePosts: NSSet?
    @NSManaged public var receivedFundsRecently: NSSet?
    @NSManaged public var referralOwnerUser: UserManagedObject?
    @NSManaged public var registeredReferralUsers: NSSet?
    @NSManaged public var searchResults: NSSet?
    @NSManaged public var sentFundsRecently: NSSet?
    @NSManaged public var upvotedPostings: NSSet?
    @NSManaged public var walletActivities: NSSet?
    @NSManaged public var wallets: NSSet?

}

// MARK: Generated accessors for airdropTransactions
extension UserManagedObject {

    @objc(addAirdropTransactionsObject:)
    @NSManaged public func addToAirdropTransactions(_ value: AirdropTransactionManagedObject)

    @objc(removeAirdropTransactionsObject:)
    @NSManaged public func removeFromAirdropTransactions(_ value: AirdropTransactionManagedObject)

    @objc(addAirdropTransactions:)
    @NSManaged public func addToAirdropTransactions(_ values: NSSet)

    @objc(removeAirdropTransactions:)
    @NSManaged public func removeFromAirdropTransactions(_ values: NSSet)

}

// MARK: Generated accessors for chatRooms
extension UserManagedObject {

    @objc(addChatRoomsObject:)
    @NSManaged public func addToChatRooms(_ value: ChatRoomMemberManagedObject)

    @objc(removeChatRoomsObject:)
    @NSManaged public func removeFromChatRooms(_ value: ChatRoomMemberManagedObject)

    @objc(addChatRooms:)
    @NSManaged public func addToChatRooms(_ values: NSSet)

    @objc(removeChatRooms:)
    @NSManaged public func removeFromChatRooms(_ values: NSSet)

}

// MARK: Generated accessors for chatRoomsGroups
extension UserManagedObject {

    @objc(addChatRoomsGroupsObject:)
    @NSManaged public func addToChatRoomsGroups(_ value: ChatRoomsGroupManagedObject)

    @objc(removeChatRoomsGroupsObject:)
    @NSManaged public func removeFromChatRoomsGroups(_ value: ChatRoomsGroupManagedObject)

    @objc(addChatRoomsGroups:)
    @NSManaged public func addToChatRoomsGroups(_ values: NSSet)

    @objc(removeChatRoomsGroups:)
    @NSManaged public func removeFromChatRoomsGroups(_ values: NSSet)

}

// MARK: Generated accessors for comments
extension UserManagedObject {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: CommentManagedObject)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: CommentManagedObject)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

// MARK: Generated accessors for feedNotifications
extension UserManagedObject {

    @objc(addFeedNotificationsObject:)
    @NSManaged public func addToFeedNotifications(_ value: NotificationManagedObject)

    @objc(removeFeedNotificationsObject:)
    @NSManaged public func removeFromFeedNotifications(_ value: NotificationManagedObject)

    @objc(addFeedNotifications:)
    @NSManaged public func addToFeedNotifications(_ values: NSSet)

    @objc(removeFeedNotifications:)
    @NSManaged public func removeFromFeedNotifications(_ values: NSSet)

}

// MARK: Generated accessors for followedBy
extension UserManagedObject {

    @objc(addFollowedByObject:)
    @NSManaged public func addToFollowedBy(_ value: UserManagedObject)

    @objc(removeFollowedByObject:)
    @NSManaged public func removeFromFollowedBy(_ value: UserManagedObject)

    @objc(addFollowedBy:)
    @NSManaged public func addToFollowedBy(_ values: NSSet)

    @objc(removeFollowedBy:)
    @NSManaged public func removeFromFollowedBy(_ values: NSSet)

}

// MARK: Generated accessors for followedTags
extension UserManagedObject {

    @objc(addFollowedTagsObject:)
    @NSManaged public func addToFollowedTags(_ value: TagManagedObject)

    @objc(removeFollowedTagsObject:)
    @NSManaged public func removeFromFollowedTags(_ value: TagManagedObject)

    @objc(addFollowedTags:)
    @NSManaged public func addToFollowedTags(_ values: NSSet)

    @objc(removeFollowedTags:)
    @NSManaged public func removeFromFollowedTags(_ values: NSSet)

}

// MARK: Generated accessors for follows
extension UserManagedObject {

    @objc(addFollowsObject:)
    @NSManaged public func addToFollows(_ value: UserManagedObject)

    @objc(removeFollowsObject:)
    @NSManaged public func removeFromFollows(_ value: UserManagedObject)

    @objc(addFollows:)
    @NSManaged public func addToFollows(_ values: NSSet)

    @objc(removeFollows:)
    @NSManaged public func removeFromFollows(_ values: NSSet)

}

// MARK: Generated accessors for friends
extension UserManagedObject {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: UserManagedObject)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: UserManagedObject)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

// MARK: Generated accessors for fundingCampaignTeams
extension UserManagedObject {

    @objc(addFundingCampaignTeamsObject:)
    @NSManaged public func addToFundingCampaignTeams(_ value: FundingCampaignTeamManagedObject)

    @objc(removeFundingCampaignTeamsObject:)
    @NSManaged public func removeFromFundingCampaignTeams(_ value: FundingCampaignTeamManagedObject)

    @objc(addFundingCampaignTeams:)
    @NSManaged public func addToFundingCampaignTeams(_ values: NSSet)

    @objc(removeFundingCampaignTeams:)
    @NSManaged public func removeFromFundingCampaignTeams(_ values: NSSet)

}

// MARK: Generated accessors for incomingDigitalGoodTransactions
extension UserManagedObject {

    @objc(addIncomingDigitalGoodTransactionsObject:)
    @NSManaged public func addToIncomingDigitalGoodTransactions(_ value: DigitalGoodTransactionManagedObject)

    @objc(removeIncomingDigitalGoodTransactionsObject:)
    @NSManaged public func removeFromIncomingDigitalGoodTransactions(_ value: DigitalGoodTransactionManagedObject)

    @objc(addIncomingDigitalGoodTransactions:)
    @NSManaged public func addToIncomingDigitalGoodTransactions(_ values: NSSet)

    @objc(removeIncomingDigitalGoodTransactions:)
    @NSManaged public func removeFromIncomingDigitalGoodTransactions(_ values: NSSet)

}

// MARK: Generated accessors for incomingGoodTransactions
extension UserManagedObject {

    @objc(addIncomingGoodTransactionsObject:)
    @NSManaged public func addToIncomingGoodTransactions(_ value: GoodTransactionManagedObject)

    @objc(removeIncomingGoodTransactionsObject:)
    @NSManaged public func removeFromIncomingGoodTransactions(_ value: GoodTransactionManagedObject)

    @objc(addIncomingGoodTransactions:)
    @NSManaged public func addToIncomingGoodTransactions(_ values: NSSet)

    @objc(removeIncomingGoodTransactions:)
    @NSManaged public func removeFromIncomingGoodTransactions(_ values: NSSet)

}

// MARK: Generated accessors for incomingInternalTransactions
extension UserManagedObject {

    @objc(addIncomingInternalTransactionsObject:)
    @NSManaged public func addToIncomingInternalTransactions(_ value: BaseInternalTransactionManagedObject)

    @objc(removeIncomingInternalTransactionsObject:)
    @NSManaged public func removeFromIncomingInternalTransactions(_ value: BaseInternalTransactionManagedObject)

    @objc(addIncomingInternalTransactions:)
    @NSManaged public func addToIncomingInternalTransactions(_ values: NSSet)

    @objc(removeIncomingInternalTransactions:)
    @NSManaged public func removeFromIncomingInternalTransactions(_ values: NSSet)

}

// MARK: Generated accessors for incomingInvoices
extension UserManagedObject {

    @objc(addIncomingInvoicesObject:)
    @NSManaged public func addToIncomingInvoices(_ value: InvoiceManagedObject)

    @objc(removeIncomingInvoicesObject:)
    @NSManaged public func removeFromIncomingInvoices(_ value: InvoiceManagedObject)

    @objc(addIncomingInvoices:)
    @NSManaged public func addToIncomingInvoices(_ values: NSSet)

    @objc(removeIncomingInvoices:)
    @NSManaged public func removeFromIncomingInvoices(_ values: NSSet)

}

// MARK: Generated accessors for incomingNotifications
extension UserManagedObject {

    @objc(addIncomingNotificationsObject:)
    @NSManaged public func addToIncomingNotifications(_ value: NotificationManagedObject)

    @objc(removeIncomingNotificationsObject:)
    @NSManaged public func removeFromIncomingNotifications(_ value: NotificationManagedObject)

    @objc(addIncomingNotifications:)
    @NSManaged public func addToIncomingNotifications(_ values: NSSet)

    @objc(removeIncomingNotifications:)
    @NSManaged public func removeFromIncomingNotifications(_ values: NSSet)

}

// MARK: Generated accessors for incomingPromotionTransactions
extension UserManagedObject {

    @objc(addIncomingPromotionTransactionsObject:)
    @NSManaged public func addToIncomingPromotionTransactions(_ value: PromotionTransactionManagedObject)

    @objc(removeIncomingPromotionTransactionsObject:)
    @NSManaged public func removeFromIncomingPromotionTransactions(_ value: PromotionTransactionManagedObject)

    @objc(addIncomingPromotionTransactions:)
    @NSManaged public func addToIncomingPromotionTransactions(_ values: NSSet)

    @objc(removeIncomingPromotionTransactions:)
    @NSManaged public func removeFromIncomingPromotionTransactions(_ values: NSSet)

}

// MARK: Generated accessors for incomingRewards
extension UserManagedObject {

    @objc(addIncomingRewardsObject:)
    @NSManaged public func addToIncomingRewards(_ value: RewardTransactionManagedObject)

    @objc(removeIncomingRewardsObject:)
    @NSManaged public func removeFromIncomingRewards(_ value: RewardTransactionManagedObject)

    @objc(addIncomingRewards:)
    @NSManaged public func addToIncomingRewards(_ values: NSSet)

    @objc(removeIncomingRewards:)
    @NSManaged public func removeFromIncomingRewards(_ values: NSSet)

}

// MARK: Generated accessors for leaderboardEntries
extension UserManagedObject {

    @objc(addLeaderboardEntriesObject:)
    @NSManaged public func addToLeaderboardEntries(_ value: LeaderboardEntryManagedObject)

    @objc(removeLeaderboardEntriesObject:)
    @NSManaged public func removeFromLeaderboardEntries(_ value: LeaderboardEntryManagedObject)

    @objc(addLeaderboardEntries:)
    @NSManaged public func addToLeaderboardEntries(_ values: NSSet)

    @objc(removeLeaderboardEntries:)
    @NSManaged public func removeFromLeaderboardEntries(_ values: NSSet)

}

// MARK: Generated accessors for mediaPostings
extension UserManagedObject {

    @objc(addMediaPostingsObject:)
    @NSManaged public func addToMediaPostings(_ value: PostingManagedObject)

    @objc(removeMediaPostingsObject:)
    @NSManaged public func removeFromMediaPostings(_ value: PostingManagedObject)

    @objc(addMediaPostings:)
    @NSManaged public func addToMediaPostings(_ values: NSSet)

    @objc(removeMediaPostings:)
    @NSManaged public func removeFromMediaPostings(_ values: NSSet)

}

// MARK: Generated accessors for mutedByUsers
extension UserManagedObject {

    @objc(addMutedByUsersObject:)
    @NSManaged public func addToMutedByUsers(_ value: UserManagedObject)

    @objc(removeMutedByUsersObject:)
    @NSManaged public func removeFromMutedByUsers(_ value: UserManagedObject)

    @objc(addMutedByUsers:)
    @NSManaged public func addToMutedByUsers(_ values: NSSet)

    @objc(removeMutedByUsers:)
    @NSManaged public func removeFromMutedByUsers(_ values: NSSet)

}

// MARK: Generated accessors for mutedUsers
extension UserManagedObject {

    @objc(addMutedUsersObject:)
    @NSManaged public func addToMutedUsers(_ value: UserManagedObject)

    @objc(removeMutedUsersObject:)
    @NSManaged public func removeFromMutedUsers(_ value: UserManagedObject)

    @objc(addMutedUsers:)
    @NSManaged public func addToMutedUsers(_ values: NSSet)

    @objc(removeMutedUsers:)
    @NSManaged public func removeFromMutedUsers(_ values: NSSet)

}

// MARK: Generated accessors for notificationMentions
extension UserManagedObject {

    @objc(addNotificationMentionsObject:)
    @NSManaged public func addToNotificationMentions(_ value: NotificationManagedObject)

    @objc(removeNotificationMentionsObject:)
    @NSManaged public func removeFromNotificationMentions(_ value: NotificationManagedObject)

    @objc(addNotificationMentions:)
    @NSManaged public func addToNotificationMentions(_ values: NSSet)

    @objc(removeNotificationMentions:)
    @NSManaged public func removeFromNotificationMentions(_ values: NSSet)

}

// MARK: Generated accessors for outcomingCommerceTransactions
extension UserManagedObject {

    @objc(addOutcomingCommerceTransactionsObject:)
    @NSManaged public func addToOutcomingCommerceTransactions(_ value: CommerceTransactionManagedObject)

    @objc(removeOutcomingCommerceTransactionsObject:)
    @NSManaged public func removeFromOutcomingCommerceTransactions(_ value: CommerceTransactionManagedObject)

    @objc(addOutcomingCommerceTransactions:)
    @NSManaged public func addToOutcomingCommerceTransactions(_ values: NSSet)

    @objc(removeOutcomingCommerceTransactions:)
    @NSManaged public func removeFromOutcomingCommerceTransactions(_ values: NSSet)

}

// MARK: Generated accessors for outcomingDigitalGoodTransactions
extension UserManagedObject {

    @objc(addOutcomingDigitalGoodTransactionsObject:)
    @NSManaged public func addToOutcomingDigitalGoodTransactions(_ value: DigitalGoodTransactionManagedObject)

    @objc(removeOutcomingDigitalGoodTransactionsObject:)
    @NSManaged public func removeFromOutcomingDigitalGoodTransactions(_ value: DigitalGoodTransactionManagedObject)

    @objc(addOutcomingDigitalGoodTransactions:)
    @NSManaged public func addToOutcomingDigitalGoodTransactions(_ values: NSSet)

    @objc(removeOutcomingDigitalGoodTransactions:)
    @NSManaged public func removeFromOutcomingDigitalGoodTransactions(_ values: NSSet)

}

// MARK: Generated accessors for outcomingDonateTransactions
extension UserManagedObject {

    @objc(addOutcomingDonateTransactionsObject:)
    @NSManaged public func addToOutcomingDonateTransactions(_ value: BaseFundingDonateTransactionManagedObject)

    @objc(removeOutcomingDonateTransactionsObject:)
    @NSManaged public func removeFromOutcomingDonateTransactions(_ value: BaseFundingDonateTransactionManagedObject)

    @objc(addOutcomingDonateTransactions:)
    @NSManaged public func addToOutcomingDonateTransactions(_ values: NSSet)

    @objc(removeOutcomingDonateTransactions:)
    @NSManaged public func removeFromOutcomingDonateTransactions(_ values: NSSet)

}

// MARK: Generated accessors for outcomingFundingTransactions
extension UserManagedObject {

    @objc(addOutcomingFundingTransactionsObject:)
    @NSManaged public func addToOutcomingFundingTransactions(_ value: FundingTransactionManagedObject)

    @objc(removeOutcomingFundingTransactionsObject:)
    @NSManaged public func removeFromOutcomingFundingTransactions(_ value: FundingTransactionManagedObject)

    @objc(addOutcomingFundingTransactions:)
    @NSManaged public func addToOutcomingFundingTransactions(_ values: NSSet)

    @objc(removeOutcomingFundingTransactions:)
    @NSManaged public func removeFromOutcomingFundingTransactions(_ values: NSSet)

}

// MARK: Generated accessors for outcomingGoodTransactions
extension UserManagedObject {

    @objc(addOutcomingGoodTransactionsObject:)
    @NSManaged public func addToOutcomingGoodTransactions(_ value: GoodTransactionManagedObject)

    @objc(removeOutcomingGoodTransactionsObject:)
    @NSManaged public func removeFromOutcomingGoodTransactions(_ value: GoodTransactionManagedObject)

    @objc(addOutcomingGoodTransactions:)
    @NSManaged public func addToOutcomingGoodTransactions(_ values: NSSet)

    @objc(removeOutcomingGoodTransactions:)
    @NSManaged public func removeFromOutcomingGoodTransactions(_ values: NSSet)

}

// MARK: Generated accessors for outcomingInternalTransactions
extension UserManagedObject {

    @objc(addOutcomingInternalTransactionsObject:)
    @NSManaged public func addToOutcomingInternalTransactions(_ value: BaseInternalTransactionManagedObject)

    @objc(removeOutcomingInternalTransactionsObject:)
    @NSManaged public func removeFromOutcomingInternalTransactions(_ value: BaseInternalTransactionManagedObject)

    @objc(addOutcomingInternalTransactions:)
    @NSManaged public func addToOutcomingInternalTransactions(_ values: NSSet)

    @objc(removeOutcomingInternalTransactions:)
    @NSManaged public func removeFromOutcomingInternalTransactions(_ values: NSSet)

}

// MARK: Generated accessors for outcomingInvoices
extension UserManagedObject {

    @objc(addOutcomingInvoicesObject:)
    @NSManaged public func addToOutcomingInvoices(_ value: InvoiceManagedObject)

    @objc(removeOutcomingInvoicesObject:)
    @NSManaged public func removeFromOutcomingInvoices(_ value: InvoiceManagedObject)

    @objc(addOutcomingInvoices:)
    @NSManaged public func addToOutcomingInvoices(_ values: NSSet)

    @objc(removeOutcomingInvoices:)
    @NSManaged public func removeFromOutcomingInvoices(_ values: NSSet)

}

// MARK: Generated accessors for outcomingMessages
extension UserManagedObject {

    @objc(addOutcomingMessagesObject:)
    @NSManaged public func addToOutcomingMessages(_ value: BaseChatMessageManagedObject)

    @objc(removeOutcomingMessagesObject:)
    @NSManaged public func removeFromOutcomingMessages(_ value: BaseChatMessageManagedObject)

    @objc(addOutcomingMessages:)
    @NSManaged public func addToOutcomingMessages(_ values: NSSet)

    @objc(removeOutcomingMessages:)
    @NSManaged public func removeFromOutcomingMessages(_ values: NSSet)

}

// MARK: Generated accessors for outcomingNotifications
extension UserManagedObject {

    @objc(addOutcomingNotificationsObject:)
    @NSManaged public func addToOutcomingNotifications(_ value: NotificationManagedObject)

    @objc(removeOutcomingNotificationsObject:)
    @NSManaged public func removeFromOutcomingNotifications(_ value: NotificationManagedObject)

    @objc(addOutcomingNotifications:)
    @NSManaged public func addToOutcomingNotifications(_ values: NSSet)

    @objc(removeOutcomingNotifications:)
    @NSManaged public func removeFromOutcomingNotifications(_ values: NSSet)

}

// MARK: Generated accessors for outcomingPromotionTransactions
extension UserManagedObject {

    @objc(addOutcomingPromotionTransactionsObject:)
    @NSManaged public func addToOutcomingPromotionTransactions(_ value: PromotionTransactionManagedObject)

    @objc(removeOutcomingPromotionTransactionsObject:)
    @NSManaged public func removeFromOutcomingPromotionTransactions(_ value: PromotionTransactionManagedObject)

    @objc(addOutcomingPromotionTransactions:)
    @NSManaged public func addToOutcomingPromotionTransactions(_ values: NSSet)

    @objc(removeOutcomingPromotionTransactions:)
    @NSManaged public func removeFromOutcomingPromotionTransactions(_ values: NSSet)

}

// MARK: Generated accessors for outcomingRewards
extension UserManagedObject {

    @objc(addOutcomingRewardsObject:)
    @NSManaged public func addToOutcomingRewards(_ value: RewardTransactionManagedObject)

    @objc(removeOutcomingRewardsObject:)
    @NSManaged public func removeFromOutcomingRewards(_ value: RewardTransactionManagedObject)

    @objc(addOutcomingRewards:)
    @NSManaged public func addToOutcomingRewards(_ values: NSSet)

    @objc(removeOutcomingRewards:)
    @NSManaged public func removeFromOutcomingRewards(_ values: NSSet)

}

// MARK: Generated accessors for outcomingUpvotes
extension UserManagedObject {

    @objc(addOutcomingUpvotesObject:)
    @NSManaged public func addToOutcomingUpvotes(_ value: UpvoteManagedObject)

    @objc(removeOutcomingUpvotesObject:)
    @NSManaged public func removeFromOutcomingUpvotes(_ value: UpvoteManagedObject)

    @objc(addOutcomingUpvotes:)
    @NSManaged public func addToOutcomingUpvotes(_ values: NSSet)

    @objc(removeOutcomingUpvotes:)
    @NSManaged public func removeFromOutcomingUpvotes(_ values: NSSet)

}

// MARK: Generated accessors for postHelpAnswers
extension UserManagedObject {

    @objc(addPostHelpAnswersObject:)
    @NSManaged public func addToPostHelpAnswers(_ value: PostHelpAnswerManagedObject)

    @objc(removePostHelpAnswersObject:)
    @NSManaged public func removeFromPostHelpAnswers(_ value: PostHelpAnswerManagedObject)

    @objc(addPostHelpAnswers:)
    @NSManaged public func addToPostHelpAnswers(_ values: NSSet)

    @objc(removePostHelpAnswers:)
    @NSManaged public func removeFromPostHelpAnswers(_ values: NSSet)

}

// MARK: Generated accessors for postHelpRequests
extension UserManagedObject {

    @objc(addPostHelpRequestsObject:)
    @NSManaged public func addToPostHelpRequests(_ value: PostHelpRequestManagedObject)

    @objc(removePostHelpRequestsObject:)
    @NSManaged public func removeFromPostHelpRequests(_ value: PostHelpRequestManagedObject)

    @objc(addPostHelpRequests:)
    @NSManaged public func addToPostHelpRequests(_ values: NSSet)

    @objc(removePostHelpRequests:)
    @NSManaged public func removeFromPostHelpRequests(_ values: NSSet)

}

// MARK: Generated accessors for purchasedCommercePosts
extension UserManagedObject {

    @objc(addPurchasedCommercePostsObject:)
    @NSManaged public func addToPurchasedCommercePosts(_ value: PostingManagedObject)

    @objc(removePurchasedCommercePostsObject:)
    @NSManaged public func removeFromPurchasedCommercePosts(_ value: PostingManagedObject)

    @objc(addPurchasedCommercePosts:)
    @NSManaged public func addToPurchasedCommercePosts(_ values: NSSet)

    @objc(removePurchasedCommercePosts:)
    @NSManaged public func removeFromPurchasedCommercePosts(_ values: NSSet)

}

// MARK: Generated accessors for receivedFundsRecently
extension UserManagedObject {

    @objc(addReceivedFundsRecentlyObject:)
    @NSManaged public func addToReceivedFundsRecently(_ value: UserManagedObject)

    @objc(removeReceivedFundsRecentlyObject:)
    @NSManaged public func removeFromReceivedFundsRecently(_ value: UserManagedObject)

    @objc(addReceivedFundsRecently:)
    @NSManaged public func addToReceivedFundsRecently(_ values: NSSet)

    @objc(removeReceivedFundsRecently:)
    @NSManaged public func removeFromReceivedFundsRecently(_ values: NSSet)

}

// MARK: Generated accessors for registeredReferralUsers
extension UserManagedObject {

    @objc(addRegisteredReferralUsersObject:)
    @NSManaged public func addToRegisteredReferralUsers(_ value: UserManagedObject)

    @objc(removeRegisteredReferralUsersObject:)
    @NSManaged public func removeFromRegisteredReferralUsers(_ value: UserManagedObject)

    @objc(addRegisteredReferralUsers:)
    @NSManaged public func addToRegisteredReferralUsers(_ values: NSSet)

    @objc(removeRegisteredReferralUsers:)
    @NSManaged public func removeFromRegisteredReferralUsers(_ values: NSSet)

}

// MARK: Generated accessors for searchResults
extension UserManagedObject {

    @objc(addSearchResultsObject:)
    @NSManaged public func addToSearchResults(_ value: UserSearchResultManagedObject)

    @objc(removeSearchResultsObject:)
    @NSManaged public func removeFromSearchResults(_ value: UserSearchResultManagedObject)

    @objc(addSearchResults:)
    @NSManaged public func addToSearchResults(_ values: NSSet)

    @objc(removeSearchResults:)
    @NSManaged public func removeFromSearchResults(_ values: NSSet)

}

// MARK: Generated accessors for sentFundsRecently
extension UserManagedObject {

    @objc(addSentFundsRecentlyObject:)
    @NSManaged public func addToSentFundsRecently(_ value: UserManagedObject)

    @objc(removeSentFundsRecentlyObject:)
    @NSManaged public func removeFromSentFundsRecently(_ value: UserManagedObject)

    @objc(addSentFundsRecently:)
    @NSManaged public func addToSentFundsRecently(_ values: NSSet)

    @objc(removeSentFundsRecently:)
    @NSManaged public func removeFromSentFundsRecently(_ values: NSSet)

}

// MARK: Generated accessors for upvotedPostings
extension UserManagedObject {

    @objc(addUpvotedPostingsObject:)
    @NSManaged public func addToUpvotedPostings(_ value: PostingManagedObject)

    @objc(removeUpvotedPostingsObject:)
    @NSManaged public func removeFromUpvotedPostings(_ value: PostingManagedObject)

    @objc(addUpvotedPostings:)
    @NSManaged public func addToUpvotedPostings(_ values: NSSet)

    @objc(removeUpvotedPostings:)
    @NSManaged public func removeFromUpvotedPostings(_ values: NSSet)

}

// MARK: Generated accessors for walletActivities
extension UserManagedObject {

    @objc(addWalletActivitiesObject:)
    @NSManaged public func addToWalletActivities(_ value: WalletActivityManagedObject)

    @objc(removeWalletActivitiesObject:)
    @NSManaged public func removeFromWalletActivities(_ value: WalletActivityManagedObject)

    @objc(addWalletActivities:)
    @NSManaged public func addToWalletActivities(_ values: NSSet)

    @objc(removeWalletActivities:)
    @NSManaged public func removeFromWalletActivities(_ values: NSSet)

}

// MARK: Generated accessors for wallets
extension UserManagedObject {

    @objc(addWalletsObject:)
    @NSManaged public func addToWallets(_ value: WalletManagedObject)

    @objc(removeWalletsObject:)
    @NSManaged public func removeFromWallets(_ value: WalletManagedObject)

    @objc(addWallets:)
    @NSManaged public func addToWallets(_ values: NSSet)

    @objc(removeWallets:)
    @NSManaged public func removeFromWallets(_ values: NSSet)

}
