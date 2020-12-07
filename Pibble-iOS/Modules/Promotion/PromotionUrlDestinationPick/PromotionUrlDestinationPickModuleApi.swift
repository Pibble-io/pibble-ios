//
//  PromotionUrlDestinationPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 24/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - PromotionUrlDestinationPickRouter API
protocol PromotionUrlDestinationPickRouterApi: RouterProtocol {
}

//MARK: - PromotionUrlDestinationPickView API
protocol PromotionUrlDestinationPickViewControllerApi: ViewControllerProtocol {
  func setDoneButtomEnabled(_ enabled: Bool)
  func setUrlValidationImage(_ image: UIImage)
  func setUrlValidationHidden(_ isHidden: Bool)
  func setUrlString(_ text: String)
  
  func reloadData()
  func updateCollection(_ updates: CollectionViewModelUpdate) 
}

//MARK: - PromotionUrlDestinationPickPresenter API
protocol PromotionUrlDestinationPickPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleDoneAction()
  func handleSelectionAt(_ indexPath: IndexPath)
  func handleUrlChanged(_ urlString: String)
  
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> PromotionUrlDestinationPickButtonActionViewModelProtocol
 
  func presentUrlStringValid(_ isValid: Bool, actionTypeSelected: Bool)
  func presentReload()
}

//MARK: - PromotionUrlDestinationPickInteractor API
protocol PromotionUrlDestinationPickInteractorApi: InteractorProtocol {
  var pickedUrl: URL? { get }
  var selectedPromotionActionType: PromotionActionTypeProtocol? { get set }
  
  func setUrlString(_ urlString: String)
  func initialFetchData()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> PromotionActionTypeProtocol
  
}

protocol PromotionUrlDestinationPickButtonActionViewModelProtocol {
  var selectionImage: UIImage { get }
  var isSelected: Bool { get }
  var title: String { get }
}

protocol PromotionUrlDestinationPickDelegateProtocol: class {
  func didSelectUrlDestination(_ url: URL, promotionAction: PromotionActionTypeProtocol)
  func selectedUrlDestination() -> (url: URL, promotionAction: PromotionActionTypeProtocol)?
}
