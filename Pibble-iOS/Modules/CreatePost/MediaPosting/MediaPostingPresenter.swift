//
//  MediaPostingPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 13.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - MediaPostingPresenter Class
final class MediaPostingPresenter: Presenter {
  fileprivate enum Sections: Int {
    case mediaSection
    case commonInputsSection
    case commercialHeaderSection
    case digitalGoodsToggleSection
    case digitalGoodsSettingsSection
    case commercialTitleInputsSection
    case commercialPriceInputsSection
    case goodsSections
    case preselectedFundingTeams
  }

  fileprivate var sections: [(section: Sections, items: [MediaPosting.AttachedInformationInputs])] = []
  fileprivate lazy var postingStage: CreationStages = {
    switch interactor.postingDraft.draftPostType {
    case .media:
      return CreationStages(stages: [.commonInputs])
    case .charity, .crowdfunding, .crowdfundingWithReward:
      guard interactor.postingDraft.joinExistingCampaignTeamInPlace else {
        return CreationStages(stages: [.commonInputs, .specificInputs])
      }
      
      return CreationStages(stages: [.commonInputs])
    case .digitalGood:
      return CreationStages(stages: [.commonInputs, .specificInputs])
    case .goods:
      return CreationStages(stages: [.commonInputs, .specificInputs])
    }
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sections = sectionsForPostingType(interactor.postingDraft.draftPostType)
    interactor.beginPreUploadingTask()
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
    let title = MediaPosting.Strings.titleForPostingType(interactor.postingDraft.draftPostType)
    viewController.setTitle(title)
  }
}

