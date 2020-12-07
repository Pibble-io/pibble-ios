//
//  LocalizedStringKeyProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 03/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation
import Localize


fileprivate enum LocalizedStringKeyHelper {
  static let targetName: String = {
    var plistTargetName = Bundle.main.infoDictionary?["TargetName"] as? String
    return plistTargetName ?? ""
  }()
  
  static let prefixForLocalizedStrings = "Pibble"
}

protocol LocalizedStringKeyProtocol: LocalizableStringProtocol, CaseIterable, RawRepresentable where RawValue == String {
  //rawValue is used if localized string is missing
  //reflection is used to get key from item
  //case iterable is enumerate over all cases and print
}

protocol LocalizableStringProtocol  {
  var key: String { get }
  var defaultValue: String { get }
  func localize() -> String
  func localize(value: String) -> String
  func localize(values: String...) -> String
}

extension LocalizedStringKeyProtocol where RawValue == String {
  
  
  var defaultValue: String {
    return rawValue
  }
  
  
  var key: String {
    let reflectedString = String(reflecting: self)
    
    let targetNamePrefix = LocalizedStringKeyHelper.targetName
    
    if reflectedString.hasPrefix(targetNamePrefix) {
      let stringWithoutPrefix = String(reflectedString.dropFirst(targetNamePrefix.count))
      return "\(LocalizedStringKeyHelper.prefixForLocalizedStrings)\(stringWithoutPrefix)"
    }
    
    return reflectedString
  }
  
  func localize() -> String {
    guard Localize.localizeExists(forKey: key) else {
      AppLogger.error("not found localized string for key: \(key)")
      return rawValue
    }
    
    return key.localize()
  }
  
  
  func localize(value: String) -> String {
    guard Localize.localizeExists(forKey: key) else {
      AppLogger.error("not found localized string for key: \(key)")
      return rawValue.localize(value: value)
    }
 
    return key.localize(value: value)
  }
  
  func localize(values: String...) -> String {
    guard Localize.localizeExists(forKey: key) else {
      AppLogger.error("not found localized string for key: \(key)")
      return Localize.localize(key: rawValue, values: values)
    }
    
    return Localize.localize(key: key, values: values)
  }
  
  func localize(values: [String]) -> String {
    guard Localize.localizeExists(forKey: key) else {
      AppLogger.error("not found localized string for key: \(key)")
      return Localize.localize(key: rawValue, values: values)
    }
    
    return Localize.localize(key: key, values: values)
  }
}

