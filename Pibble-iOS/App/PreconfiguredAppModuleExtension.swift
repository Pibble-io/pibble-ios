//
//  AppModulesPreconfiguredExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

//MARK:- PreconfiguredAppModule protocol

fileprivate protocol PreconfiguredAppModule: ConfigurableModule {
  
}

extension PreconfiguredAppModule {
  var defaultDIContainer: ServiceContainerProtocol {
    return AppModules.servicesContainer
  }
  
  var viewType: ViperViewType {
    return .fromStoryboard
  }
  
  var storyboardName: String {
    return "\(Mirror(reflecting: self).children.first?.label ?? String(describing: self))"
  }
}

//MARK:- AppModules.MediaFeed: PreconfiguredAppModule

extension AppModules.Posts: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .postsFeed(let feedType):
      return PostsFeedModuleConfigurator.defaultConfig(defaultDIContainer, feedType)
    case .comments(let posting):
      return CommentsModuleConfigurator.defaultConfig(defaultDIContainer, posting)
    case .upVote(let delegate, let purpose):
      return UpVoteModuleConfigurator.defaultConfig(defaultDIContainer, delegate, purpose)
    case .upvotedUsers(let posting, let delegate):
     return UpvotedUsersModuleConfigurator.defaultConfig(defaultDIContainer, .posting(posting), delegate )
    case .donate(let delegate, let currencies, let amountPickType):
      return DonateModuleConfigurator.defaultConfig(defaultDIContainer, delegate, currencies, amountPickType)
    case .commercialPostDetail(let commercialPostType, let delegate):
      return CommercialPostDetailModuleConfigurator.defaultConfig(defaultDIContainer, commercialPostType, delegate)
    case .fundingPostDetail(let post, let presentationType, let delegate):
      return FundingPostDetailModuleConfigurator.defaultConfig(defaultDIContainer,
                                                               post,
                                                               presentationType,
                                                               delegate)
    case .fundingPostsContainer(let accountProfile):
      return FundingPostsContainerModuleConfigurator.defaultConfig(accountProfile)
    case .mediaDetail(let post, let media):
      return MediaDetailModuleConfigurator.defaultConfig(defaultDIContainer, post, media)
    case .reportPost(let delegate):
      return ReportPostModuleConfigurator.defaultConfig(defaultDIContainer, delegate)
    case .leaderboardContainer:
      return LeaderboardContainerModuleConfigurator.defaultConfig
    case .leaderboardContent(let leaderboardType):
      return LeaderboardContentModuleConfigurator.defaultConfig(defaultDIContainer, leaderboardType)
    case .topBannerInfo:
      return TopBannerInfoModuleConfigurator.defaultConfig(defaultDIContainer)
    }
  }
}

//MARK:- AppModules.Gifts: PreconfiguredAppModule

extension AppModules.Gifts: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .giftsFeed(let contentType):
      return GiftsFeedModuleConfigurator.defaultConfig(defaultDIContainer, contentType)
    case .giftsInvite:
      return GiftsInviteModuleConfigurator.defaultConfig(defaultDIContainer)
    }
  }
}

//MARK:- AppModules.Messenger: PreconfiguredAppModule

extension AppModules.Messenger: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .chat(let roomType):
      return ChatModuleConfigurator.defaultConfig(defaultDIContainer, roomType)
    case .chatRooms(let contentType):
      return ChatRoomsModuleConfigurator.defaultConfig(defaultDIContainer, contentType)
    case .chatRoomGroupsContent:
      return ChatRoomGroupsContentModuleConfigurator.defaultConfig(defaultDIContainer)
    case .chatRoomsContainer:
      return ChatRoomsContainerModuleConfigurator.defaultConfig
    }
  }
}

//MARK:- AppModules.Discover: PreconfiguredAppModule