// MARK: - MediaPostingPresenter API
extension MediaPostingPresenter: MediaPostingPresenterApi {
  func handleFundingEditActionAt(_ indexPath: IndexPath, action: MediaPosting.FundingEditActions) {
    let inputType = sections[indexPath.section].items[indexPath.item]
    
    switch action {
    case .campaignPickTypeSelectionChanged(_):
      switch inputType {
      case .mediaItems:
        break
      case .description:
        break
      case .location:
        break
      case .tags:
        break
      case .promotion:
        break
      case .joinCampaignSectionHeader, .joinCampaignSectionFooter:
        break
      case .charityCampaignCreation:
        switch interactor.postingDraft.draftPostType {
        case .media:
          break
        case .charity:
          interactor.postingDraft.fundingCampaignDraftType = .createNew
        case .crowdfunding, .crowdfundingWithReward:
          interactor.postingDraft.fundingCampaignDraftType = .createNew
        case .digitalGood:
          break
        case .goods:
          break
        }
        
        viewController.updateCollection(.beginUpdates)
        viewController.updateCollection(.updateSections(idx: [indexPath.section]))
        viewController.updateCollection(.endUpdates)
      case .crowdfundingCampaignCreation:
        switch interactor.postingDraft.draftPostType {
        case .media:
          break
        case .charity:
          interactor.postingDraft.fundingCampaignDraftType = .createNew
        case .crowdfunding, .crowdfundingWithReward:
          interactor.postingDraft.fundingCampaignDraftType = .createNew
        case .digitalGood:
          break
        case .goods:
          break
        }
        
        viewController.updateCollection(.beginUpdates)
        viewController.updateCollection(.updateSections(idx: [indexPath.section]))
        viewController.updateCollection(.endUpdates)
      case .charityCampaignPick:
        switch interactor.postingDraft.draftPostType {
        case .media:
          break
        case .charity:
          interactor.postingDraft.fundingCampaignDraftType = .joinExisting
        case .crowdfunding, .crowdfundingWithReward:
          interactor.postingDraft.fundingCampaignDraftType = .joinExisting
        case .digitalGood:
          break
        case .goods:
          break
        }
        
        viewController.updateCollection(.beginUpdates)
        viewController.updateCollection(.updateSections(idx: [indexPath.section]))
        viewController.updateCollection(.endUpdates)
      case .crowdfundingCampaignPick:
        switch interactor.postingDraft.draftPostType {
        case .media:
          break
        case .charity:
          interactor.postingDraft.fundingCampaignDraftType = .joinExisting
        case .crowdfunding, .crowdfundingWithReward:
          interactor.postingDraft.fundingCampaignDraftType = .joinExisting
        case .digitalGood:
          break
        case .goods:
          break
        }
        
        viewController.updateCollection(.beginUpdates)
        viewController.updateCollection(.updateSections(idx: [indexPath.section]))
        viewController.updateCollection(.endUpdates)
      case .commerceHeaderItem:
        break
      case .digitanGoodToggle:
        break
      case .downloadableToggle:
        break
      case .digitalGoodLicensing:
        break
      case .digitalGoodAgreement:
        break
      case .commerceTitle:
        break
      case .commercePrice:
        break
      case .commerceReward:
        break
      case .goodsEscrowAgreement:
        break
      case .isNewGood:
        break
      case .goodsUrl:
        break
      case .descriptionPick:
        break
      case .preselectedFundingTeam:
        break
      }
    }
    
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
  func handleCommercialEditAction(_ action: MediaPosting.CommerceEditActions) {
    switch action {
    case .titleChanged(let title):
      interactor.postingDraft.title = title
    case .titleEndEditing:
      viewController.updateCollection(.beginUpdates)
      viewController.updateCollection(.updateSections(idx: [Sections.commercialTitleInputsSection.rawValue]))
      viewController.updateCollection(.endUpdates)
    case .priceChanged(let price):
      let price = Double(price)
      interactor.postingDraft.price = price
    case .priceEndEditing:
      viewController.updateCollection(.beginUpdates)
      viewController.updateCollection(.updateSections(idx: [Sections.commercialPriceInputsSection.rawValue]))
      viewController.updateCollection(.endUpdates)
    case .digitalGoodToggleChanged(_):
      //not handled
      break
    case .isDownloadableChanged(let isSelected):
      interactor.postingDraft.digitalGoodDraftAttributes.isDownloadable = isSelected
    case .commercialUseChanged(let isSelected):
      interactor.postingDraft.digitalGoodDraftAttributes.isCommerial = isSelected
    case .editorialUseChanged(let isSelected):
      interactor.postingDraft.digitalGoodDraftAttributes.isEditorialUseAvailable = isSelected
    case .royaltyFreeUseChanged(let isSelected):
      interactor.postingDraft.digitalGoodDraftAttributes.isRoyaltyFree = isSelected
    case .exclusiveUseChanged(let isSelected):
      interactor.postingDraft.digitalGoodDraftAttributes.isExclusive = isSelected
    case .userAgreeToTermsChanged(let isSelected):
      interactor.postingDraft.digitalGoodDraftAttributes.hasUserAgreedToTerms = isSelected
    case .userAgreeToTermsOfResponsibilityChanged(let isSelected):
      interactor.postingDraft.digitalGoodDraftAttributes.hasUserAgreedToTermsOfResponsibility = isSelected
    case .userAgreeToTermsOfGoodsEscrowChanged(let isSelected):
      interactor.postingDraft.goodDraftAttributes.hasUserAgreedToEscrowTerms = isSelected
    case .isNewGoodChanged(let isSelected):
      interactor.postingDraft.goodDraftAttributes.isNew = isSelected
    case .goodsUrlChanged(let urlString):
      interactor.postingDraft.goodDraftAttributes.url = urlString
    case .goodsUrlEndEditing:
      viewController.updateCollection(.beginUpdates)
      viewController.updateCollection(.updateSections(idx: [Sections.goodsSections.rawValue]))
      viewController.updateCollection(.endUpdates)
    case .goodDescriptionBeginEditing:
      break
    case .goodDescriptionChangeText(let description):
      switch postingStage.currentStage {
      case .commonInputs:
        interactor.postingDraft.postCaption = description
        viewController.updateCollection(.beginUpdates)
        viewController.updateCollection(.endUpdates)
      case .specificInputs:
        interactor.postingDraft.goodDraftAttributes.goodsDescription = description
        viewController.updateCollection(.beginUpdates)
        viewController.updateCollection(.endUpdates)
      }
    case .goodDescriptionEndEditing:
      switch postingStage.currentStage {
      case .commonInputs:
        viewController.updateCollection(.beginUpdates)
        viewController.updateCollection(.updateSections(idx: [Sections.commonInputsSection.rawValue]))
        viewController.updateCollection(.endUpdates)
      case .specificInputs:
        viewController.updateCollection(.beginUpdates)
        viewController.updateCollection(.updateSections(idx: [Sections.goodsSections.rawValue]))
        viewController.updateCollection(.endUpdates)
      }
    }
    
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
  func presentReload() {
    viewController.reloadTable()
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let input = sections[indexPath.section].items[indexPath.item]
    switch input {
    case .mediaItems:
      return
    case .description:
      return
    case .location:
      router.routeToLocationPick(self)
    case .tags:
      router.routeToTagPick(self)
    case .promotion:
      router.routeToPromotionPick(self)
    case .charityCampaignCreation:
      switch interactor.postingDraft.draftPostType {
      case .media:
        break
      case .charity:
        interactor.postingDraft.fundingCampaignDraftType = .createNew
//        router.routeToCampaignEdit(interactor.postingDraft, campaignType: .charity)
      case .crowdfunding, .crowdfundingWithReward:
        interactor.postingDraft.fundingCampaignDraftType = .createNew
//        router.routeToCampaignEdit(interactor.postingDraft, campaignType: .crowdfunding)
      case .digitalGood:
        break
      case .goods:
        break
      }
    case .crowdfundingCampaignCreation:
      switch interactor.postingDraft.draftPostType {
      case .media:
        break
      case .charity:
        interactor.postingDraft.fundingCampaignDraftType = .createNew
//        router.routeToCampaignEdit(interactor.postingDraft, campaignType: .charity)
      case .crowdfunding, .crowdfundingWithReward:
        interactor.postingDraft.fundingCampaignDraftType = .createNew
//        router.routeToCampaignEdit(interactor.postingDraft, campaignType: .crowdfunding)
      case .digitalGood:
        break
      case .goods:
        break
      }
    case .charityCampaignPick:
      switch interactor.postingDraft.draftPostType {
      case .media:
        break
      case .charity:
        interactor.postingDraft.fundingCampaignDraftType = .joinExisting
//        router.routeToCampaignPick(interactor.postingDraft, campaignType: .charity)
      case .crowdfunding, .crowdfundingWithReward:
        interactor.postingDraft.fundingCampaignDraftType = .joinExisting
//        router.routeToCampaignPick(interactor.postingDraft, campaignType: .crowdfunding)
      case .digitalGood:
        break
      case .goods:
        break
      }
    case .crowdfundingCampaignPick:
      switch interactor.postingDraft.draftPostType {
      case .media:
        break
      case .charity:
        interactor.postingDraft.fundingCampaignDraftType = .joinExisting
//        router.routeToCampaignPick(interactor.postingDraft, campaignType: .charity)
      case .crowdfunding, .crowdfundingWithReward:
        interactor.postingDraft.fundingCampaignDraftType = .joinExisting
//        router.routeToCampaignPick(interactor.postingDraft, campaignType: .crowdfunding)
      case .digitalGood:
        break
      case .goods:
        break
      }
    case .joinCampaignSectionHeader, .joinCampaignSectionFooter:
      break
    case .commerceHeaderItem:
      break
    case .digitanGoodToggle:
      break
    case .downloadableToggle:
      break
    case .digitalGoodLicensing:
      break
    case .digitalGoodAgreement:
      break
    case .commerceTitle:
      break
    case .commercePrice:
      break
    case .commerceReward:
      break
    case .goodsEscrowAgreement:
      break
    case .isNewGood:
      break
    case .goodsUrl:
      break
    case .descriptionPick:
      break
    case .preselectedFundingTeam:
      break
    }
    
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
  func handleAddItemAction() {
    interactor.cancelPreUploadingTask()
    router.dismiss()
  }
  
  func handlePreviosStepAction() {
    guard postingStage.isFirstStage else {
      presentPrevStage()
      return
    }
    
    interactor.cancelPreUploadingTask()
    router.dismiss()
  }
  
  func presentNextStage() {
    postingStage.toNextStage()
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
    sections = sectionsForPostingType(interactor.postingDraft.draftPostType)
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: sections.enumerated().map { $0.offset }))
    viewController.updateCollection(.endUpdates)
  }
  
  func presentPrevStage() {
    postingStage.toPrevStage()
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
    sections = sectionsForPostingType(interactor.postingDraft.draftPostType)
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: sections.enumerated().map { $0.offset }))
    viewController.updateCollection(.endUpdates)
  }
  
  func handlePostAction() {
    guard postingStage.isLastStage else {
      presentNextStage()
      return
    }
    
    switch interactor.postingDraft.draftPostType {
    case .media, .goods, .digitalGood:
      interactor.performPosting()
      router.dismiss(withPop: false)
    case .charity:
      guard let fundingCampaignDraftType = interactor.postingDraft.fundingCampaignDraftType else {
        return
      }
      
      switch fundingCampaignDraftType {
      case .createNew:
        router.routeToCampaignEdit(interactor.postingDraft, campaignType: .charity)
      case .joinExisting:
        guard interactor.postingDraft.joinExistingCampaignTeamInPlace else {
          router.routeToCampaignPick(interactor.postingDraft, campaignType: .charity)
          return
        }
        
        interactor.performPosting()
        router.dismiss(withPop: false)
      }
    case .crowdfunding, .crowdfundingWithReward:
      guard let fundingCampaignDraftType = interactor.postingDraft.fundingCampaignDraftType else {
        return
      }
      
      switch fundingCampaignDraftType {
      case .createNew:
        router.routeToCampaignEdit(interactor.postingDraft, campaignType: .crowdfunding)
      case .joinExisting:
        guard interactor.postingDraft.joinExistingCampaignTeamInPlace else {
          router.routeToCampaignPick(interactor.postingDraft, campaignType: .crowdfunding)
          return
        }
        
        interactor.performPosting()
        router.dismiss(withPop: false)
      }
    }
  }
  
  func numberOfAttachmentSections() -> Int {
    return sections.count
  }
  
  func numberOfAttachmentsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func attachmentViewModelAt(_ indexPath: IndexPath) -> MediaPosting.AttachmentViewModel {
    let inputType = sections[indexPath.section].items[indexPath.item]
    
    switch inputType {
    case .mediaItems:
      return .mediaItems(self)
    case .description:
      let vm = MediaPosting.MediaPostingGoodDescription(postCaption: interactor.postingDraft.postCaption)
      return .goodDescription(vm)
    case .location:
      let vm = MediaPosting.LocationViewModel(location: interactor.postingDraft.place)
      return .location(vm)
    case .tags:
      let vm = MediaPosting.TagsViewModel(tags: interactor.postingDraft.tags)
      return .tags(vm)
    case .promotion:
      let vm = MediaPosting.PromotionViewModel(createPromotion: interactor.postingDraft.promotionDraft)
      return .promotion(vm)
    case .charityCampaignCreation:
      let vm = MediaPosting.CreateCampaignViewModel(fundingCampaignDraftType: interactor.postingDraft.fundingCampaignDraftType)
      return .createCampaign(vm)
    case .crowdfundingCampaignCreation:
      let vm = MediaPosting.CreateCampaignViewModel(fundingCampaignDraftType: interactor.postingDraft.fundingCampaignDraftType)
      return .createCampaign(vm)
    case .charityCampaignPick:
      let vm = MediaPosting.PickCampaignViewModel(fundingCampaignDraftType: interactor.postingDraft.fundingCampaignDraftType)
      return .pickCampaign(vm)
    case .crowdfundingCampaignPick:
      let vm = MediaPosting.PickCampaignViewModel(fundingCampaignDraftType: interactor.postingDraft.fundingCampaignDraftType)
      return .pickCampaign(vm)
    case .joinCampaignSectionHeader:
      return .joinCampaignSectionHeader
    case .joinCampaignSectionFooter:
      return .joinCampaignSectionFooter
    case .commerceHeaderItem:
      return .commerceHeaderItem
    case .digitanGoodToggle:
      let vm = MediaPosting.MediaPostingDigitalGoodToggleViewModel(attributes: interactor.postingDraft.digitalGoodDraftAttributes)
      return .digitanGoodToggle(vm)
    case .downloadableToggle:
      let vm = MediaPosting.MediaPostingDigitalGoodDownloadableToggleViewModel(attributes: interactor.postingDraft.digitalGoodDraftAttributes)
      return .downloadableToogle(vm)
    case .digitalGoodLicensing:
      let vm = MediaPosting.MediaPostingDigitalGoodLicensingViewModel(attributes: interactor.postingDraft.digitalGoodDraftAttributes)
      return .digitalGoodLicensing(vm)
    case .digitalGoodAgreement:
      let vm = MediaPosting.MediaPostingDigitalGoodAgreementViewModel(attributes: interactor.postingDraft.digitalGoodDraftAttributes)
      return .digitalGoodAgreement(vm)
    case .commerceTitle:
      let vm = MediaPosting.MediaPostingCommerceTitleViewModel(title: interactor.postingDraft.title)
      return .commerceTitle(vm)
    case .commercePrice:
      let vm = MediaPosting.MediaPostingCommercePriceViewModel(price: interactor.postingDraft.price)
      return .commercePrice(vm)
    case .commerceReward:
      let vm = MediaPosting.MediaPostingCommerceRewardViewModel(attributes: interactor.postingDraft.commerceDraftAttributes)
      return .commerceReward(vm)
    case .goodsEscrowAgreement:
      let vm = MediaPosting.MediaPostingGoodsEscrowAgreementViewModel(attributes: interactor.postingDraft.goodDraftAttributes)
      return .goodsEscrowAgreement(vm)
    case .isNewGood:
      let vm = MediaPosting.MediaPostingGoodIsNewToggleViewModel(attributes: interactor.postingDraft.goodDraftAttributes)
      return .isNewGoodToggle(vm)
    case .goodsUrl:
      let vm = MediaPosting.MediaPostingGoodUrlViewModel(attributes: interactor.postingDraft.goodDraftAttributes)
      return .goodsUrl(vm)
    case .descriptionPick:
      let vm = MediaPosting.MediaPostingGoodDescription(attributes: interactor.postingDraft.goodDraftAttributes)
      return .goodDescription(vm)
    case .preselectedFundingTeam:
      let vm = MediaPosting.MediaPostingPreselectedFundingCmapaignViewModel(fundingCamgaignTeam: interactor.postingDraft.joinExistingCampaignTeam)
      return .preselectedFundingTeam(vm)
    }
  }
}

