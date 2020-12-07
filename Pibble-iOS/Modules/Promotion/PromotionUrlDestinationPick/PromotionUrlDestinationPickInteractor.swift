//
//  PromotionUrlDestinationPickInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 24/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - PromotionUrlDestinationPickInteractor Class
final class PromotionUrlDestinationPickInteractor: Interactor {
  fileprivate let promotionService: PromotionServiceProtocol
  fileprivate(set) var urlString: String = ""
  fileprivate var actions: [[PromotionActionTypeProtocol]] = [[]] {
    didSet {
      presenter.presentReload()
    }
  }
  
  var pickedUrl: URL? {
    return URL(string: urlString)
  }
  
  var selectedPromotionActionType: PromotionActionTypeProtocol? {
    didSet {
      presenter.presentUrlStringValid(urlString.isValidUrl, actionTypeSelected: selectedPromotionActionType != nil)
    }
  }
  
  init(promotionService: PromotionServiceProtocol) {
    self.promotionService = promotionService
  }
}

// MARK: - PromotionUrlDestinationPickInteractor API
extension PromotionUrlDestinationPickInteractor: PromotionUrlDestinationPickInteractorApi {
  func numberOfSections() -> Int {
    return actions.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return actions[section].count
  }
  
  func itemAt(_ indexPath: IndexPath) -> PromotionActionTypeProtocol {
    return actions[indexPath.section][indexPath.item]
  }
  
  func initialFetchData() {
    promotionService.getActions { [weak self] in
      switch $0 {
      case .success(let actionsItems):
        self?.actions = [actionsItems]
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func setUrlString(_ urlString: String) {
    self.urlString = urlString
    let isValidUrl = urlString.isValidUrl
    presenter.presentUrlStringValid(isValidUrl, actionTypeSelected: selectedPromotionActionType != nil)
  }
}

// MARK: - Interactor Viper Components Api
private extension PromotionUrlDestinationPickInteractor {
  var presenter: PromotionUrlDestinationPickPresenterApi {
    return _presenter as! PromotionUrlDestinationPickPresenterApi
  }
}
