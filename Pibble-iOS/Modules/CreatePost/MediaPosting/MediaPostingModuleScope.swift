//
//  MediaPostingModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 13.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias MediaPostingItemFetchCompletion = (MediaPostingMediaAttachmentViewModelProtocol, IndexPath) -> Void
typealias MediaPostingMediaItemFetchRequest = (IndexPath, ImageRequestConfig, @escaping MediaPostingItemFetchCompletion) -> Void


enum MediaPosting {
 
  enum DescriptionPickActions {
    case beginEditing
    case changeText(String)
    case endEditing
  }
  
  enum FundingEditActions {
    case campaignPickTypeSelectionChanged(isSelected: Bool)
  }
  
  enum AttachedInformationInputs: Int {
    case mediaItems
    case description
    case location
    case tags
    case promotion
    
    case joinCampaignSectionHeader
    case charityCampaignCreation
    case crowdfundingCampaignCreation
    case joinCampaignSectionFooter
    case preselectedFundingTeam
    
    case charityCampaignPick
    case crowdfundingCampaignPick
    
    case commerceHeaderItem
    case digitanGoodToggle
    case downloadableToggle
    case digitalGoodLicensing
    case digitalGoodAgreement
    
    case commerceTitle
    case commercePrice
    case commerceReward
    
    case goodsEscrowAgreement
    case isNewGood
    case goodsUrl
    
    case descriptionPick
  }
  
  enum CommerceEditActions {
    case titleChanged(String)
    case titleEndEditing
    case priceChanged(String)
    case priceEndEditing
    
    case digitalGoodToggleChanged(Bool)
    
    case commercialUseChanged(Bool)
    case editorialUseChanged(Bool)
    case royaltyFreeUseChanged(Bool)
    case exclusiveUseChanged(Bool)
    case isDownloadableChanged(Bool)
    
    case userAgreeToTermsChanged(Bool)
    case userAgreeToTermsOfResponsibilityChanged(Bool)
    
    case userAgreeToTermsOfGoodsEscrowChanged(Bool)
    case isNewGoodChanged(Bool)
    case goodsUrlChanged(String)
    case goodsUrlEndEditing
    
    case goodDescriptionBeginEditing
    case goodDescriptionChangeText(String)
    case goodDescriptionEndEditing
  }
  
  
  typealias PostingCommerceEditActionsHandler = (UITableViewCell, MediaPosting.CommerceEditActions) -> Void
 
  enum AttachedMediaViewModelType {
    case image(MediaPostingMediaItemFetchRequest)
  }
  
  struct AttachedMediaItemViewModel: MediaPostingMediaAttachmentViewModelProtocol {
    let image: UIImage
  }
  
  enum AttachmentViewModel {
    case mediaItems(MediaPostingAttachedMediaViewModelProtocol)
    case description(MediaPostingDesctiptionViewModelProtocol)
    case location(MediaPostingLocationViewModelProtocol)
    case tags(MediaPostingTagsViewModelProtocol)
    case promotion(MediaPostingPromotionViewModelProtocol)
    case joinCampaignSectionHeader
    case createCampaign(MediaPostingCampaignViewModelProtocol)
    case pickCampaign(MediaPostingCampaignViewModelProtocol)
    case joinCampaignSectionFooter
    
    case commerceHeaderItem
    case digitanGoodToggle(MediaPostingDigitalGoodToggleViewModelProtocol)
    case digitalGoodLicensing(MediaPostingDigitalGoodLicensingViewModelProtocol)
    case digitalGoodAgreement(MediaPostingDigitalGoodAgreementViewModelProtocol)
    case commerceTitle(MediaPostingCommerceTitleViewModelProtocol)
    case commercePrice(MediaPostingCommercePriceViewModelProtocol)
    case commerceReward(MediaPostingCommerceRewardViewModelProtocol)
    case downloadableToogle(MediaPostingDigitalGoodDownloadableToggleViewModelProtocol)
    
    case goodsEscrowAgreement(MediaPostingGoodsEscrowAgreementViewModelProtocol)
    case isNewGoodToggle(MediaPostingGoodIsNewToggleViewModelProtocol)
    case goodsUrl(MediaPostingGoodUrlViewModelProtocol)
    case goodDescription(MediaPostingGoodDescriptionViewModelProtocol)
    
    case preselectedFundingTeam(MediaPostingPreselectedFundingCmapaignViewModelProtocol)
  }
  
  struct DescriptionViewModel {
    let attribute: PostAttributesProtocol
  }
  
  struct LocationViewModel {
    let location: SearchLocationProtocol?
  }
  
