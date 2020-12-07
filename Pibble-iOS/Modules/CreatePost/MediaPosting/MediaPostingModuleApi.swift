//
//  MediaPostingModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 13.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - MediaPostingRouter API
protocol MediaPostingRouterApi: RouterProtocol {
  func routeToTagPick(_ withDelegate: TagPickDelegateProtocol)
  func routeToLocationPick(_ withDelegate: LocationPickDelegateProtocol)
  func routeToDescriptionPick(_ withDelegate: DescriptionPickDelegateProtocol)
  func routeToPromotionPick(_ withDelegate: PromotionPickDelegateProtocol)
  func routeToCampaignEdit(_ postDraft: MutablePostDraftProtocol, campaignType: CampaignType) 
  func routeToCampaignPick(_ postDraft: MutablePostDraftProtocol, campaignType: CampaignType)
}

//MARK: - MediaPostingView API

protocol MediaPostingViewControllerApi: ViewControllerProtocol {
  func reloadTable()
  func setNextStageButtonEnabled(_ enabled: Bool, title: String)
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func setTitle(_ title: String)
}

//MARK: - MediaPostingPresenter API

protocol MediaPostingPresenterApi: PresenterProtocol, MediaPostingAttachedMediaViewModelProtocol {
  func numberOfAttachmentSections() -> Int
  func numberOfAttachmentsInSection(_ section: Int) -> Int
  func attachmentViewModelAt(_ indexPath: IndexPath) -> MediaPosting.AttachmentViewModel
  func handleAddItemAction()
  func handlePreviosStepAction()
  func handlePostAction()
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func handleCommercialEditAction(_ action: MediaPosting.CommerceEditActions)
  func handleFundingEditActionAt(_ indexPath: IndexPath, action: MediaPosting.FundingEditActions)
  
  func presentReload()
  
}

//MARK: - MediaPostingInteractor API

protocol MediaPostingInteractorApi: InteractorProtocol {
  func initialFetchData()
  
  var canBePosted: Bool { get }
  
  var postingDraft: MutablePostDraftProtocol { get }
  func numberOfMediaAttachmentSections() -> Int
  func numberOfMediaAttachmentsInSection(_ section: Int) -> Int
  func requestMediaAttachmentsPreviewFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping ImageRequestResult)
   
  //var draft: DraftPostingProtocol { get }
  
  var campaignDraft: CampaignDraftProtocol? { get }
  
  func performPosting()
  
  func beginPreUploadingTask()
  func cancelPreUploadingTask()
}

protocol MediaPostingAttachedMediaViewModelProtocol: class {
  func numberOfMediaAttachmentSections() -> Int
  func numberOfMediaAttachmentsInSection(_ section: Int) -> Int
  func mediaAttachmentViewModelTypeAt(_ indexPath: IndexPath) -> MediaPosting.AttachedMediaViewModelType
}

protocol MediaPostingMediaAttachmentViewModelProtocol {
  var image: UIImage { get }
}

protocol MediaPostingDesctiptionViewModelProtocol {
  var title: String { get }
}

protocol MediaPostingLocationViewModelProtocol {
  var title: String { get }
}

protocol MediaPostingTagsViewModelProtocol {
  var title: String { get }
}

protocol MediaPostingPromotionViewModelProtocol {
  var title: String { get }
  var promotionBudget: String { get }
  var promotionPicked: Bool { get }
}

protocol MediaPostingCampaignViewModelProtocol {
  var title: String { get }
  var isSelected: Bool { get }

}

protocol MediaPostingDigitalGoodToggleViewModelProtocol {
  var isSelected: Bool { get }
}


protocol MediaPostingDigitalGoodDownloadableToggleViewModelProtocol {
  var isSelected: Bool { get }
}

protocol MediaPostingDigitalGoodLicensingViewModelProtocol {
  var commercialUseAllowed: Bool { get }
  var editorialUseAllowed: Bool { get }
  var royaltyFreeUseAllowed: Bool { get }
  var exclusiveUseAllowed: Bool { get }
}

protocol MediaPostingDigitalGoodAgreementViewModelProtocol {
  var hasUserAgreedToTerms: Bool { get }
  var hasUserAgreedToTermsOfResponsibility: Bool { get }
}


protocol MediaPostingCommercePriceViewModelProtocol {
  var amount: String { get }
}

protocol MediaPostingCommerceTitleViewModelProtocol {
  var title: String { get }
}

protocol MediaPostingCommerceRewardViewModelProtocol {
  var amount: String { get }
}

protocol MediaPostingGoodsEscrowAgreementViewModelProtocol {
  var hasUserAgreedToTerms: Bool { get }
}


protocol MediaPostingGoodIsNewToggleViewModelProtocol {
  var isSelected: Bool { get }
}

protocol MediaPostingGoodUrlViewModelProtocol {
  var urlString: String { get }
  var shouldPresentUrlValidationImage: Bool { get }
  var urlStringValidationImage: UIImage? { get }
}

protocol MediaPostingGoodDescriptionViewModelProtocol {
  var text: String { get }
}

protocol MediaPostingPreselectedFundingCmapaignViewModelProtocol {
  var teamTitle: String { get }
  var campaignLogoPlaceholder: UIImage? { get }
  var campaignLogoURLString: String { get }
  var campaignTitle: String { get }
  var campaignInfo: NSAttributedString { get }
  var campaignGoals: NSAttributedString { get }
  var isSelected: Bool { get }
  var selectedItemImage: UIImage { get }
}
