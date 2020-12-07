//
//  FundingPostDetailModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum FundingPostDetail {
  enum PresentationType {
    case defaultPresentation
    case presentationWithControls
  }
  
  enum FundingPostType {
    case funding(PostingProtocol, FundingCampaignProtocol)
    
  }
  
  typealias ActionHandler = (UITableViewCell, FundingPostDetail.Actions) -> Void

  enum Actions {
    case postForTeam
    case donate
    case stopCampaign
  }
  
  enum ViewModelType {
    case title(FundingPostDetailTitleViewModelProtocol)
    case progressStatus(FundingPostDetailProgressStatusViewModelProtocol)
    case timeProgressStatus(FundingPostDetailTimeProgressStatusViewModelProtocol)
    case contriibutorsInfo(FundingPostDetailContributorsInfoViewModelProtocol)
    case teamInfo(FundingPostDetailTeamViewModelProtocol)
    case rewardsInfo(FundingPostDetailRewardsInfoViewModelProtocol)
    case finishStats(FundingPostDetailFinishStatsViewModelProtocol)
    case finishCampaign(FundingPostDetailCampaignFinishViewModelProtocol)
    case actionButton(FundingPostDetailActionButtonViewModelProtocol)
  }
  
  
  struct FundingPostDetailTitleViewModel: FundingPostDetailTitleViewModelProtocol {
    let title: String
    let tags: String
    let icon: UIImage?
    
    init?(post: PostingProtocol) {
      switch post.postingType {
      case .media:
        return nil
      case .funding:
        icon = UIImage(imageLiteralResourceName: "FundingPostDetail-CrowdFundingIcon")
      case .charity:
        icon = UIImage(imageLiteralResourceName: "FundingPostDetail-CharityIcon")
      case .crowdfundingWithReward:
        icon = UIImage(imageLiteralResourceName: "FundingPostDetail-CrowdFundingWithRewardIcon")
      case .commercial:
        return nil
      case .goods:
        return nil
      }
      
      guard let fundingCampaign = post.fundingCampaign else {
        return nil
      }
      
      title = fundingCampaign.campaignTitle
      tags = fundingCampaign.campaignTags
    }
  }
  
  struct FundingPostDetailProgressStatusViewModel: FundingPostDetailProgressStatusViewModelProtocol {
    let raisedPerCent: String
    let campaignProgress: Double
    let raisedAmount: String
    let goalAmount: String
    
    init?(post: PostingProtocol) {
      guard let funding = post.fundingCampaign else {
        return nil
      }
      
      campaignProgress = min(1.0, funding.campaignCollectedAmount / funding.campaignGoalAmount)
      let percent = 100.0 * (funding.campaignCollectedAmount / funding.campaignGoalAmount)
      
      raisedPerCent = "\(String(format:"%.0f", percent))%"
      raisedAmount = String(format:"%.0f %@", funding.campaignCollectedAmount, funding.fundingCurrency.symbol)
      goalAmount = String(format:"%.0f %@", funding.campaignGoalAmount, funding.fundingCurrency.symbol)
    }
  }
  
  struct FundingPostDetailTimeProgressStatusViewModel: FundingPostDetailTimeProgressStatusViewModelProtocol {
    static let startDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM, d yyyy"
      return formatter
    }()
    
    let startedDate: String
    let campaignProgress: Double
    let endDate: String
    
    init?(post: PostingProtocol) {
      guard let funding = post.fundingCampaign else {
        return nil
      }
      
      startedDate = FundingPostDetailTimeProgressStatusViewModel.startDateFormatter.string(from: funding.campaignStartDate)
      
      if funding.campaignEndDate.hasPassed {
        campaignProgress = 1.0
        endDate = Strings.CampaignTime.finished.localize()
      } else {
        let intervalSinceStarted = abs(funding.campaignStartDate.timeIntervalSinceNow)
        let intervalTillEnd = abs(funding.campaignEndDate.timeIntervalSinceNow)
        let days = floor(intervalTillEnd / TimeInterval.daysInterval(1))
         
        endDate = Strings.CampaignTime.finishesInDays.localize(value: String(format: "%.0f", days))
        campaignProgress = intervalSinceStarted / (intervalSinceStarted + intervalTillEnd)
      }
    }
  }
  
  struct FundingPostDetailContributorsInfoViewModel: FundingPostDetailContributorsInfoViewModelProtocol {
    var contributorsCount: String
    
    init?(post: PostingProtocol) {
      guard let funding = post.fundingCampaign else {
        return nil
      }
      
      switch post.postingType {
      case .media:
        return nil
      case .funding:
        contributorsCount = Strings.Donators.crowdfunding(value: funding.campaignDonatorsCount)
      case .charity:
        contributorsCount = Strings.Donators.charity(value: funding.campaignDonatorsCount)
      case .crowdfundingWithReward:
        contributorsCount = Strings.Donators.crowdfundingWithReward(value: funding.campaignDonatorsCount)
      case .commercial:
        return nil
      case .goods:
        return nil
      }
    }
  }
  
  struct FundingPostDetailTeamViewModel: FundingPostDetailTeamViewModelProtocol {
    let teamName: String
    let teamInfo: String
    
    init?(post: PostingProtocol) {
      guard let fundingTeam = post.fundingCampaignTeam else {
        return nil
      }
      
      teamName = fundingTeam.teamTitle
      teamInfo = "\(fundingTeam.teamMembersCount)"
    }
  }

  struct FundingPostDetailRewardsInfoItemViewModel: FundingPostDetailRewardsInfoItemViewModelProtocol {
    let rewardTitle: String
    let rewardsPrice: String
    let rewardAmount: String
    let isSelected: Bool
    
    init(reward: FundingRewardProtocol,
         rewardType:  FundingCampaignRewardsType,
         rewardState: FundingCampaignRewardsActivityState,
         donatedForReward: Int,
         fundingCurrency: BalanceCurrency) {
      
      self.isSelected = rewardState == .active
      
      rewardsPrice = "\(String(format: "%.0f", reward.rewardPrice)) \(fundingCurrency.symbol)"
      rewardTitle = Strings.RewardTitle.rewardTitleFor(rewardType)
      
      switch rewardType {
      case .regular:
        switch rewardState {
        case .active:
          let donated = Strings.DonatedCountTitle.crowdfundingWithReward.localize(value: "\(donatedForReward)")
          rewardAmount = Strings.RewardAmount.Active.unlimited.localize(value: donated)
        case .passed:
          let donated = Strings.DonatedCountTitle.crowdfundingWithReward.localize(value: "\(donatedForReward)")
          rewardAmount = Strings.RewardAmount.Passed.unlimited.localize(value: donated)
        case .upcoming:
          rewardAmount = Strings.RewardAmount.Upcoming.unlimited.localize()
        }
     
      case .discount, .earlyBird:
        switch rewardState {
        case .active:
          let leftCount = reward.rewardsLeftAmount ?? 0
          let leftString = Strings.DonatedCountLeftTitle.left.localize(value: "\(leftCount)")
          let amountString = "\(reward.rewardAmount ?? 0)"
          
          rewardAmount = Strings.RewardAmount.Active.limited.localize(values: [amountString, leftString])
        case .passed:
          let amountString = "\(reward.rewardAmount ?? 0)"
          rewardAmount = Strings.RewardAmount.Passed.limited.localize(value: amountString)
        case .upcoming:
          let amountString = "\(reward.rewardAmount ?? 0)"
          rewardAmount = Strings.RewardAmount.Upcoming.limited.localize(value: amountString)
        }
      }
    }
  }
  
  struct FundingPostDetailRewardsInfoViewModel: FundingPostDetailRewardsInfoViewModelProtocol  {
    let rewards: [FundingPostDetailRewardsInfoItemViewModelProtocol]
    
    init?(post: PostingProtocol) {
      guard let campaign = post.fundingCampaign, let campaignRewards = campaign.campaignRewards else {
        return nil
      }
      
      switch post.postingType {
      case .media:
        return nil
      case .funding:
        return nil
      case .charity:
        return nil
      case .crowdfundingWithReward:
        break
      case .commercial:
        return nil
      case .goods:
        return nil
      }
      
      let totalDonateCount = campaign.campaignDonatorsCount
      
      rewards = [
        (campaignRewards.earlyBirdReward, FundingCampaignRewardsType.earlyBird),
        (campaignRewards.discountReward, FundingCampaignRewardsType.discount),
        (campaignRewards.regularReward, FundingCampaignRewardsType.regular)
      ].map {
          let donatedForReward = campaignRewards.donatedForReward($0.1, totalDonateCount: totalDonateCount)
          return FundingPostDetailRewardsInfoItemViewModel(reward: $0.0,
                                                   rewardType: $0.1,
                                                   rewardState: campaignRewards.currentRewardState($0.1),
                                                   donatedForReward: donatedForReward,
                                                   fundingCurrency: campaign.fundingCurrency)
          
      }
      
    }
  }
  
  struct FundingPostDetailFinishStatsViewModel: FundingPostDetailFinishStatsViewModelProtocol {
    static let endDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM, d yyyy"
      return formatter
    }()
    
    let goal: String
    let raised: String
    let finishDate: String
    
    init?(post: PostingProtocol, presentationType: FundingPostDetail.PresentationType) {
      guard post.isMyPosting else {
        return nil
      }
      
      guard let campaign = post.fundingCampaign else {
        return nil
      }
      
      switch campaign.campaignStatus {
      case .succeeded, .failed:
        break
      case .processing:
        return nil
      case .unsupportedStatus:
        return nil
      }
      
      let goalAmount = String(format:"%.0f %@", campaign.campaignGoalAmount, campaign.fundingCurrency.symbol)
      goal = Strings.FundraisingFinishStats.goal.localize(value: goalAmount)
      
      let percent = 100.0 * (campaign.campaignCollectedAmount / campaign.campaignGoalAmount)
      
      let raisedPerCent = "(\(String(format:"%.0f", percent))%)"
      let raisedAmount = String(format:"%.0f %@", campaign.campaignCollectedAmount, campaign.fundingCurrency.symbol)
      
      raised = Strings.FundraisingFinishStats.raised.localize(values: [raisedAmount, raisedPerCent])
      finishDate =  FundingPostDetailFinishStatsViewModel.endDateFormatter.string(from: campaign.campaignEndDate)
    }
  }
  
  struct FundingPostDetailCampaignFinishViewModel: FundingPostDetailCampaignFinishViewModelProtocol {
    let isExtended: Bool
    
    let iconImage: UIImage?
    let message: String
    
    static func emptyExtended() -> FundingPostDetailCampaignFinishViewModel{
      return FundingPostDetailCampaignFinishViewModel(iconImage: nil, message: "", isExtended: true)
    }
    
    static func empty() -> FundingPostDetailCampaignFinishViewModel{
      return FundingPostDetailCampaignFinishViewModel(iconImage: nil, message: "", isExtended: false)
    }
    
    init(iconImage: UIImage?, message: String, isExtended: Bool) {
      self.iconImage = iconImage
      self.message = message
      self.isExtended = isExtended
    }
    
    init?(post: PostingProtocol, currentUser: UserProtocol, presentationType: FundingPostDetail.PresentationType) {
      isExtended = true
      guard let campaign = post.fundingCampaign else {
        return nil
      }
      
      switch presentationType {
      case .defaultPresentation:
        switch campaign.campaignStatus {
        case .succeeded:
          iconImage = UIImage(imageLiteralResourceName: "FundingPostDetail-CampaignFinishedSuccess")
          message = ""
        case .failed:
          iconImage = UIImage(imageLiteralResourceName: "FundingPostDetail-CampaignFailed")
          message = Strings.CampaignFinishMessage.failed.localize()
        case .processing:
          return nil
        case .unsupportedStatus:
          return nil
        }
      case .presentationWithControls:
        guard post.isMyPosting && (campaign.campaignOwnerIdentifier == currentUser.identifier) else {
          switch campaign.campaignStatus {
          case .succeeded:
            iconImage = UIImage(imageLiteralResourceName: "FundingPostDetail-CampaignFinishedSuccess")
            message = ""
          case .failed:
            iconImage = UIImage(imageLiteralResourceName: "FundingPostDetail-CampaignFailed")
            message = Strings.CampaignFinishMessage.failed.localize()
          case .processing:
            return nil
          case .unsupportedStatus:
            return nil
          }
          
          return
        }
        
        switch campaign.campaignStatus {
        case .succeeded:
          iconImage = UIImage(imageLiteralResourceName: "FundingPostDetail-CampaignFinishedSuccess")
          message = ""
        case .failed:
          iconImage = UIImage(imageLiteralResourceName: "FundingPostDetail-CampaignFailed")
          message = Strings.CampaignFinishMessage.failed.localize()
        case .processing:
          guard campaign.reachedGoal else {
            return nil
          }
          
          iconImage = UIImage(imageLiteralResourceName: "FundingPostDetail-CampaignCanBeFinished")
          message = Strings.CampaignFinishMessage.reachedGoal.localize()
        case .unsupportedStatus:
          return nil
        }
      }
    }
  }
  
  enum FundingPostDetailActionButtonViewModel: FundingPostDetailActionButtonViewModelProtocol {
    case donate
    case closeCampaign
    
    init?(post: PostingProtocol, currentUser: UserProtocol, presentationType: FundingPostDetail.PresentationType) {
      guard let campaign = post.fundingCampaign else {
        return nil
      }
      
      switch presentationType {
      case .defaultPresentation:
        guard !post.isMyPosting && !(campaign.campaignOwnerIdentifier == currentUser.identifier) else {
          return nil
        }
        
        switch campaign.campaignStatus {
        case .succeeded:
          return nil
        case .failed:
          return nil
        case .processing:
          self = .donate
        case .unsupportedStatus:
          return nil
        }
      case .presentationWithControls:
        guard post.isMyPosting && (campaign.campaignOwnerIdentifier == currentUser.identifier) else {
          return nil
        }
        
        switch campaign.campaignStatus {
        case .succeeded:
          return nil
        case .failed:
          return nil
        case .processing:
          guard campaign.canBeClosed else {
            return nil
          }
          
          self = .closeCampaign
        case .unsupportedStatus:
          return nil
        }
      }
    }
    
    var title: String {
      switch self {
      case .donate:
        return Strings.FundingActions.donate.localize()
      case .closeCampaign:
        return Strings.FundingActions.closeCampaign.localize()
      }
    }
    
    var action: FundingPostDetail.Actions {
      switch self {
      case .donate:
        return .donate
      case .closeCampaign:
        return .stopCampaign
      }
    }
    
  }
}