  struct TagsViewModel {
    let tags: [String]
  }
  
  struct PromotionViewModel: MediaPostingPromotionViewModelProtocol {
    let title: String
    let promotionPicked: Bool
    let promotionBudget: String
    
    init(createPromotion: CreatePromotionProtocol?) {
      title = "Promotion"
      guard let promotion = createPromotion else {
        promotionBudget = ""
        promotionPicked = false
        return
      }
      
      promotionPicked = true
      promotionBudget = "\(String(format:"%.0f", promotion.budget)) \(promotion.currency.symbol.uppercased())"
    }
  }
  
  struct CreateCampaignViewModel: MediaPostingCampaignViewModelProtocol {
    let title: String
    let isSelected: Bool
    
    init(fundingCampaignDraftType: FundingCampaignDraftType?) {
      title = MediaPosting.Strings.PickCampaign.create.localize()
      
      guard fundingCampaignDraftType == .createNew else {
        isSelected = false
        return
      }
      
      isSelected = true
    }
  }
  
  struct PickCampaignViewModel: MediaPostingCampaignViewModelProtocol {
    let title: String
    let isSelected: Bool
    
    init(fundingCampaignDraftType: FundingCampaignDraftType?) {
      title = MediaPosting.Strings.PickCampaign.find.localize()
      
      guard fundingCampaignDraftType == .joinExisting else {
        isSelected = false
        return
      }
      
      isSelected = true
    }
  }
  
  struct MediaPostingDigitalGoodToggleViewModel: MediaPostingDigitalGoodToggleViewModelProtocol {
    let isSelected: Bool
    
    init(attributes: DigitalGoodPostAttributesProtocol?) {
      isSelected = attributes != nil
    }
  }
  
  struct MediaPostingDigitalGoodDownloadableToggleViewModel: MediaPostingDigitalGoodDownloadableToggleViewModelProtocol {
    let isSelected: Bool
    
    init(attributes: DigitalGoodPostAttributesProtocol?) {
      isSelected = attributes?.isDownloadable ?? false
    }
  }
  
  struct MediaPostingDigitalGoodLicensingViewModel: MediaPostingDigitalGoodLicensingViewModelProtocol  {
    let commercialUseAllowed: Bool
    let editorialUseAllowed: Bool
    let royaltyFreeUseAllowed: Bool
    let exclusiveUseAllowed: Bool
    
    init(attributes: DigitalGoodPostAttributesProtocol?) {
      commercialUseAllowed = attributes?.isCommerial ?? false
      editorialUseAllowed = attributes?.isEditorialUseAvailable ?? false
      royaltyFreeUseAllowed = attributes?.isRoyaltyFree ?? false
      exclusiveUseAllowed = attributes?.isExclusive ?? false
    }
  }
  
  struct MediaPostingDigitalGoodAgreementViewModel: MediaPostingDigitalGoodAgreementViewModelProtocol {
    let hasUserAgreedToTerms: Bool
    let hasUserAgreedToTermsOfResponsibility: Bool
    
    init(attributes: DigitalGoodPostAttributesProtocol?) {
      hasUserAgreedToTerms = attributes?.hasUserAgreedToTerms ?? false
      hasUserAgreedToTermsOfResponsibility = attributes?.hasUserAgreedToTermsOfResponsibility ?? false
    }
  }
  
  struct MediaPostingGoodsEscrowAgreementViewModel: MediaPostingGoodsEscrowAgreementViewModelProtocol {
    let hasUserAgreedToTerms: Bool
    
    init(attributes: GoodsPostDraftAttributesProtocol?) {
      hasUserAgreedToTerms = attributes?.hasUserAgreedToEscrowTerms ?? false
    }
  }
  
  struct MediaPostingGoodIsNewToggleViewModel: MediaPostingGoodIsNewToggleViewModelProtocol {
    let isSelected: Bool
    
    init(attributes: GoodsPostDraftAttributesProtocol?) {
      isSelected = attributes?.isNew ?? false
    }
  }
  
  struct MediaPostingGoodDescription: MediaPostingGoodDescriptionViewModelProtocol {
    let text: String
    
    init(attributes: GoodsPostDraftAttributesProtocol?) {
      text = attributes?.goodsDescription ?? ""
    }
    
    init(postCaption: String) {
      text = postCaption
    }
  }
  
  struct MediaPostingGoodUrlViewModel: MediaPostingGoodUrlViewModelProtocol {
    let urlString: String
    let shouldPresentUrlValidationImage: Bool
    let urlStringValidationImage: UIImage?
    