extension AppModules.Discover: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .discoverFeedRootContainer:
      return DiscoverFeedRootContainerModuleConfigurator.defaultConfig
    case .discoverSearchContent(let contentType, let delegate):
      return DiscoverSearchContentModuleConfigurator.defaultConfig(defaultDIContainer, contentType, delegate)
    case .searchResultDetailContainer(let contentType):
      return SearchResultDetailContainerModuleConfigurator.defaultConfig(defaultDIContainer, contentType)
    case .searchResultTagDetailContent(let tag):
      return SearchResultTagDetailContentModuleConfigurator.defaultConfig(defaultDIContainer, tag)
    case .searchResultPlaceMap(let location):
      return SearchResultPlaceMapModuleConfigurator.defaultConfig(location)
    }
  }
}

//MARK:- AppModules.Posting: PreconfiguredAppModule

extension AppModules.CreatePost: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .mediaAlbumPick(let delegate):
      return MediaAlbumPickModuleConfigurator.defaultConfig(delegate)
    case .mediaPick(let delegate, let config):
      return MediaPickModuleConfigurator.defaultConfig(defaultDIContainer, delegate, config)
    case .cameraCapture:
      return CameraCaptureModuleConfigurator.defaultConfig(defaultDIContainer)
    case .mediaSource(let postDraft):
      return MediaSourceModuleConfigurator.defaultConfig(postDraft)
    case .mediaEdit(let inputMedia, let mediaEditDelegate):
      return MediaEditModuleConfigurator.defaultConfig(inputMedia, mediaEditDelegate)
    case .mediaPosting(let postDraft):
      return MediaPostingModuleConfigurator.defaultConfig(defaultDIContainer, postDraft)
    case .tagPick(let tagPickDelegate):
      return TagPickModuleConfigurator.defaultConfig(defaultDIContainer, tagPickDelegate)
    case .locationPick(let locationPickDelegate):
      return LocationPickModuleConfigurator.defaultConfig(defaultDIContainer, locationPickDelegate)
    case .descriptionPick(let descriptionPickDelegate):
      return DescriptionPickModuleConfigurator.defaultConfig(descriptionPickDelegate)
    case .promotionPick(let promotionPickDelegate):
      return PromotionPickModuleConfigurator.defaultConfig(defaultDIContainer, promotionPickDelegate)
    case .campaignEdit(let postDraft, let campaignType):
      return CampaignEditModuleConfigurator.defaultConfig(defaultDIContainer, postDraft, campaignType)
    case .campaignPick(let postDraft, let campaignType):
      return CampaignPickModuleConfigurator.defaultConfig(defaultDIContainer, postDraft, campaignType)
    }
  }
}

//MARK:- AppModules.TabBarTest: PreconfiguredAppModule

extension AppModules.TabBarTest: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .testOne:
      return TestOneModuleConfigurator.defaultConfig
    case .testTwo:
      return TestTwoModuleConfigurator.defaultConfig
    case .testThree:
      return TestThreeModuleConfigurator.defaultConfig
    case .testFour:
      return TestFourModuleConfigurator.defaultConfig
    }
  }
}

//MARK:- AppModules.Main: PreconfiguredAppModule

extension AppModules.Main: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .tabBar:
      let modules: [TabBar.MainItems: PreconfiguredAppModule] = [
        .first: AppModules.Posts.postsFeed(.main),
        .second: AppModules.Discover.discoverFeedRootContainer,
        .third: AppModules.UserProfile.userProfileContainer(.current),
        .fourth: AppModules.AboutApp.aboutHome
      ]
      
      return TabBarModuleConfigurator.defaultConfig(defaultDIContainer, modules)
    }
  }
}

//MARK:- AppModules.Auth: PreconfiguredAppModule

