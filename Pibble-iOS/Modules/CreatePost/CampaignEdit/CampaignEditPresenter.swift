//
//  CampaignEditPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

fileprivate typealias Sections = [(section: CampaignEdit.InputSectionTypes, items: [CampaignEdit.InputViewModelType])]

// MARK: - CampaignEditPresenter Class
final class CampaignEditPresenter: Presenter {
  fileprivate var sections: Sections = []
  fileprivate var extendedSections = Set<CampaignEdit.InputSectionTypes>()
  
  fileprivate lazy var postingStage: CreationStages = {
    switch interactor.postingDraft.draftPostType {
    case .media:
      return CreationStages(stages: [])
    case .charity:
      return CreationStages(stages: [.campaignEdit, .teamEdit])
    case .crowdfunding:
      return CreationStages(stages: [.campaignEdit, .rewardsTypeEdit, .teamEdit])
    case .crowdfundingWithReward:
      return CreationStages(stages: [.campaignEdit, .rewardsTypeEdit, .rewardsAmountsEdit, .teamEdit])
    case .digitalGood:
      return CreationStages(stages: [])
    case .goods:
      return CreationStages(stages: [])
    }
  }()
  
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialFetchData()
   
   
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
    let title = CampaignEdit.Strings.titleForPostingType(interactor.postingDraft.draftPostType)
    viewController.setNavigationBarTitle(title)
    sections = createSections()
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    interactor.postingDraft.campaignDraft = interactor.campaign
  }
}

// MARK: - CampaignEditPresenter API
extension CampaignEditPresenter: CampaignEditPresenterApi {
  func handleDoneAction() {
    guard postingStage.isLastStage else {
      presentNextStage()
      return
    }
    
    interactor.performPosting()
    router.dismiss(withPop: false)
  }
  
  func handleTeamLogoPickAction() {
    router.routeToMediaPickWith(self)
  }
  
  func sectionTypeAt(_ section: Int) -> CampaignEdit.InputSectionTypes {
    return sections[section].section
  }
  