extension FundingPostDetail {
  enum Strings {
    enum CampaignTime: String, LocalizedStringKeyProtocol {
      case finished = "Ended"
      case finishesInDays = "End Date (d-%)"
    }
    
    enum RewardTitle: String, LocalizedStringKeyProtocol {
      case regular = "Regular Price"
      case earlyBird = "Super Early Bird"
      case discount =  "Early Bird"
      
      static func rewardTitleFor(_ type: FundingCampaignRewardsType) -> String {
        switch type {
        case .regular:
          return RewardTitle.regular.localize()
        case .earlyBird:
          return RewardTitle.earlyBird.localize()
        case .discount:
          return RewardTitle.discount.localize()
        }
        
      }
    }
    
    enum RewardAmount {
      enum Active: String, LocalizedStringKeyProtocol {
        case unlimited = "Unlimited (%)"
        case limited = "Limited % (%)"
      }
      
      enum Upcoming: String, LocalizedStringKeyProtocol  {
        case unlimited = "Unlimited"
        case limited = "Limited %"
      }
      
      enum Passed: String, LocalizedStringKeyProtocol  {
        case unlimited = "Unlimited (%)"
        case limited = "Limited % (Sold out)"
      }
    }
    
    enum DonatedCountTitle: String, LocalizedStringKeyProtocol {
      case charity = "% Donated"
      case crowdfunding = "% Contributed"
      case crowdfundingWithReward = "% Pladged"
    }
    
