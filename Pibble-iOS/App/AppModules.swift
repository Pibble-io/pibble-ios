//
//  AppModules.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 14.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

//MARK: - Application modules

enum AppModules {
  static let servicesContainer: ServiceContainerProtocol = ServicesContainer.shared
  
  enum Posts {
    case postsFeed(PostsFeed.FeedType)
    case comments(PostingProtocol)
    case upVote(UpVoteDelegateProtocol, UpVote.UpvotePurpose)
    case upvotedUsers(PostingProtocol, UpvotePickDelegateProtocol)
    case donate(DonateDelegateProtocol, [BalanceCurrency], Donate.AmountPickType)
    
    case commercialPostDetail(CommercialPostDetail.CommercialPostType, CommercialPostDetailDelegateProtocol)
    case fundingPostDetail(PostingProtocol, FundingPostDetail.PresentationType, FundingDetailDelegateProtocol)
    
    case fundingPostsContainer(AccountProfileProtocol)
    
    case reportPost(ReportPostDelegateProtocol)
    case mediaDetail(PostingProtocol, MediaProtocol)
    
    case leaderboardContainer
    case leaderboardContent(LeaderboardType)
    
    case topBannerInfo
  }
  
  enum Gifts {
    case giftsFeed(GiftsFeed.ContentType)
    case giftsInvite
  }
  
  enum Messenger {
    case chat(Chat.RoomType)
    case chatRooms(ChatRooms.ContentType)
    
    case chatRoomGroupsContent
    case chatRoomsContainer
  }
  
  enum Discover {
    case discoverFeedRootContainer
    case discoverSearchContent(DiscoverSearchContent.ContentType, DiscoverSearchContentDelegate)
    case searchResultDetailContainer(SearchResultDetailContainer.ContentType)
    case searchResultTagDetailContent(TagProtocol)
    case searchResultPlaceMap(LocationProtocol) 
  }
  
  enum UserProfile {
    case userProfileContent(UserProfileContent.TargetUser)
    case userProfileContainer(UserProfileContent.TargetUser)
    case bannedUserProfileContent(UserProtocol)
    case usersListing(UsersListing.ContentType)
    case userDescriptionPicker(UserProfilePickDelegateProtocol)
    case tagsListing(TagsListing.FilterType)
    case playRoom(PlayRoom.PlayRoomType)
  }
  
  enum CreatePost {
    case mediaAlbumPick(MediaAlbumPickDelegateProtocol)
    case mediaPick(MediaPickDelegateProtocol, MediaPick.Config)
    case cameraCapture
    case mediaSource(MutablePostDraftProtocol)
    case mediaEdit(MediaType, MediaEditDelegateProtocol)
    case mediaPosting(MutablePostDraftProtocol)
    
    case tagPick(TagPickDelegateProtocol)
    case locationPick(LocationPickDelegateProtocol)
    case descriptionPick(DescriptionPickDelegateProtocol)
    case promotionPick(PromotionPickDelegateProtocol)
    case campaignEdit(MutablePostDraftProtocol, CampaignType)
    case campaignPick(MutablePostDraftProtocol, CampaignType)
  }
  
  enum Promotion {
    case promotionDestinationPick(PostingProtocol)
    case promotionUrlDestinationPick(PromotionUrlDestinationPickDelegateProtocol)
    case promotionBudgetPick(PromotionDraft)
    case createPromotionConfirm(PromotionDraft)
    case promotedPostsContainer(AccountProfileProtocol)
    case promotionInsights(PostPromotionProtocol)
    case postStatistics(PostingProtocol)
  }
  
  enum PostHelp {
    case createPostHelp(CreatePostHelpDelegateProtocol)
    case postHelpAnswers(PostHelpRequestProtocol)
    case postHelpRewardPick(PostHelpRewardPickDelegateProtocol)
  }
  
  enum TabBarTest {
    case testOne
    case testTwo
    case testThree
    case testFour
  }
  
  enum Main {
    case tabBar
  }
  
  enum Auth {
    case registration
    case phonePick
    case verifyCode(VerifyCode.Purpose)
    case signIn
    case restorePasswordMethod(RestorePasswordMethod.Purpose)
    case resetPasswordWithEmail
    case resetPasswordEmailSent(ResetPasswordEmailProtocol)
    case resetPasswordPhonePick
    case resetPasswordVerifyCode(ResetPasswordVerifyCode.Purpose)
    case resetPassword(String)
    case resetPasswordSuccess
    case welcomeScreen
    case onboarding
  }
  
  enum Wallet {
    case walletHome
    case walletActivity
    case walletActivityContent(WalletActivityContent.ContentType)
    case walletPayBill
    case walletReceive([BalanceCurrency])
    case walletTransactionAmountPick(WalletTransactionAmountPick.TransactionType)
    case walletInvoiceCreate(Balance, Balance)
    case walletInvoiceCreateFriendsContent(WalletInvoiceCreateFriendsContent.ContentType, UserPickDelegateProtocol)
    case walletTransactionCreate(Balance, Balance)
    case walletTransactionCurrencyPick(CreateExternalTransactionProtocol)
    case walletPinCode(WalletPinCode.PinCodePurpose, WalletPinCodeUnlockDelegateProtocol)

    case walletPreview
  }
  
  enum AboutApp {
    case aboutHome
  }
  
  enum Settings {
    case settingsHome
    case referUser(AccountProfileProtocol)
    case commerceTypePick
    case accountSettings
    case walletSettings
    case accountCurrencyPicker(AccountCurrencyPickerDelegateProtocol)
    case about
    case externalLink(URL, String)
    case languagePicker(LanguagePickerDelegateProtocol)
    case usernamePicker
  }
  
  enum Notifications {
    case notificationsFeed
  }
}