  func handleAmountEndEditing() {
    sections = createSections()
    var reloadSections: [Int] = []
    if let idx = sections.index(where: { return $0.section == .amount }) {
      reloadSections.append(idx)
    }
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: reloadSections))
    viewController.updateCollection(.endUpdates)
  }
  
  func handleTitleEndEditing() {
    sections = createSections()
    var reloadSections: [Int] = []
    if let idx = sections.index(where: { return $0.section == .title }) {
      reloadSections.append(idx)
    }
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: reloadSections))
    viewController.updateCollection(.endUpdates)
  }
  
  func presentRewardTypeReload() {
    sections = createSections()
    var reloadSections: [Int] = []
    if let idx = sections.index(where: { return $0.section == .sectionHeaderItem }) {
      reloadSections.append(idx)
    }
    
    if let idx = sections.index(where: { return $0.section == .rewardTypeItem }) {
      reloadSections.append(idx)
    }
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: reloadSections))
    viewController.updateCollection(.endUpdates)
  }
  
  func presentTeamsReload() {
    sections = createSections()
    var reloadSections: [Int] = []
    if let idx = sections.index(where: { return $0.section == .teamTypes }) {
      reloadSections.append(idx)
    }
    
    if let idx = sections.index(where: { return $0.section == .teamEdit }) {
      reloadSections.append(idx)
    }
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: reloadSections))
    viewController.updateCollection(.endUpdates)
  }
  
  func presentCategoriesReload() {
    sections = createSections()
    var reloadSections: [Int] = []
    if let idx = sections.index(where: { return $0.section == .category }) {
      reloadSections.append(idx)
    }
    
    if let idx = sections.index(where: { return $0.section == .categoryItem }) {
      reloadSections.append(idx)
    }
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: reloadSections))
    viewController.updateCollection(.endUpdates)
  }
  
  func presentRecipientsReload() {
    sections = createSections()
    var reloadSections: [Int] = []
    
    if let idx = sections.index(where: { return $0.section == .recipientItem }) {
      reloadSections.append(idx)
    }
    
    if let idx = sections.index(where: { return $0.section == .recipient }) {
      reloadSections.append(idx)
    }
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: reloadSections))
    viewController.updateCollection(.endUpdates)
  }
  
  func handleAmountUpdate(_ value: Float) {
    interactor.updateGoalAmount(Double(value))
    
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
  func handleAmountUpdate(_ value: String) {
    let formatter = NumberFormatter()
    let amount = formatter.number(from: value)?.doubleValue ?? 0.0
    interactor.updateGoalAmount(amount)
    
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
  func handleTitleUpdate(_ value: String) {
    interactor.updateTitle(value)
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
  func handleTeamNameUpdate(_ value: String) {
    interactor.updateTeamName(value)
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
  func handleTeamNameEndEditing() {
    sections = createSections()
    var reloadSections: [Int] = []
    if let idx = sections.index(where: { return $0.section == .teamEdit }) {
      reloadSections.append(idx)
    }
    
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: reloadSections))
    viewController.updateCollection(.endUpdates)
  }
  
  func presentReload() {
    sections = createSections()
    viewController.reloadData()
  }
  
  func handleHideAction() {
    guard postingStage.isFirstStage else {
      presentPrevStage()
      return
    }
    
    router.dismiss()
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelFor(_ indexPath: IndexPath) -> CampaignEdit.InputViewModelType {
    return sections[indexPath.section].items[indexPath.item]
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let sectionItems = sections[indexPath.section]
    
    switch sectionItems.section {
    case .amount:
      break
    case .title:
      break
    case .recipient:
      if extendedSections.contains(.recipientItem) {
        extendedSections.remove(.recipientItem)
      } else {
        extendedSections.insert(.recipientItem)
      }
      presentRecipientsReload()
    case .recipientItem:
      let recipient = interactor.recipients[indexPath.item]
      interactor.updateSelectedRecipient(recipient)
      extendedSections.remove(.recipientItem)
      presentRecipientsReload()
    case .category:
      if extendedSections.contains(.categoryItem) {
        extendedSections.remove(.categoryItem)
      } else {
        extendedSections.insert(.categoryItem)
      }
      presentCategoriesReload()
    case .categoryItem:
      let category = interactor.categories[indexPath.item]
      interactor.updateSelectedCategory(category)
      extendedSections.remove(.categoryItem)
      presentCategoriesReload()
    case .teamTypes:
      let selectedTeam = interactor.teamTypes[indexPath.item]
      interactor.updateSelectedTeam(selectedTeam)
      presentTeamsReload()
    case .teamEdit:
      break
    case .teamHeaderItem:
      break
    case .sectionFooterItem:
      break
    case .sectionHeaderItem:
      break
    case .rewardTypeItem:
      let selectedFundingType = interactor.crowdFundingPostTypes[indexPath.item]
      interactor.postingDraft.updateCrowdfundingType(selectedFundingType)
      postingStage.updateStagesFor(interactor.postingDraft.draftPostType)
      presentRewardTypeReload()
    case .rewardInputs:
      break
    }
    
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
  func handleRewardInputAt(_ indexPath: IndexPath, action: CampaignEdit.RewardAmountInputActions) {
    let sectionItem = sections[indexPath.section].items[indexPath.item]
    
    switch sectionItem {
    case .rewardInputPrice(_):
      switch action {
      case .firstAmountInputChanged(let amount):
         interactor.fundingRewards.price = Double(amount)
      case .firstAmountInputEndEditing:
        break
      case .secondAmountInputChanged, .secondAmountInputEndEditing:
        break
      }
      
    case .rewardInputDiscountPrice(_):
      switch action {
      case .firstAmountInputChanged(let amount):
        interactor.fundingRewards.discoutPrice = Double(amount)
      case .firstAmountInputEndEditing:
        break
      case .secondAmountInputChanged(let amount):
        interactor.fundingRewards.discountAmount = Int(amount)
      case .secondAmountInputEndEditing:
        break
      }
    case .rewardInputEarlyPrice(_):
      switch action {
      case .firstAmountInputChanged(let amount):
        interactor.fundingRewards.earlyPrice = Double(amount)
      case .firstAmountInputEndEditing:
        break
      case .secondAmountInputChanged(let amount):
        interactor.fundingRewards.earlyAmount = Int(amount)
      case .secondAmountInputEndEditing:
        break
      }
    default:
      break
    }
    
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
  }
  
}


// MARK: - Helpers
extension CampaignEditPresenter {
  fileprivate var canBePosted: Bool {
    switch postingStage.currentStage {
    case .campaignEdit:
      return interactor.campaign.hasValidInputs
    case .rewardsTypeEdit:
      return true
    case .rewardsAmountsEdit:
      return interactor.postingDraft.fundingRewards.canBePosted
    case .teamEdit:
      return interactor.postingDraft.canBePosted
    }
  }
  
  fileprivate var nextStepButtonTitle: String {
    return postingStage.isLastStage ?
      CampaignEdit.Strings.NavBarButtons.post.localize() :
      CampaignEdit.Strings.NavBarButtons.next.localize()
  }
  
  func presentNextStage() {
    postingStage.toNextStage()
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
    sections = createSections()
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: sections.enumerated().map { $0.offset }))
    viewController.updateCollection(.endUpdates)
  }
  
  func presentPrevStage() {
    postingStage.toPrevStage()
    viewController.setNextStageButtonEnabled(canBePosted, title: nextStepButtonTitle)
    sections = createSections()
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: sections.enumerated().map { $0.offset }))
    viewController.updateCollection(.endUpdates)
  }
  
  fileprivate func createSections() -> Sections {
    let selectedCategory = interactor.campaign.category
    let extendedCategoriesViewModels: [CampaignEdit.CategoryItemViewModel] =
      interactor
        .categories
        .map {
          if let  category = selectedCategory {
            return CampaignEdit.CategoryItemViewModel(category: $0, isSelected: category == $0)
          }
          return CampaignEdit.CategoryItemViewModel(category: $0, isSelected: false)
        }
    
    let categories = extendedSections.contains(.categoryItem) ? extendedCategoriesViewModels : []
    
    let recipientPickItems: [CampaignEdit.InputViewModelType] = interactor.recipients.count > 0 ? [.selectedCampaignRecipient(CampaignEdit.SelectedRecipientViewModel(draft: interactor.campaign))] :
      []
    
    
    let selectedRecipient = interactor.campaign.raisingFor
    let extendedRecipentsViewModels: [CampaignEdit.RecipientItemViewModel] =
      interactor
        .recipients
        .map {
          if let selectedRecipient = selectedRecipient {
            return CampaignEdit.RecipientItemViewModel(recipient: $0, isSelected: selectedRecipient == $0)
          }
         
          return CampaignEdit.RecipientItemViewModel(recipient: $0, isSelected: false)
        }
    
    let recipients = extendedSections.contains(.recipientItem) ? extendedRecipentsViewModels : []
    
    
    let min = Float(interactor.amountLimitations.min)
    let max = Float(interactor.amountLimitations.max)
    
  
    let currentDraftPostType = interactor.postingDraft.draftPostType
    
    let teamHeaderViewModels = [CampaignEdit.CampaignEditHeaderViewModel.campaignTeamHeader]
    
    switch postingStage.currentStage {
    case .campaignEdit:
      return [(section: .amount, items: [.amount(CampaignEdit.AmountInputViewModel(postType: interactor.postingDraft.draftPostType, draft: interactor.campaign, min: min, max: max))]),
              (section: .title, items: [.title(CampaignEdit.TitleViewModel(draft: interactor.campaign))]),
              (section: .recipient, items: recipientPickItems),
              (section: .recipientItem, items: recipients.map { .campaignRecipientItem($0)} ),
              (section: .category, items:  [.selectedCategory(CampaignEdit.SelectedCategoryViewModel(draft: interactor.campaign))]),
              (section: .categoryItem, items: categories.map { .categoryItem($0) }),
              
              (section: .sectionHeaderItem, items: []),
              (section: .rewardTypeItem, items: []),
              
              (section: .rewardInputs, items: []),
              
              (section: .teamHeaderItem, items: []),
              (section: .teamTypes, items: []),
              (section: .teamEdit, items: []),
              (section: .sectionFooterItem, items: [])]
    case .rewardsTypeEdit:
      let rewardsHeaderViewModels = [CampaignEdit.CampaignEditHeaderViewModel.rewardTypeHeader]
      
      let rewardsTypeItems: [CampaignEdit.CampaignEditRewardTypeViewModel] =
        interactor.crowdFundingPostTypes
          .enumerated()
          .map {
            CampaignEdit.CampaignEditRewardTypeViewModel(postType: $0.element,
                                                         isSelected: $0.element == currentDraftPostType)
      }
      
      return [(section: .amount, items: []),
              (section: .title, items: []),
              (section: .recipient, items: []),
              (section: .recipientItem, items: []),
              (section: .category, items:  []),
              (section: .categoryItem, items: []),
              
              (section: .sectionHeaderItem, items: rewardsHeaderViewModels.map { .sectionHeader($0) }),
              (section: .rewardTypeItem, items: rewardsTypeItems.map { .selectionItem($0) }),
              
              (section: .rewardInputs, items: []),
              
              (section: .teamHeaderItem, items: []),
              (section: .teamTypes, items: []),
              (section: .teamEdit, items: []),
              (section: .sectionFooterItem, items: [.sectionFooterItem])]
    case .rewardsAmountsEdit:
      
      let rewardsPickHeader = [CampaignEdit.CampaignEditHeaderViewModel.rewardsPickHeader]
      let rewardInputs: [CampaignEdit.InputViewModelType] = [
        .rewardInputPrice(CampaignEdit.RewardsAmountsInputs(inputType: .regularPrice,
                                                            price: interactor.fundingRewards.price,
                                                            amount: nil)),
        .rewardInputEarlyPrice(CampaignEdit.RewardsAmountsInputs(inputType: .earlyBirdPrice,
                                                                      price: interactor.fundingRewards.earlyPrice,
                                                                      amount: interactor.fundingRewards.earlyAmount)),
        .rewardInputDiscountPrice(CampaignEdit.RewardsAmountsInputs(inputType: .discountPrice,
                                                                 price: interactor.fundingRewards.discoutPrice,
                                                                 amount: interactor.fundingRewards.discountAmount))
      ]
      
      
      return [(section: .amount, items: []),
              (section: .title, items: []),
              (section: .recipient, items: []),
              (section: .recipientItem, items: []),
              (section: .category, items:  []),
              (section: .categoryItem, items: []),
              
              (section: .sectionHeaderItem, items: rewardsPickHeader.map { .sectionHeader($0) }),
              (section: .rewardTypeItem, items: []),
              
              (section: .rewardInputs, items: rewardInputs),
              
              (section: .teamHeaderItem, items: []),
              (section: .teamTypes, items: []),
              (section: .teamEdit, items: []),
              (section: .sectionFooterItem, items: [.sectionFooterItem])]
    case .teamEdit:
      let teamItems = [CampaignEdit.CampaignEditTeamItemViewModel(draft: interactor.campaign,
                                                                  team: .individual),
                       CampaignEdit.CampaignEditTeamItemViewModel(draft: interactor.campaign,
                                                                  team: .team(nil))
      ]
      
      var teamEditItems: [CampaignEdit.InputViewModelType] = []
      if let selectedTeam = interactor.campaign.team,
        case DraftCampaignTeamType.team = selectedTeam {
        
        teamEditItems.append(.teamNameInput(CampaignEdit.CampaignEditTeamNameViewModel(draft: interactor.campaign)))
        teamEditItems.append(.teamLogoPick(CampaignEdit.CampaignEditTeamLogoPickerViewModel(draft: interactor.campaign)))
      }
      
      return [(section: .amount, items: []),
              (section: .title, items: []),
              (section: .recipient, items: []),
              (section: .recipientItem, items: []),
              (section: .category, items:  []),
              (section: .categoryItem, items: []),
              
              (section: .sectionHeaderItem, items: []),
              (section: .rewardTypeItem, items: []),
              
              (section: .rewardInputs, items: []),
              
              (section: .teamHeaderItem, items: teamHeaderViewModels.map { .sectionHeader($0) }),
              (section: .teamTypes, items: teamItems.map { .selectionItem($0)} ),
              (section: .teamEdit, items: teamEditItems),
              (section: .sectionFooterItem, items: [.sectionFooterItem])]
    }
  }
}

