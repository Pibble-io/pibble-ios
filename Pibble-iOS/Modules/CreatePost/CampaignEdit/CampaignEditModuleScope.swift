//
//  CampaignEditModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum CampaignEdit {
  enum Errors: PibbleErrorProtocol {
    var description: String {
      switch self {
      case .teamNameAlreadyTaken:
        return Strings.Errors.teamNameAlreadyTaken.localize()
      case .emptyTeamName:
        return Strings.Errors.emptyTeamName.localize()
      }
    }
    
    case teamNameAlreadyTaken
    case emptyTeamName
  }
  
  enum InputSectionTypes {
    case amount
    case title
    case recipient
    case recipientItem
    case category
    case categoryItem
    
    case sectionHeaderItem
    case rewardTypeItem
    
    case rewardInputs
    
    case teamHeaderItem
    case teamTypes
    case teamEdit
    case sectionFooterItem
    
  }
  
  enum InputViewModelType {
    case amount(CampaignEditAmountInputViewModelProtocol)
    case title(CampaignEditTitleViewModelProtocol)
    case selectedCampaignRecipient(CampaignEditSelectedItemViewModelProtocol)
    case campaignRecipientItem(CampaignEditSelectionPlainItemViewModelProtocol)
    case selectedCategory(CampaignEditSelectedItemViewModelProtocol)
    case categoryItem(CampaignEditSelectionPlainItemViewModelProtocol)
    case teamHeaderItem
    case teamType(CampaignEditTeamItemViewModelProtocol)
    case teamNameInput(CampaignEditTeamNameViewModelProtocol)
    case teamLogoPick(CampaignEditTeamLogoPickerViewModelProtocol)
    case sectionFooterItem
    
    case sectionHeader(CampaignEditHeaderViewModelProtocol)
    case selectionItem(CampaignEditSelectionItemViewModelProtocol)
    
    case rewardInputPrice(CampaignEditRewardAmountPickViewModelProtocol)
    case rewardInputDiscountPrice(CampaignEditRewardAmountPickViewModelProtocol)
    case rewardInputEarlyPrice(CampaignEditRewardAmountPickViewModelProtocol)
    
  }
  
  enum AmountInputActions {
    case sliderValueChanged(Float)
    case amountTextValueChanged(String)
    case amountTextEndEditing
  }
  
  enum TitleInputActions {
    case titleTextChanged(String)
    case endEditing
  }
  
  enum TeamNameInputActions {
    case titleTextChanged(String)
    case endEditing
  }
  
  enum LogoPickActions {
    case pickLogoAction
  }
  
  enum RewardAmountInputActions {
    case firstAmountInputChanged(String)
    case firstAmountInputEndEditing
    
    case secondAmountInputChanged(String)
    case secondAmountInputEndEditing
    
  }
  
  class DraftCampaignTeam: DraftCampaignTeamProtocol {
    var name: String = ""
    var logo: UIImage?
    
    convenience init(draft: DraftCampaignTeamProtocol) {
      self.init()
      name = draft.name
      logo = draft.logo
    }
  }
  
  
  
  struct AmountInputViewModel: CampaignEditAmountInputViewModelProtocol {
    static func convertAmountFrom(_ value: String) -> Float {
      let formatter = NumberFormatter()
      return formatter.number(from: value)?.floatValue ?? 0.0
    }
    
    static func convertAmountFrom(_ value: Float) -> String {
      let formatter = NumberFormatter()
      return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    func convertAmountFrom(_ value: String) -> Float {
      return AmountInputViewModel.convertAmountFrom(value)
    }
    
    func limitedValueStringFor(_ value: String) -> String {
      let floatValue = convertAmountFrom(value)
      let limitedValue = min(floatValue, maxAmount)
      return convertAmountFrom(limitedValue)
    }
    
    func convertAmountFrom(_ value: Float) -> String {
      return AmountInputViewModel.convertAmountFrom(value)
    }
    
    var minAmount: Float
    
    var maxAmount: Float
    
    var currentAmount: Float
    
    let currentAmountString: String
    
    let campaignTypeIconImage: UIImage?
    
    init(postType: PostingType, draft: CampaignDraftProtocol, min: Float, max: Float) {
      minAmount = min
      maxAmount = max
      currentAmount = Float(draft.goal)
      currentAmountString = AmountInputViewModel.convertAmountFrom(currentAmount)
      
      switch postType {
      case .media:
        campaignTypeIconImage = nil
      case .charity:
        campaignTypeIconImage = UIImage(imageLiteralResourceName: "CampaignEdit-CharityIcon")
      case .crowdfunding, .crowdfundingWithReward:
        campaignTypeIconImage = UIImage(imageLiteralResourceName: "CampaignEdit-CrowdfundingIcon")
      case .digitalGood:
        campaignTypeIconImage = nil
      case .goods:
        campaignTypeIconImage = nil
      }
    }
  }
  
  struct TitleViewModel: CampaignEditTitleViewModelProtocol {
    let title: String
    let picked: Bool
    let attributedPlaceholder: NSAttributedString
    
    init(draft: CampaignDraftProtocol) {
      title = draft.title
      picked = draft.title.count > 0
      attributedPlaceholder =  NSAttributedString(string: CampaignEdit.Strings.draftEmptyTitle.localize(),
                                                  attributes: [
                                                    NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 15.0),
                                                    NSAttributedString.Key.foregroundColor: UIConstants.Colors.deselectedTitle
        ])
    }
    
  }
  
  struct SelectedRecipientViewModel: CampaignEditSelectedItemViewModelProtocol {
    let attributedTitle: NSAttributedString
    let picked: Bool
    
    init(draft: CampaignDraftProtocol) {
      guard let raisingFor = draft.raisingFor else {
        picked = false
        attributedTitle = NSAttributedString(string: CampaignEdit.Strings.draftEmptyRaisingFor.localize(),
                                             attributes: [
                                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 15.0),
                                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.deselectedTitle])
        return
      }
      
      picked = true
      attributedTitle = NSAttributedString(string: raisingFor.title,
                                           attributes: [
                                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 15.0),
                                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.selectedTitle])
      
    }
  }
  
  struct SelectedCategoryViewModel: CampaignEditSelectedItemViewModelProtocol {
    let attributedTitle: NSAttributedString
    let picked: Bool
    
    init(draft: CampaignDraftProtocol) {
      guard let category = draft.category else {
        picked = false
        attributedTitle = NSAttributedString(string: CampaignEdit.Strings.draftEmptyCategoryFor.localize(),
                                             attributes: [
                                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 15.0),
                                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.deselectedTitle])
        return
      }
      
      picked = true
      attributedTitle = NSAttributedString(string: category.name,
                                           attributes: [
                                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 15.0),
                                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.selectedTitle])
      
    }
  }
  
  struct CategoryItemViewModel: CampaignEditSelectionPlainItemViewModelProtocol {
    var isSelected: Bool
    
    let title: String
    
    init(category: CategoryProtocol, isSelected: Bool) {
      title = category.name
      self.isSelected = isSelected
    }
  }
  
  struct RecipientItemViewModel: CampaignEditSelectionPlainItemViewModelProtocol {
    var isSelected: Bool
    let title: String
    
    init(recipient: FundRaiseRecipient, isSelected: Bool) {
      title = recipient.title
      self.isSelected = isSelected
    }
  }
  
  struct CampaignEditTeamNameViewModel: CampaignEditTeamNameViewModelProtocol {
    let title: String
    let picked: Bool
    let attributedPlaceholder: NSAttributedString
    
    init(draft: CampaignDraftProtocol) {
      attributedPlaceholder =  NSAttributedString(string: CampaignEdit.Strings.draftEmptyTeamName.localize(),
                                                  attributes: [
                                                    NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 15.0),
                                                    NSAttributedString.Key.foregroundColor: UIConstants.Colors.deselectedTitle
        ])
      
      guard let selectedTeam = draft.team,
        case let DraftCampaignTeamType.team(teamEntity) = selectedTeam,
        let selectedTeamEntity = teamEntity else {
          
          picked = false
          title = ""
          return
      }
      
      picked = true
      title = selectedTeamEntity.name
      
    }
  }
  
  struct CampaignEditTeamItemViewModel: CampaignEditTeamItemViewModelProtocol, CampaignEditSelectionItemViewModelProtocol {
    let teamTypeImageView: UIImage
    let teamTypeTitle: String
    let teamDescription: String
    let teamAdditionDescription: String
    init(draft: CampaignDraftProtocol, team: DraftCampaignTeamType) {
      isSelected = draft.team?.stringKey == team.stringKey
      
      switch team {
      case .individual:
        teamTypeImageView = isSelected ? #imageLiteral(resourceName: "CampaignEdit-IndividualIcon-selected")  : #imageLiteral(resourceName: "CampaignEdit-IndividualIcon")
        teamTypeTitle = CampaignEdit.Strings.individualCampaignTeamTitle.localize()
        teamDescription = CampaignEdit.Strings.individualCampaignTeamDescription.localize()
        teamAdditionDescription = CampaignEdit.Strings.individualCampaignTeamAdditionalDescription.localize()
        
      case .team(_):
        teamTypeImageView = isSelected ? #imageLiteral(resourceName: "CampaignEdit-TeamIcon-selected") : #imageLiteral(resourceName: "CampaignEdit-TeamIcon")
        teamTypeTitle = CampaignEdit.Strings.teamCampaignTeamTitle.localize()
        teamDescription = CampaignEdit.Strings.teamCampaignTeamDescription.localize()
        teamAdditionDescription = ""
      }
    }
    
    var title: String {
      return teamTypeTitle
    }
    
    var subtitle: String {
      return teamDescription
    }
    
    let isSelected: Bool
    
  }
  
  struct CampaignEditTeamLogoPickerViewModel: CampaignEditTeamLogoPickerViewModelProtocol {
    let teamLogo: UIImage?
    let teamLogoPlaceHolder: UIImage
    
    init(draft: CampaignDraftProtocol) {
      guard let team = draft.team else {
        teamLogo = nil
        teamLogoPlaceHolder = #imageLiteral(resourceName: "CampaignEdit-TeamLogoPlaceholder")
        return
      }
      
      switch team {
      case .individual:
        teamLogo = nil
        teamLogoPlaceHolder = #imageLiteral(resourceName: "CampaignEdit-TeamLogoPlaceholder")
      case .team(let teamEntity):
        teamLogoPlaceHolder = #imageLiteral(resourceName: "CampaignEdit-TeamLogoPlaceholder")
        teamLogo = teamEntity?.logo
      }
    }
  }
  
  struct CampaignEditRewardTypeViewModel: CampaignEditSelectionItemViewModelProtocol {
    let title: String
    let subtitle: String
    
    let isSelected: Bool
    
    init(postType: PostingType, isSelected: Bool) {
      title = postType.crowdFundingRewardTypeTitle
      subtitle = postType.crowdFundingRewardTypeSubtitle
      self.isSelected = isSelected
    }
  }
  
  enum CampaignEditHeaderViewModel: CampaignEditHeaderViewModelProtocol {
    case rewardTypeHeader
    case campaignTeamHeader
    case rewardsPickHeader
    
    var title: String {
      switch self {
      case .rewardTypeHeader:
        return CampaignEdit.Strings.SectionHeaders.rewardType.localize()
      case .campaignTeamHeader:
        return CampaignEdit.Strings.SectionHeaders.fundraiseAsType.localize()
      case .rewardsPickHeader:
        return CampaignEdit.Strings.SectionHeaders.rewardsPick.localize()
      }
    }
  }
  
  enum RewardsAmountInputType {
    case regularPrice
    case earlyBirdPrice
    case discountPrice
  }
  
  struct RewardsAmountsInputs: CampaignEditRewardAmountPickViewModelProtocol {
    let title: String
    
    let amounts: (String, String?)
    let attributedPlaceholders: (NSAttributedString, NSAttributedString?)
    
    let amountValueTitle: (String, String?)
    
    let hasSecondInput: Bool
    
    init(inputType: RewardsAmountInputType, price: Double?, amount: Int?) {
      let priceString = price.map { String(format: "%.0f", $0) } ?? ""
      let amountString = amount.map { "\($0)" } ?? ""
      
      amounts = (priceString, amountString)
      
      let pricePlaceholder = NSAttributedString(string: CampaignEdit.Strings.RewardsAmountInputPlaceholder.price.localize(),
                                                attributes: [
                                                  NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 15.0),
                                                  NSAttributedString.Key.foregroundColor: UIConstants.Colors.deselectedTitle
        ])
      
      let amountPlaceholder = NSAttributedString(string: CampaignEdit.Strings.RewardsAmountInputPlaceholder.amount.localize(),
                                                 attributes: [
                                                  NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 15.0),
                                                  NSAttributedString.Key.foregroundColor: UIConstants.Colors.deselectedTitle
        ])
      
      attributedPlaceholders = (pricePlaceholder, amountPlaceholder)
      amountValueTitle = (BalanceCurrency.pibble.symbol, nil)
      
      switch inputType  {
      case .regularPrice:
        hasSecondInput = false
        title = CampaignEdit.Strings.RewardsAmountInputType.regularPrice.localize()
      case .earlyBirdPrice:
        hasSecondInput = true
        title = CampaignEdit.Strings.RewardsAmountInputType.superEarlyBirdPrice.localize()
      case .discountPrice:
        hasSecondInput = true
        title = CampaignEdit.Strings.RewardsAmountInputType.earlyBirdPrice.localize()
      }
    }
    
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let deselectedTitle = UIColor.gray181
    static let selectedTitle = UIColor.black
  }
  
}

