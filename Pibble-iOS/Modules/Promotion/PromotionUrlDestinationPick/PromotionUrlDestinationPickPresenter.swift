//
//  PromotionUrlDestinationPickPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 24/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - PromotionUrlDestinationPickPresenter Class
final class PromotionUrlDestinationPickPresenter: Presenter {
  fileprivate weak var delegate: PromotionUrlDestinationPickDelegateProtocol?
  
//  fileprivate let sections = [PromotionActionType.allUrlRelatedCases]
  
  init(delegate: PromotionUrlDestinationPickDelegateProtocol) {
    self.delegate = delegate
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
    
    guard let selectedDestination = delegate?.selectedUrlDestination() else {
      return
    }
    
    viewController.setUrlString(selectedDestination.url.absoluteString)
    interactor.selectedPromotionActionType = selectedDestination.promotionAction
    interactor.setUrlString(selectedDestination.url.absoluteString)
  }
}

// MARK: - PromotionUrlDestinationPickPresenter API
extension PromotionUrlDestinationPickPresenter: PromotionUrlDestinationPickPresenterApi {
  func presentReload() {
    reloadViewControllerCollection()
  }
  
  func handleUrlChanged(_ urlString: String) {
    interactor.setUrlString(urlString)
  }
  
  func presentUrlStringValid(_ isValid: Bool, actionTypeSelected: Bool) {
    let validationImage = isValid ?
      UIImage(imageLiteralResourceName: "PromotionDestinaionUrlPick-UrlCheck"):
      UIImage(imageLiteralResourceName: "PromotionDestinaionUrlPick-UrlCheck-fail")
    
    viewController.setUrlValidationHidden(false)
    viewController.setUrlValidationImage(validationImage)
    viewController.setDoneButtomEnabled(isValid && actionTypeSelected)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleDoneAction() {
    guard let url = interactor.pickedUrl,
      let promotionAction = interactor.selectedPromotionActionType
    else {
      return
    }
    
    delegate?.didSelectUrlDestination(url, promotionAction: promotionAction)
    router.dismiss()
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> PromotionUrlDestinationPickButtonActionViewModelProtocol {
    let item = itemAt(indexPath)
    let isSelected: Bool
    if let selectedItem = interactor.selectedPromotionActionType {
      isSelected = item == selectedItem
    } else {
      isSelected = false
    }
    
    let viewModel = PromotionUrlDestinationPick.ButtonActionViewModel(actionType: item, isSelected: isSelected)
    return viewModel
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    interactor.selectedPromotionActionType = itemAt(indexPath)
    reloadViewControllerCollection()
  }
}

// MARK: - PromotionUrlDestinationPick Viper Components
fileprivate extension PromotionUrlDestinationPickPresenter {
  var viewController: PromotionUrlDestinationPickViewControllerApi {
    return _viewController as! PromotionUrlDestinationPickViewControllerApi
  }
  var interactor: PromotionUrlDestinationPickInteractorApi {
    return _interactor as! PromotionUrlDestinationPickInteractorApi
  }
  var router: PromotionUrlDestinationPickRouterApi {
    return _router as! PromotionUrlDestinationPickRouterApi
  }
}

//MARK:- Helper

extension PromotionUrlDestinationPickPresenter {
  fileprivate func itemAt(_ indexPath: IndexPath) -> PromotionActionTypeProtocol {
    return interactor.itemAt(indexPath)
  }
  
  fileprivate func reloadViewControllerCollection() {
    viewController.updateCollection(.beginUpdates)
    viewController.updateCollection(.updateSections(idx: Array(0..<interactor.numberOfSections())))
    viewController.updateCollection(.endUpdates)
  }
}

