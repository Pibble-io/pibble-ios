//
//  CampaignPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 29.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CampaignPickPresenter Class
final class CampaignPickPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    viewController.setDoneButtonEnabled(interactor.selectedCampaignItem != nil)
    interactor.initialRefresh()
  }
}

// MARK: - CampaignPickPresenter API
extension CampaignPickPresenter: CampaignPickPresenterApi {
  func handleSearchTextChange(_ text: String) {
    interactor.deselectItem()
    viewController.setDoneButtonEnabled(interactor.selectedCampaignItem != nil)
    interactor.updateSearchString(text)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleDoneAction() {
    guard let selectedCampaign = interactor.selectedCampaignItem else {
      return
    }
    
   
    interactor.performPosting()
    router.dismiss(withPop: false)
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> CampaignPickItemViewModelProtocol {
    let item = interactor.itemAt(indexPath)
    let isSelected = interactor.isSelectedItemAt(indexPath)
    return CampaignPick.CampaignPickItemViewModel(fundingCamgaignTeam: item, isSelected: isSelected)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.item)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.item)
  }
  
  func handleSelectActionAt(_ indexPath: IndexPath) {
    interactor.changeSelectedStateForItemAt(indexPath)
    viewController.setDoneButtonEnabled(interactor.selectedCampaignItem != nil)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
}

// MARK: - CampaignPick Viper Components
fileprivate extension CampaignPickPresenter {
  var viewController: CampaignPickViewControllerApi {
    return _viewController as! CampaignPickViewControllerApi
  }
  var interactor: CampaignPickInteractorApi {
    return _interactor as! CampaignPickInteractorApi
  }
  var router: CampaignPickRouterApi {
    return _router as! CampaignPickRouterApi
  }
}