fileprivate extension FundRaiseRecipient {
  var title: String {
    switch self {
    case .charity:
      return CampaignEdit.Strings.FundRaiseRecipient.charity.localize()
    case .myself:
      return CampaignEdit.Strings.FundRaiseRecipient.myself.localize()
    case .someoneElse:
      return CampaignEdit.Strings.FundRaiseRecipient.someoneElse.localize()
    }
  }
}

fileprivate extension PostingType {
  var crowdFundingRewardTypeTitle: String {
    switch self {
    case .media:
      return CampaignEdit.Strings.CrowdFundingRewardType.noReward.localize()
    case .charity:
      return CampaignEdit.Strings.CrowdFundingRewardType.noReward.localize()
    case .crowdfunding:
      return CampaignEdit.Strings.CrowdFundingRewardType.noReward.localize()
    case .crowdfundingWithReward:
      return CampaignEdit.Strings.CrowdFundingRewardType.hasReward.localize()
    case .digitalGood:
      return CampaignEdit.Strings.CrowdFundingRewardType.noReward.localize()
    case .goods:
      return CampaignEdit.Strings.CrowdFundingRewardType.noReward.localize()
    }
  }
  
  var crowdFundingRewardTypeSubtitle: String {
    switch self {
    case .media:
      return CampaignEdit.Strings.CrowdFundingRewardTypeInfo.noReward.localize()
    case .charity:
      return CampaignEdit.Strings.CrowdFundingRewardTypeInfo.noReward.localize()
    case .crowdfunding:
      return CampaignEdit.Strings.CrowdFundingRewardTypeInfo.noReward.localize()
    case .crowdfundingWithReward:
      return CampaignEdit.Strings.CrowdFundingRewardTypeInfo.hasReward.localize()
    case .digitalGood:
      return CampaignEdit.Strings.CrowdFundingRewardTypeInfo.noReward.localize()
    case .goods:
      return CampaignEdit.Strings.CrowdFundingRewardTypeInfo.noReward.localize()
    }
  }
}

