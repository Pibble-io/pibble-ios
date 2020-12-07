//
//  CommerceTypePickPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CommerceTypePickPresenter Class
final class CommerceTypePickPresenter: Presenter {
  
  fileprivate var sections: [(section: CommerceTypePickSections, items: [CommerceTypePick.SettingsItems])] =  [
    (section: .commerceTypes, items: [.myGoods, .purchasedGoods])
  ]
}

//MARK:- Helpers
extension CommerceTypePickPresenter {
  fileprivate func itemAt(indexPath: IndexPath) -> CommerceTypePick.SettingsItems {
    return sections[indexPath.section].items[indexPath.item]
  }
}


// MARK: - CommerceTypePickPresenter API
extension CommerceTypePickPresenter: CommerceTypePickPresenterApi {
  func presentMyGoodsForUser(_ user: UserProtocol) {
    router.routeToMyGoodsListForCurrentUser(user)
  }
  
  func presentPurchasedGoodsForUser(_ user: UserProtocol) {
    router.routeToPurchasedGoodsListForCurrentUser(user)
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> CommerceTypePickItemViewModelProtocol {
    let settingsItem = itemAt(indexPath: indexPath)
    let shouldHaveUpperSeparator = indexPath.section != 0 && indexPath.item == 0
    return CommerceTypePick.CommerceTypePickItemViewModel(settingsItem: settingsItem,
                                                  shouldHaveUpperSeparator: shouldHaveUpperSeparator)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = itemAt(indexPath: indexPath)
    switch item {
    case .myGoods:
      interactor.performFetchCurrentUserAndPresentMyGoods()
    case .purchasedGoods:
      interactor.performFetchCurrentUserAndPresentPurchasedGoods()
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - CommerceTypePick Viper Components
fileprivate extension CommerceTypePickPresenter {
  var viewController: CommerceTypePickViewControllerApi {
    return _viewController as! CommerceTypePickViewControllerApi
  }
  var interactor: CommerceTypePickInteractorApi {
    return _interactor as! CommerceTypePickInteractorApi
  }
  var router: CommerceTypePickRouterApi {
    return _router as! CommerceTypePickRouterApi
  }
}

fileprivate enum CommerceTypePickSections {
  case commerceTypes
}