    init(attributes: GoodsPostDraftAttributesProtocol?) {
      urlString = attributes?.url ?? ""
      
      shouldPresentUrlValidationImage = urlString.count > 0
      urlStringValidationImage = urlString.isValidUrl ?
        UIImage(imageLiteralResourceName: "MediaPosting-UrlCheck"): UIImage(imageLiteralResourceName: "MediaPosting-UrlCheck-fail")
    }
  }
  
  struct MediaPostingCommercePriceViewModel: MediaPostingCommercePriceViewModelProtocol {
    let amount: String
    
    init(attributes: CommercePostDraftAttributesProtocol?) {
      guard let price = attributes?.price else {
        amount = ""
        return
      }
      
      amount = String(format:"%.0f", price)
    }
    
    init(price: Double?) {
      guard let price = price else {
        amount = ""
        return
      }
      
      amount = String(format:"%.0f", price)
    }
  }
  
  struct MediaPostingCommerceTitleViewModel: MediaPostingCommerceTitleViewModelProtocol {
    var title: String
    
    init(attributes: CommercePostDraftAttributesProtocol?) {
      title = attributes?.title ?? ""
    }
    
    init(title: String?) {
      self.title = title ?? ""
    }
  }
  
  struct MediaPostingCommerceRewardViewModel: MediaPostingCommerceRewardViewModelProtocol {
    var amount: String
    
    init(attributes: CommercePostDraftAttributesProtocol?) {
      guard let rewardRate = attributes?.rewardRate else {
        amount = ""
        return
      }
      
      amount = "\(String(format:"%.0f", rewardRate * 100))%"
    }
  }
  
  struct MediaPostingPreselectedFundingCmapaignViewModel: MediaPostingPreselectedFundingCmapaignViewModelProtocol {
    let teamTitle: String
    let campaignLogoPlaceholder: UIImage?
    
    let campaignLogoURLString: String
    let campaignTitle: String
    let campaignInfo: NSAttributedString
    let campaignGoals: NSAttributedString
    let isSelected: Bool
    let selectedItemImage: UIImage
    
    init(fundingCamgaignTeam: FundingCampaignTeamProtocol?, isSelected: Bool = true) {
      self.isSelected = isSelected
      selectedItemImage = UIImage(imageLiteralResourceName: "CampaignPick-CampaignTeamSelection")
      
      guard let fundingCamgaignTeam = fundingCamgaignTeam else {
        teamTitle = ""
        campaignLogoPlaceholder = nil
        campaignLogoURLString = ""
        campaignTitle = ""
        campaignInfo = NSAttributedString(string: "",
                                          attributes: [:])
        campaignGoals = NSAttributedString(string: "",
                                           attributes: [:])
        return
      }
      
      campaignLogoPlaceholder = UIImage.avatarImageForTitleString(fundingCamgaignTeam.teamTitle)
      campaignLogoURLString = fundingCamgaignTeam.teamLogoUrlString
      campaignTitle = fundingCamgaignTeam.fundingCampaign?.campaignTitle ?? ""
      
      teamTitle = fundingCamgaignTeam.teamTitle
      
      let raise = String(format:"%.0f", fundingCamgaignTeam.fundingCampaign?.campaignCollectedAmount ?? 0.0)
      let goal = String(format:"%.0f", fundingCamgaignTeam.fundingCampaign?.campaignGoalAmount ?? 0.0)
      let currency = CampaignPick.Strings.currency.localize()
      let campaignGoalsString = "\(CampaignPick.Strings.raise.localize()): \(raise) \(currency) \(CampaignPick.Strings.goal.localize()) \(goal) \(currency)"
      
      campaignGoals =  NSAttributedString(string: campaignGoalsString,
                                          attributes: [
                                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 12.0),
                                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.fundinCampaignInfo
        ])
      
      var createdAtString = ""
      
      if let date = fundingCamgaignTeam.fundingCampaign?.campaignStartDate {
        let dateString = Date.campaignDateFormat.string(from: date)
        createdAtString = "\(CampaignPick.Strings.createdAt.localize()) \(dateString)"
      }
      
      let members = fundingCamgaignTeam.teamMembersCount
      let fundinCampaignInfoString = "\(CampaignPick.Strings.members.localize()): \(members) \(createdAtString)"
      
      campaignInfo =  NSAttributedString(string: fundinCampaignInfoString,
                                         attributes: [
                                          NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 12.0),
                                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.fundinCampaignInfo
        ])
    }
  }
}


fileprivate enum UIConstants {
  enum Colors {
    static let fundinCampaignInfo = UIColor.gray84
  }
}

extension Date {
  fileprivate static let campaignDateFormat: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    return dateFormatter
  }()
  
}