extension CampaignEdit {
  enum Strings: String, LocalizedStringKeyProtocol {
    case draftEmptyTitle = "Add Campaign Title"
    case draftEmptyRaisingFor = "Who are you rasing funds for?"
    case draftEmptyCategoryFor = "Choose a category"
    
    case individualCampaignTeamTitle = "An Individual"
    case teamCampaignTeamTitle = "A Team"
    
    case individualCampaignTeamDescription = "I am the sole organizer."
    case individualCampaignTeamAdditionalDescription = "You can turn on as a Team fundraising later."
    case teamCampaignTeamDescription = "I will invite others to fundraise with me."
    
    case draftEmptyTeamName = "Enter your team name"
    
    enum NavBarButtons: String, LocalizedStringKeyProtocol {
      case next = "Next"
      case post = "Post"
    }
    
    enum TitleForPostingType: String, LocalizedStringKeyProtocol {
      case media = "Post Media"
      case charity = "Post Charity"
      case crowdfunding = "Post Funding"
      case commercial = "Post Commerce"
      case goods = "Post Goods"
    }
    
    enum CrowdFundingRewardType: String, LocalizedStringKeyProtocol {
      case hasReward = "Has Reward"
      case noReward = "No Reward"
    }
    
    enum CrowdFundingRewardTypeInfo: String, LocalizedStringKeyProtocol {
      case hasReward = "We have a reward for the funding amount."
      case noReward = "This funding is not obligated to reward."
    }
    