extension AppModules.Auth: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .registration:
      return RegistrationModuleConfigurator.defaultConfig(defaultDIContainer)
    case .phonePick:
      return PhonePickModuleConfigurator.defaultConfig(defaultDIContainer)
    case .verifyCode(let purpose):
      return VerifyCodeModuleConfigurator.defaultConfig(defaultDIContainer, purpose)
    case .signIn:
      return SignInModuleConfigurator.defaultConfig(defaultDIContainer)
    case .restorePasswordMethod(let purpose):
      return RestorePasswordMethodModuleConfigurator.defaultConfig(defaultDIContainer, purpose)
    case .resetPasswordWithEmail:
      return ResetPasswordWithEmailModuleConfigurator.defaultConfig(defaultDIContainer)
    case .resetPasswordEmailSent(let email):
      return ResetPasswordEmailSentModuleConfigurator.defaultConfig(email)
    case .resetPasswordPhonePick:
      return ResetPasswordPhonePickModuleConfigurator.defaultConfig(defaultDIContainer)
    case .resetPasswordVerifyCode(let purpose):
      return ResetPasswordVerifyCodeModuleConfigurator.defaultConfig(defaultDIContainer, purpose)
    case .resetPassword(let code):
      return ResetPasswordModuleConfigurator.defaultConfig(defaultDIContainer, code)
    case .resetPasswordSuccess:
      return ResetPasswordSuccessModuleConfigurator.defaultConfig
    case .welcomeScreen:
      return WelcomeScreenModuleConfigurator.defaultConfig
    case .onboarding:
      return OnboardingModuleConfigurator.defaultConfig(defaultDIContainer)
    }
  }
}

//MARK:- AppModules.Wallet: PreconfiguredAppModule

extension AppModules.Wallet: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .walletTransactionAmountPick(let transactionType):
      return WalletTransactionAmountPickModuleConfigurator.defaultConfig(defaultDIContainer, transactionType)
    case .walletPreview:
      return WalletPreviewModuleConfigurator.defaultConfig(defaultDIContainer)
    case .walletHome:
      return WalletHomeModuleConfigurator.defaultConfig(defaultDIContainer)
    case .walletActivity:
      let modules: [WalletActivity.SelectedSegment: ConfigurableModule] = [
        .pibble: AppModules.Wallet.walletActivityContent(.walletActivities(.coin(.pibble))),
        .etherium: AppModules.Wallet.walletActivityContent(.walletActivities(.coin(.etherium))),
        .bitcoin: AppModules.Wallet.walletActivityContent(.walletActivities(.coin(.bitcoin))),
        .brush: AppModules.Wallet.walletActivityContent(.walletActivities(.brush))
      ]
      
      return WalletActivityModuleConfigurator.defaultConfig(defaultDIContainer, modules)
    case .walletActivityContent(let contentType):
      return WalletActivityContentModuleConfigurator.defaultConfig(defaultDIContainer, contentType)
    case .walletPayBill:
      return WalletPayBillModuleConfigurator.defaultConfig(defaultDIContainer)
    case .walletReceive(let currencies):
      return WalletReceiveModuleConfigurator.defaultConfig(defaultDIContainer, currencies)
    case .walletInvoiceCreate(let mainBalance, let secondaryBalance):
      return WalletInvoiceCreateModuleConfigurator.defaultConfig(defaultDIContainer, mainBalance, secondaryBalance)
    case .walletInvoiceCreateFriendsContent(let contentType, let delegate):
      return WalletInvoiceCreateFriendsContentModuleConfigurator.defaultConfig(defaultDIContainer, contentType, delegate)
    case .walletTransactionCreate(let mainBalance, let secondaryBalance):
      return WalletTransactionCreateModuleConfigurator.defaultConfig(defaultDIContainer, mainBalance, secondaryBalance)
    case .walletTransactionCurrencyPick(let transactionDraft):
      return WalletTransactionCurrencyPickModuleConfigurator.defaultConfig(defaultDIContainer, transactionDraft)
      
    case .walletPinCode(let pinCodePurpose, let delegate):
      return WalletPinCodeModuleConfigurator.defaultConfig(defaultDIContainer, pinCodePurpose, delegate)
    }
  }
}

//MARK:- AppModules.Settings: PreconfiguredAppModule

extension AppModules.AboutApp: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .aboutHome:
      return AboutHomeModuleConfigurator.defaultConfig(defaultDIContainer)
    }
  }
}

//MARK:- AppModules.UserProfile: PreconfiguredAppModule