    enum DonatedCountLeftTitle: String, LocalizedStringKeyProtocol {
      case left = "% left"
    }
    
    enum FundraisingFinishStats: String, LocalizedStringKeyProtocol {
      case goal = "Initial fundraising goal: %"
      case raised = "Funds raised: % %"
      case endDate = "Ended: %"
    }
    
    enum CampaignFinishMessage: String, LocalizedStringKeyProtocol {
      case failed = "Sorry! \nThis funding campaign failed because the campaign did not reach 30% of the funding goal. All funds raised will be returned to the participants."
      case reachedGoal = "Congratulations! \nYour campaign has already reached the goal, so you can close your campaign now. Or continue funding until the remaining date."
    }
    
    enum FundingActions: String, LocalizedStringKeyProtocol  {
      case donate = "Funding this campaign"
      case closeCampaign = "Close Campaign"
    }
    
    enum Donators {
      enum Plural: String, LocalizedStringKeyProtocol   {
        case charity = "% donators"
        case crowdfunding = "% contributors"
        case crowdfundingWithReward = "% backers"
      }
      
      enum Single: String, LocalizedStringKeyProtocol   {
        case charity = "% donator"
        case crowdfunding = "% contributor"
        case crowdfundingWithReward = "% backer"
      }
      
      static func charity(value: Int) -> String {
        guard value > 1 else {
          return Single.charity.localize(value: "\(value)")
        }
        
        return Plural.charity.localize(value: "\(value)")
      }
      
      static func crowdfunding(value: Int) -> String {
        guard value > 1 else {
          return Single.crowdfunding.localize(value: "\(value)")
        }
        
        return Plural.crowdfunding.localize(value: "\(value)")
      }
      
      static func crowdfundingWithReward(value: Int) -> String {
        guard value > 1 else {
          return Single.crowdfundingWithReward.localize(value: "\(value)")
        }
        
        return Plural.crowdfundingWithReward.localize(value: "\(value)")
      }
    }
  }
}