// MARK: - CampaignEdit Viper Components
fileprivate extension CampaignEditPresenter {
  var viewController: CampaignEditViewControllerApi {
    return _viewController as! CampaignEditViewControllerApi
  }
  var interactor: CampaignEditInteractorApi {
    return _interactor as! CampaignEditInteractorApi
  }
  var router: CampaignEditRouterApi {
    return _router as! CampaignEditRouterApi
  }
}

extension CampaignEditPresenter: MediaPickDelegateProtocol {
  func didSelectedMediaAssets(_ assets: [LibraryAsset]) {
    router.dismissMediaPick()
    
    guard let imageAsset = assets.first else {
      return
    }
    
    let config = ImageRequestConfig(size: CGSize(width: 200, height: 200), contentMode: PHImageContentMode.aspectFill)
    interactor.updateSelectedTeamLogo(imageAsset.underlyingAsset, config: config)
  }
  
  func presentationStyle() -> MediaPick.PresentationStyle {
    return .present
  }
}


fileprivate struct CreationStages {
  var stages: [CreationStage]
  
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
  
  mutating func updateStagesFor(_ postType: PostingType) {
    switch postType {
    case .media:
      return stages = []
    case .charity:
      return stages = [.campaignEdit, .teamEdit]
    case .crowdfunding:
      return stages = [.campaignEdit, .rewardsTypeEdit, .teamEdit]
    case .crowdfundingWithReward:
      return stages = [.campaignEdit, .rewardsTypeEdit, .rewardsAmountsEdit, .teamEdit]
    case .digitalGood:
      return stages = []
    case .goods:
      return stages = []
    }
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
  case campaignEdit
  case rewardsTypeEdit
  case rewardsAmountsEdit
  case teamEdit
  
}


extension MutableCampaignDraftProtocol {
  fileprivate var hasValidInputs: Bool {
    guard !goal.isLessThanOrEqualTo(0) else {
      return false
    }
    
    guard title.count > 0 else {
      return false
    }
    
    guard let _ = raisingFor,
      let _ = category
    else {
        return false
    }
    
    return true
  }
}