struct LocalizedStringsHelper {
  let listOfLocalizedStrings: [[LocalizableStringProtocol]] = [
    ChatRoomGroupsContent.Strings.allCases,
    
    Chat.Strings.ChatNavigationBar.allCases,
    Chat.Strings.DigitalGoodPostHeaderActionsTitle.allCases,
    Chat.Strings.CheckoutStatusDescriptionFor.allCases,
    Chat.Strings.CheckoutStatusFor.allCases,
    Chat.Strings.Messages.allCases,
    Chat.Strings.Alerts.allCases,
    Chat.Strings.Errors.allCases,
    
    ChatRooms.Strings.Post.allCases,
    ChatRooms.Strings.ChatRoomItem.allCases,
    ChatRooms.Strings.ChatNavigationBar.allCases,
    ChatRooms.Strings.Alerts.allCases,
    
    SearchResultTagDetailContent.Strings.allCases,
    
    DiscoverSearchContent.Strings.allCases,
    
    CommercialPostDetail.Strings.allCases,
    CommercialPostDetail.Strings.Errors.allCases,
    CommercialPostDetail.Strings.CheckoutButtonTitle.allCases,
    
    UserDescriptionPicker.Strings.Errors.allCases,
    MediaEdit.Strings.Errors.allCases,
    
    Comments.Strings.allCases,
    
    PostsFeed.Strings.allCases,
    
    PostsFeed.Strings.Video.allCases,
    PostsFeed.Strings.TitleForCreationStatus.allCases,
    PostsFeed.Strings.StatusTitleForCommerce.allCases,
    PostsFeed.Strings.FundingCampaignSection.allCases,
    PostsFeed.Strings.FundingCampaignSection.ActionButton.allCases,
    
    PostsFeed.Strings.EditAlerts.allCases,
    PostsFeed.Strings.NavigationBarTitles.allCases,
    
    PostsFeed.Strings.PlaceholderSubtitle.allCases,
    PostsFeed.Strings.FundingPlaceholderTitle.allCases,
    
    PostsFeed.Strings.TopGroupsHeader.allCases,
    
    PostsFeed.Strings.Alerts.allCases,
    PostsFeed.Strings.Alerts.PromotionActions.allCases,
    PostsFeed.Strings.Alerts.PromotionMessages.allCases,
    PostsFeed.Strings.Alerts.FundingActions.allCases,
    
    PostsFeed.Strings.Alerts.FundingMessages.allCases,
    
    
    Donate.Strings.allCases,
    
    UpVote.Strings.allCases,
    
    TagsListing.Strings.allCases,
    
    UsersListing.Strings.allCases,
    UsersListing.Strings.NavigationBar.allCases,
    
    UserProfileContent.Strings.Titles.allCases,
    UserProfileContent.Strings.ButtonStates.allCases,
    UserProfileContent.Strings.TimePeriod.allCases,
    UserProfileContent.Strings.Placeholder.allCases,
    UserProfileContent.Strings.UserStats.allCases,
    UserProfileContent.Strings.FriendsStatus.allCases,
    
    UserProfileContainer.Strings.allCases,
    
    BannedUserProfileContent.Strings.allCases,
    
    AboutHome.Strings.allCases,
    
    CampaignPick.Strings.allCases,
    
    CampaignEdit.Strings.allCases,
    CampaignEdit.Strings.FundRaiseRecipient.allCases,
    CampaignEdit.Strings.NavBarButtons.allCases,
    CampaignEdit.Strings.TitleForPostingType.allCases,
    CampaignEdit.Strings.CrowdFundingRewardType.allCases,
    CampaignEdit.Strings.CrowdFundingRewardTypeInfo.allCases,
    CampaignEdit.Strings.SectionHeaders.allCases,
    CampaignEdit.Strings.RewardsAmountInputType.allCases,
    
    CampaignEdit.Strings.RewardsAmountInputPlaceholder.allCases,
    CampaignEdit.Strings.Errors.allCases,
    
    
    PromotionPick.Strings.allCases,
    
    MediaPosting.Strings.Titles.allCases,
    MediaPosting.Strings.TitleForPostingType.allCases,
    MediaPosting.Strings.PickCampaign.allCases,
    MediaPosting.Strings.NavBarButtons.allCases,
    
    CameraCapture.Strings.allCases,
    
    MediaPick.Strings.allCases,
    MediaPick.Strings.Errors.allCases,
    
    ResetPassword.Strings.Fields.allCases,
    ResetPassword.Strings.Errors.allCases,
    
    ResetPasswordPhonePick.Strings.Errors.allCases,
    
    TabBar.Strings.Alerts.allCases,
    TabBar.Strings.MenuItems.allCases,
    TabBar.Strings.SideMenuItems.allCases,
    
    
    ResetPasswordVerifyCode.Strings.Password.allCases,
    ResetPasswordVerifyCode.Strings.PinCode.allCases,
    ResetPasswordVerifyCode.Strings.ResendButtonTitles.allCases,
    
    RestorePasswordMethod.Strings.Password.allCases,
    RestorePasswordMethod.Strings.PinCode.allCases,
    RestorePasswordMethod.Strings.Errors.allCases,
    
    SignIn.Strings.Errors.allCases,
    SignIn.Strings.InputFields.allCases,
    
    Registration.Strings.Errors.allCases,
    Registration.Strings.InputFields.allCases,
    Registration.Strings.Links.allCases,
    
    PhonePick.Strings.Errors.allCases,
    
    VerifyCode.Strings.NavigationBarTitleForPurpose.allCases,
    VerifyCode.Strings.InformationTitleForPurpose.allCases,
    VerifyCode.Strings.InformationSubtitleForPurpose.allCases,
    VerifyCode.Strings.ResendButtonTitles.allCases,
    VerifyCode.Strings.VerificationFailAlert.allCases,
    
    WalletTransactionAmountPick.Strings.allCases,
    WalletTransactionAmountPick.Strings.ExchangeBackWarningMessage.allCases,
    
    WalletPinCode.Strings.allCases,
    
    WalletHome.Strings.allCases,
    
    Wallet.Strings.allCases,
    
    WalletPreview.Strings.allCases,
    
    WalletActivityContent.Strings.allCases,
    
    WalletActivityContent.Strings.DataPlaceholderMessages.allCases,
    
    WalletActivityContent.Strings.PromotionTransactions.allCases,
    WalletActivityContent.Strings.Funding.allCases,
    WalletActivityContent.Strings.PostHelpAnswers.allCases,
    
    MediaDetail.Strings.Alerts.allCases,
    
    ReportPostReason.Strings.allCases,
    
    BalanceCurrency.Strings.LocalizedNames.allCases,
    
    AppLanguage.Strings.allCases,
    
    WalletReceivePresenter.Strings.allCases,
    WalletReceivePresenter.Strings.Title.allCases,
    
    SettingsHome.Strings.MenuItems.allCases,
    
    ReferUser.Strings.allCases,
    
    AccountSettings.Strings.MenuItems.allCases,
    
    WalletSettings.Strings.MenuItems.allCases,
    
    About.Strings.MenuItems.allCases,
    
    LanguagePicker.Strings.Alert.allCases,
    
    CommerceTypePick.Strings.MenuItems.allCases,
    
    PromotionBudgetPick.Strings.allCases,
    
    CreatePromotionConfirm.Strings.allCases,
    CreatePromotionConfirm.Strings.Errors.allCases,
    CreatePromotionConfirm.Strings.Alerts.allCases,
    
    CreatePromotionConfirm.Strings.Alerts.PromotionConfirm.allCases,
    CreatePromotionConfirm.Strings.Alerts.PromotionCreationSuccess.allCases,
    
    VisitProfilePromotionActionType.Strings.allCases,
    
    PromotionInsights.Strings.Budget.allCases,
    PromotionInsights.Strings.Sections.allCases,
    
    EngagementType.Strings.allCases,
    
    PromotionStatus.Strings.allCases,
    
    NotificationsFeed.Strings.allCases,
    
    NotificationsFeed.Strings.SectionsHeaders.allCases,
    
    Onboarding.Strings.One.allCases,
    Onboarding.Strings.Two.allCases,
    Onboarding.Strings.Three.allCases,
    Onboarding.Strings.Four.allCases,
    
    WalletTransactionCurrencyPick.Strings.allCases,
    WalletTransactionCurrencyPick.Strings.Warning.allCases,
    
    WalletTransactionCreate.Strings.allCases,
    WalletTransactionCreate.Strings.NavBarButtons.allCases,
    
    PostStatistics.Strings.Budget.allCases,
    PostStatistics.Strings.Sections.allCases,
    
    TopGroupPostsType.Strings.allCases,
    
    UpvotedUsers.Strings.allCases,
    
    GoodsAvailabilityStatus.Strings.allCases,
    
    FundingPostDetail.Strings.CampaignTime.allCases,
    
    FundingPostDetail.Strings.Donators.Single.allCases,
    FundingPostDetail.Strings.Donators.Plural.allCases,
    
    FundingPostDetail.Strings.RewardTitle.allCases,
    
    FundingPostDetail.Strings.RewardAmount.Active.allCases,
    FundingPostDetail.Strings.RewardAmount.Passed.allCases,
    FundingPostDetail.Strings.RewardAmount.Upcoming.allCases,
    
    FundingPostDetail.Strings.DonatedCountTitle.allCases,
    FundingPostDetail.Strings.DonatedCountLeftTitle.allCases,
    FundingPostDetail.Strings.FundraisingFinishStats.allCases,
    FundingPostDetail.Strings.CampaignFinishMessage.allCases,
    
    FundingPostDetail.Strings.FundingActions.allCases,
    
    GiftsFeed.Strings.NavigationBarTitles.allCases,
    GiftsFeed.Strings.Alerts.allCases,
    
    PlayRoom.Strings.NavigationBarTitles.allCases,
    PlayRoom.Strings.Alerts.allCases,
    
    CreatePostHelp.Strings.HelpTypes.allCases,
    CreatePostHelp.Strings.RewardTitles.allCases,
    
    PostHelpAnswers.Strings.allCases,
    PostHelpRewardPick.Strings.allCases,
    
    TopBannerInfo.Strings.allCases,
    
    GiftsInvite.Strings.allCases,
    
    //Errors:
    
    ErrorStrings.PibbleError.allCases,
    ErrorStrings.MediaProcessingPipelineError.allCases, //no need to translate
    ErrorStrings.CameraCaptureServiceError.allCases,
    ErrorStrings.CommerceProcessingError.allCases,
    ErrorStrings.allCases
  ]

  func printAllStrings() {
    AppLogger.debug("/* printing All Localized Strings")
    listOfLocalizedStrings.forEach {
      $0.forEach {
        print(" ")
        print("\"\($0.key)\" = \"\($0.defaultValue)\";")
      }
    }
  }
  
  func checkAllStrings() {
    AppLogger.debug("/* checking All Localized Strings")
    listOfLocalizedStrings.forEach {
      $0.forEach {
//        let localized = $0.localize()
        if !Localize.localizeExists(forKey: $0.key) {
          print(" ")
          print("\"\($0.key)\" = \"\($0.defaultValue)\";")
        }
      }
    }
  }
}