extension AppModules.UserProfile: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .userProfileContent(let targetUser):
      return UserProfileContentModuleConfigurator.defaultConfig(defaultDIContainer, targetUser)
    case .userProfileContainer(let targetUser):
      return UserProfileContainerModuleConfigurator.defaultConfig(defaultDIContainer, targetUser)
    case .bannedUserProfileContent(let user):
      return BannedUserProfileContentModuleConfigurator.defaultConfig(user)
    case .usersListing(let filterType):
      return UsersListingModuleConfigurator.defaultConfig(defaultDIContainer, filterType)
    case .userDescriptionPicker(let delegate):
      return UserDescriptionPickerModuleConfigurator.defaultConfig(delegate)
    case .tagsListing(let filterType):
      return TagsListingModuleConfigurator.defaultConfig(defaultDIContainer, filterType)
    case .playRoom(let user):
      return PlayRoomModuleConfigurator.defaultConfig(defaultDIContainer, user)
    }
  }
}

//MARK:- AppModules.Settings: PreconfiguredAppModule

extension AppModules.Settings: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .settingsHome:
      return SettingsHomeModuleConfigurator.defaultConfig(defaultDIContainer)
    case .referUser(let targetUser):
      return ReferUserModuleConfigurator.defaultConfig(defaultDIContainer, targetUser)
    case .commerceTypePick:
      return CommerceTypePickModuleConfigurator.defaultConfig(defaultDIContainer)
    case .accountSettings:
      return AccountSettingsModuleConfigurator.defaultConfig(defaultDIContainer)
    case .walletSettings:
      return WalletSettingsModuleConfigurator.defaultConfig(defaultDIContainer)
    case .accountCurrencyPicker(let delegate):
      return AccountCurrencyPickerModuleConfigurator.defaultConfig(defaultDIContainer, delegate)
    case .about:
      return AboutModuleConfigurator.defaultConfig(defaultDIContainer)
    case .externalLink(let url, let title):
      return ExternalLinkModuleConfigurator.defaultConfig(url, title)
    case .languagePicker(let delegate):
      return LanguagePickerModuleConfigurator.defaultConfig(defaultDIContainer, delegate)
    case .usernamePicker:
      return UsernamePickerModuleConfigurator.defaultConfig(defaultDIContainer)
    }
  }
}


//MARK:- AppModules.PostHelp: PreconfiguredAppModule

extension AppModules.PostHelp: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .createPostHelp(let delegate):
      return CreatePostHelpModuleConfigurator.defaultConfig(delegate)
    case .postHelpAnswers(let postHelpRequest):
      return PostHelpAnswersModuleConfigurator.defaultConfig(defaultDIContainer, postHelpRequest)
    case .postHelpRewardPick(let delegate):
      return PostHelpRewardPickModuleConfigurator.defaultConfig(defaultDIContainer, delegate)
    }
  }
}

//MARK:- AppModules.CreatePromotion: PreconfiguredAppModule

extension AppModules.Promotion: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .promotionDestinationPick(let post):
      return PromotionDestinationPickModuleConfigurator.defaultConfig(post)
    case .promotionUrlDestinationPick(let delegate):
      return PromotionUrlDestinationPickModuleConfigurator.defaultConfig(defaultDIContainer, delegate)
    case .promotionBudgetPick(let promotionDraft):
      return PromotionBudgetPickModuleConfigurator.defaultConfig(defaultDIContainer, promotionDraft)
    case .createPromotionConfirm(let promotionDraft):
      return CreatePromotionConfirmModuleConfigurator.defaultConfig(defaultDIContainer, promotionDraft)
    case .promotedPostsContainer(let currentProfile):
      return PromotedPostsContainerModuleConfigurator.defaultConfig(currentProfile)
    case .promotionInsights(let promotion):
      return PromotionInsightsModuleConfigurator.defaultConfig(defaultDIContainer, promotion)
    case .postStatistics(let post):
      return PostStatisticsModuleConfigurator.defaultConfig(defaultDIContainer, post)
    }
  }
}

//MARK:- AppModules.Notifications: PreconfiguredAppModule

extension AppModules.Notifications: PreconfiguredAppModule {
  var defaultConfigurator: ModuleConfigurator {
    switch self {
    case .notificationsFeed:
      return NotificationsFeedModuleConfigurator.defaultConfig(defaultDIContainer)
    }
  }
}