//MARK:- MediaPostingItemsViewModelProtocol

extension MediaPostingPresenter: MediaPostingAttachedMediaViewModelProtocol {
  func numberOfMediaAttachmentSections() -> Int {
    return interactor.numberOfMediaAttachmentSections()
  }
  
  func numberOfMediaAttachmentsInSection(_ section: Int) -> Int {
    return interactor.numberOfMediaAttachmentsInSection(section)
  }
  
  func mediaAttachmentViewModelTypeAt(_ indexPath: IndexPath) -> MediaPosting.AttachedMediaViewModelType {
    let imagePostingItem = MediaPosting.AttachedMediaViewModelType.image(mediaPostingItemRequestForItemAt)
    return imagePostingItem
  }
  
  fileprivate func mediaPostingItemRequestForItemAt(_ indexPath: IndexPath, config: ImageRequestConfig, complete: @escaping MediaPostingItemFetchCompletion) {
    
    interactor.requestMediaAttachmentsPreviewFor(indexPath, config: config) { (image, idx) in
      let vm = MediaPosting.AttachedMediaItemViewModel(image: image ?? UIImage())
      complete(vm, idx)
    }
  }
}

// MARK: - MediaPosting Viper Components

fileprivate extension MediaPostingPresenter {
  var viewController: MediaPostingViewControllerApi {
    return _viewController as! MediaPostingViewControllerApi
  }
  var interactor: MediaPostingInteractorApi {
    return _interactor as! MediaPostingInteractorApi
  }
  var router: MediaPostingRouterApi {
    return _router as! MediaPostingRouterApi
  }
}