    enum SectionHeaders: String, LocalizedStringKeyProtocol {
      case rewardType = "Reward Type:"
      case fundraiseAsType = "Fundraise as:"
      case rewardsPick = "Rewards"
    }
    
    enum FundRaiseRecipient: String, LocalizedStringKeyProtocol {
      case charity = "Charity or non-profit"
      case myself = "Myself"
      case someoneElse = "Someone else"
    }
    
    enum RewardsAmountInputType: String, LocalizedStringKeyProtocol  {
      case regularPrice = "Regular Price"
      case superEarlyBirdPrice = "Super Early Bird Single (Best Price)"
      case earlyBirdPrice = "Early Bird Single (Discount)"
    }
    
    enum RewardsAmountInputPlaceholder: String, LocalizedStringKeyProtocol  {
      case price = "Price"
      case amount = "Limited Amount"
    }
    
    enum Errors: String, LocalizedStringKeyProtocol  {
      case teamNameAlreadyTaken = "A Team with that name already exists."
      case emptyTeamName = "Team name can not be empty."
    }
    
    static func titleForPostingType(_ postingType: PostingType) -> String {
      switch postingType {
      case .media:
        return TitleForPostingType.media.localize()
      case .charity:
        return TitleForPostingType.charity.localize()
      case .crowdfunding, .crowdfundingWithReward:
        return TitleForPostingType.crowdfunding.localize()
      case .digitalGood:
        return TitleForPostingType.commercial.localize()
      case .goods:
        return TitleForPostingType.goods.localize()
      }
    }
  }
}
