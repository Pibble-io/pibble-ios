//
//  CampaignEditModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

//MARK: - CampaignEditRouter API
protocol CampaignEditRouterApi: RouterProtocol {
  func routeToMediaPickWith(_ delegate: MediaPickDelegateProtocol)
  func dismissMediaPick()
}

//MARK: - CampaignEditView API
protocol CampaignEditViewControllerApi: ViewControllerProtocol {
  func reloadData()
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func setNextStageButtonEnabled(_ enabled: Bool, title: String)
  func setNavigationBarTitle(_ title: String) 
}

//MARK: - CampaignEditPresenter API
protocol CampaignEditPresenterApi: PresenterProtocol {
  func handleDoneAction()
  func handleHideAction()
  func handleAmountUpdate(_ value: Float)
  func handleAmountUpdate(_ value: String)
  func handleAmountEndEditing()
  func handleTitleUpdate(_ value: String)
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func handleTitleEndEditing()
  
  func handleRewardInputAt(_ indexPath: IndexPath, action: CampaignEdit.RewardAmountInputActions)
  
  func handleTeamNameUpdate(_ value: String)
  func handleTeamNameEndEditing()
  
  func handleTeamLogoPickAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelFor(_ indexPath: IndexPath) -> CampaignEdit.InputViewModelType
  func sectionTypeAt(_ section: Int) -> CampaignEdit.InputSectionTypes
  
  func presentReload()
  func presentCategoriesReload()
  func presentRecipientsReload()
  func presentTeamsReload()
}


//MARK: - CampaignEditInteractor API
protocol CampaignEditInteractorApi: InteractorProtocol {
  var canBePosted: Bool { get }
  
  var postingDraft: MutablePostDraftProtocol { get }
  
  var fundingRewards: MutableFundingRewardDraftProtocol { get }
  
  var amountLimitations: (min: Double, max: Double) { get }
  var campaign: MutableCampaignDraftProtocol { get }
  
  var categories: [CategoryProtocol] { get }
  var recipients: [FundRaiseRecipient] { get }
  var crowdFundingPostTypes: [PostingType] { get }
  
  var teamTypes: [DraftCampaignTeamType] { get }
  
  func initialFetchData() 
  
  func updateTitle(_ text: String)
  func updateGoalAmount(_ value: Double)
  func updateSelectedCategory(_ category: CategoryProtocol)
  func updateSelectedRecipient(_ recipient: FundRaiseRecipient)
  func updateSelectedTeam(_ team: DraftCampaignTeamType)
  func updateTeamName(_ text: String)
  func updateSelectedTeamLogo(_ asset: PHAsset, config: ImageRequestConfig)
  
  func performPosting()
}

protocol MutableCampaignDraftProtocol: class, CampaignDraftProtocol {
  var goal: Double { get set }
  var title: String { get set }
  var raisingFor: FundRaiseRecipient? { get set }
  var category: CategoryProtocol? { get set }
  var team: DraftCampaignTeamType? { get set }
  
  var canBePosted: Bool { get }
}

protocol CampaignEditAmountInputViewModelProtocol {
  var minAmount: Float { get }
  var maxAmount: Float { get }
  var currentAmount: Float { get }
  var currentAmountString: String { get }
  
  var campaignTypeIconImage: UIImage? { get }
  
  func convertAmountFrom(_ value: String) -> Float
  func convertAmountFrom(_ value: Float) -> String
  func limitedValueStringFor(_ value: String) -> String
}

protocol CampaignEditTitleViewModelProtocol {
  var title: String { get }
  var picked: Bool { get }
  var attributedPlaceholder: NSAttributedString { get }
}


protocol CampaignEditSelectedItemViewModelProtocol {
  var attributedTitle: NSAttributedString { get }
  var picked: Bool { get }
}

protocol CampaignEditSelectionPlainItemViewModelProtocol {
  var title: String { get }
  var isSelected: Bool { get }
}


protocol CampaignEditDelegateProtocol: class {
  func didEditCampaign(_ campaign: CampaignDraftProtocol?)
  func campaignToEdit() -> CampaignDraftProtocol?
}

protocol CampaignEditTeamNameViewModelProtocol {
  var title: String { get }
  var picked: Bool { get }
  var attributedPlaceholder: NSAttributedString { get }
}

protocol CampaignEditRewardAmountPickViewModelProtocol {
  var title: String { get }
  var amounts: (String, String?) { get }
 
  var attributedPlaceholders: (NSAttributedString, NSAttributedString?) { get }
  var amountValueTitle: (String, String?) { get }
  
  var hasSecondInput: Bool { get }
}


protocol CampaignEditTeamItemViewModelProtocol {
  var teamTypeImageView: UIImage { get }
  var teamTypeTitle: String { get }
  var teamDescription: String { get }
  var teamAdditionDescription: String { get }
}

protocol CampaignEditTeamLogoPickerViewModelProtocol {
  var teamLogo: UIImage? { get }
  var teamLogoPlaceHolder: UIImage { get }
}

protocol CampaignEditSelectionItemViewModelProtocol {
  var title: String { get }
  var subtitle: String { get }
  var isSelected: Bool { get }
}

protocol CampaignEditHeaderViewModelProtocol {
  var title: String { get }
}