extension MediaPosting.DescriptionViewModel: MediaPostingDesctiptionViewModelProtocol {
  var title: String {
    guard attribute.postCaption.count > 0 else {
      return MediaPosting.Strings.Titles.description.localize()
     
    }
    
    return attribute.postCaption
  }
}

extension MediaPosting.LocationViewModel: MediaPostingLocationViewModelProtocol {
  var title: String {
    guard let location = location else {
      return MediaPosting.Strings.Titles.pickLocation.localize()
    }
    
    return location.locationTitle
  }
}

extension MediaPosting.TagsViewModel: MediaPostingTagsViewModelProtocol  {
  var title: String {
    guard tags.count > 0 else {
      return MediaPosting.Strings.Titles.pickTags.localize()
    }
    
    return tags
      .map{ return "#\($0)" }
      .joined(separator: " ")
  }
}

//MARK:- Helpers

extension MediaPostingPresenter {
  fileprivate var canBePosted: Bool {
    guard postingStage.isLastStage else {
      return true
    }
    
    switch interactor.postingDraft.draftPostType {
    case .media:
      return interactor.canBePosted
    case .goods:
      return interactor.canBePosted
    case .charity:
      return interactor.postingDraft.fundingCampaignDraftType != nil
    case .crowdfunding, .crowdfundingWithReward:
      return interactor.postingDraft.fundingCampaignDraftType != nil
    case .digitalGood:
      return interactor.canBePosted
    }
  }
  
