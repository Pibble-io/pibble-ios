//
//  CampaignPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 29.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import UIKit

//MARK: - CampaignPickRouter API
protocol CampaignPickRouterApi: RouterProtocol {
}

//MARK: - CampaignPickView API
protocol CampaignPickViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func setDoneButtonEnabled(_ enabled: Bool)
}

//MARK: - CampaignPickPresenter API
protocol CampaignPickPresenterApi: PresenterProtocol {
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  func handleHideAction()
  func handleDoneAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> CampaignPickItemViewModelProtocol
  
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func handleSelectActionAt(_ indexPath: IndexPath)
  
  func handleSearchTextChange(_ text: String)
}

//MARK: - CampaignPickInteractor API
protocol CampaignPickInteractorApi: InteractorProtocol {
  var postingDraft: MutablePostDraftProtocol { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> FundingCampaignTeamProtocol
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  
  func isSelectedItemAt(_ indexPath: IndexPath) -> Bool
  func changeSelectedStateForItemAt(_ indexPath: IndexPath)
  func deselectItem()
  
  var selectedCampaignItem: FundingCampaignTeamProtocol? { get }
  
  func updateSearchString(_ searchString: String)
  
  var canBePosted: Bool { get }
  func performPosting()
}


protocol CampaignPickItemViewModelProtocol {
  var teamTitle: String { get }
  var campaignLogoPlaceholder: UIImage? { get }
  var campaignLogoURLString: String { get }
  var campaignTitle: String { get }
  var campaignInfo: NSAttributedString { get }
  var campaignGoals: NSAttributedString { get }
  var isSelected: Bool { get }
  var selectedItemImage: UIImage { get }
}

protocol CampaignPickDelegateProtocol: class {
  func didSelectedCampaign(_ campaign: FundingCampaignTeamProtocol?)
}