  fileprivate var nextStepButtonTitle: String {
    switch interactor.postingDraft.draftPostType {
    case .media, .goods, .digitalGood:
      return postingStage.isLastStage ?
        MediaPosting.Strings.NavBarButtons.post.localize():
        MediaPosting.Strings.NavBarButtons.next.localize()
    case .charity, .crowdfunding, .crowdfundingWithReward:
      return postingStage.isLastStage && interactor.postingDraft.joinExistingCampaignTeamInPlace ?
          MediaPosting.Strings.NavBarButtons.post.localize():
          MediaPosting.Strings.NavBarButtons.next.localize()
    }
  }
  
  fileprivate func sectionsForPostingType(_ postingType: PostingType) -> [(section: Sections, items: [MediaPosting.AttachedInformationInputs])]  {
    let sections: [(section: Sections, items: [MediaPosting.AttachedInformationInputs])]
    
    switch postingType {
    case .media:
      sections = [(section: .mediaSection, items: [.mediaItems]),
                  (section: .commonInputsSection, items: [.description, .location, .tags]),
                  (section: .commercialHeaderSection, items: []),
                  (section: .digitalGoodsToggleSection, items: []),
                  (section: .digitalGoodsSettingsSection, items: []),
                  (section: .commercialTitleInputsSection, items: []),
                  (section: .commercialPriceInputsSection, items: []),
                  (section: .goodsSections, items: []),
                  (section: .preselectedFundingTeams, items: [])]
    case .charity:
      switch postingStage.currentStage {
      case .commonInputs:
        let fundingTeams: [MediaPosting.AttachedInformationInputs] =
          interactor.postingDraft.joinExistingCampaignTeamInPlace ? [.preselectedFundingTeam] : []
        
        sections = [(section: .mediaSection, items: [.mediaItems]),
                    (section: .commonInputsSection, items: [.description, .location, .tags]),
                    (section: .commercialHeaderSection, items: []),
                    (section: .digitalGoodsToggleSection, items: []),
                    (section: .digitalGoodsSettingsSection, items: []),
                    (section: .commercialTitleInputsSection, items: []),
                    (section: .commercialPriceInputsSection, items: []),
                    (section: .goodsSections, items: []),
                    (section: .preselectedFundingTeams, items: fundingTeams)]
      case .specificInputs:
        sections = [(section: .mediaSection, items: []),
                    (section: .commonInputsSection, items: [.joinCampaignSectionHeader,
                                                            .charityCampaignCreation,
                                                            .charityCampaignPick,
                                                            .joinCampaignSectionFooter]),
                    
                    (section: .commercialHeaderSection, items: []),
                    (section: .digitalGoodsToggleSection, items: []),
                    (section: .digitalGoodsSettingsSection, items: []),
                    (section: .commercialTitleInputsSection, items: []),
                    (section: .commercialPriceInputsSection, items: []),
                    (section: .goodsSections, items: []),
                    (section: .preselectedFundingTeams, items: [])]
      }
      
      
    case .crowdfunding, .crowdfundingWithReward:
      switch postingStage.currentStage {
      case .commonInputs:
        let fundingTeams: [MediaPosting.AttachedInformationInputs] =
          interactor.postingDraft.joinExistingCampaignTeamInPlace ? [.preselectedFundingTeam] : []
        
        sections = [(section: .mediaSection, items: [.mediaItems]),
                    (section: .commonInputsSection, items: [.description, .location, .tags]),
                    (section: .commercialHeaderSection, items: []),
                    (section: .digitalGoodsToggleSection, items: []),
                    (section: .digitalGoodsSettingsSection, items: []),
                    (section: .commercialTitleInputsSection, items: []),
                    (section: .commercialPriceInputsSection, items: []),
                    (section: .goodsSections, items: []),
                    (section: .preselectedFundingTeams, items: fundingTeams)
        ]
      case .specificInputs:
        sections = [
                    (section: .mediaSection, items: []),
                    (section: .commonInputsSection, items: [.joinCampaignSectionHeader,
                                                            .crowdfundingCampaignCreation,
                                                            .crowdfundingCampaignPick,
                                                            .joinCampaignSectionFooter]),
                    
                    (section: .commercialHeaderSection, items: []),
                    (section: .digitalGoodsToggleSection, items: []),
                    (section: .digitalGoodsSettingsSection, items: []),
                    (section: .commercialTitleInputsSection, items: []),
                    (section: .commercialPriceInputsSection, items: []),
                    (section: .goodsSections, items: []),
                    (section: .preselectedFundingTeams, items: [])
        ]
      }
      
    case .digitalGood:
      switch postingStage.currentStage {
      case .commonInputs:
        sections = [(section: .mediaSection, items: [.mediaItems]),
                    (section: .commonInputsSection, items: [.description, .location, .tags]),
                    (section: .commercialHeaderSection, items: []),
                    (section: .commercialTitleInputsSection, items: []),
                    (section: .commercialPriceInputsSection, items: []),
                    (section: .digitalGoodsToggleSection, items: []),
                    (section: .digitalGoodsSettingsSection, items: []),
                    (section: .goodsSections, items: []),
                    (section: .preselectedFundingTeams, items: [])
        ]
      case .specificInputs:
        sections = [
          (section: .mediaSection, items: []),
          (section: .commonInputsSection, items: []),
          (section: .commercialHeaderSection, items: []),
          (section: .commercialTitleInputsSection, items: [.commerceTitle]),
          (section: .commercialPriceInputsSection, items: [.commercePrice]),
          (section: .digitalGoodsToggleSection, items: [.downloadableToggle]),
          (section: .digitalGoodsSettingsSection, items: [.digitalGoodLicensing, .digitalGoodAgreement] ),
          (section: .goodsSections, items: []),
          (section: .preselectedFundingTeams, items: [])
        ]
      }
      
    case .goods:
      switch postingStage.currentStage {
      case .commonInputs:
        sections = [(section: .mediaSection, items: [.mediaItems]),
          (section: .commonInputsSection, items: [.description, .location, .tags]),
          (section: .commercialHeaderSection, items: []),
          (section: .digitalGoodsToggleSection, items: []),
          (section: .digitalGoodsSettingsSection, items: []),
          (section: .commercialTitleInputsSection, items: []),
          (section: .commercialPriceInputsSection, items: []),
          (section: .goodsSections, items: []),
          (section: .preselectedFundingTeams, items: [])
        ]
      case .specificInputs:
        sections = [
          (section: .mediaSection, items: []),
          (section: .commonInputsSection, items: []),
          (section: .commercialHeaderSection, items: []),
          (section: .digitalGoodsToggleSection, items: []),
          (section: .digitalGoodsSettingsSection, items: []),
          (section: .commercialTitleInputsSection, items: [.commerceTitle]),
          (section: .commercialPriceInputsSection, items: [.commercePrice]),
          (section: .goodsSections, items: [.isNewGood, .goodsUrl, .descriptionPick,.goodsEscrowAgreement]),
          (section: .preselectedFundingTeams, items: [])
        ]
      }
    }
    
    return sections
  }
}

//MARK:- TagPickDelegateProtocol

extension MediaPostingPresenter: TagPickDelegateProtocol {
  func selectedTags() -> TagPick.PickedTags {
    return TagPick.PickedTags(tags: interactor.postingDraft.tags)
  }
  
  func didSelectTags(_ tags: TagPick.PickedTags) {
    interactor.postingDraft.tags = tags.tags
    viewController.reloadTable()
  }
}

//MARK:- LocationPickDelegateProtocol

extension MediaPostingPresenter: LocationPickDelegateProtocol {
  func didSelectLocation(_ location: SearchLocationProtocol) {
    interactor.postingDraft.place = location
    viewController.reloadTable()
  }
}

extension MediaPostingPresenter: PromotionPickDelegateProtocol {
  func didSelectPromotion(_ promotion: CreatePromotionProtocol?) {
    interactor.postingDraft.promotionDraft = promotion
    viewController.reloadTable()
  }
  
  func selectedPromotion() -> CreatePromotionProtocol? {
    return interactor.postingDraft.promotionDraft
  }
}


//MARK:- CampaignEditDelegateProtocol

extension MediaPostingPresenter: CampaignPickDelegateProtocol {
  func didSelectedCampaign(_ campaign: FundingCampaignTeamProtocol?) {
    interactor.postingDraft.joinExistingCampaignTeam = campaign
    viewController.reloadTable()
  }
}

extension MediaPosting {
  enum Strings {
    enum Titles: String, LocalizedStringKeyProtocol {
      case description = "Description"
      case pickLocation = "Pick location"
      case pickTags = "Pick tags"
    }
    
    enum TitleForPostingType: String, LocalizedStringKeyProtocol {
      case media = "Post Media"
      case charity = "Post Charity"
      case crowdfunding = "Post Funding"
      case commercial = "Post Commerce"
      case goods = "Post Goods"
    }
    
    enum NavBarButtons: String, LocalizedStringKeyProtocol  {
      case next = "Next"
      case post = "Post"
    }
    
    enum PickCampaign: String, LocalizedStringKeyProtocol {
      case find = "Contribute to Team Project"
      case create = "Create New Project"
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

fileprivate struct CreationStages {
  let stages: [CreationStage]
  
  var currentStage: CreationStage {
    return stages[currentStageIndex]
  }
  
  var currentStageIndex: Int = 0
  
  var isLastStage: Bool {
    return currentStageIndex >= stages.count - 1
  }
  
  var isFirstStage: Bool {
    return currentStageIndex <= 0
  }
  
  init(stages: [CreationStage]) {
    self.stages = stages
  }
  
  mutating func toNextStage() {
    guard !isLastStage else {
      return
    }
    
    currentStageIndex += 1
    
  }
  
  mutating func toPrevStage() {
    guard !isFirstStage else {
      return
    }
    
    currentStageIndex -= 1
  }
}

fileprivate enum CreationStage {
  case commonInputs
  case specificInputs
}
