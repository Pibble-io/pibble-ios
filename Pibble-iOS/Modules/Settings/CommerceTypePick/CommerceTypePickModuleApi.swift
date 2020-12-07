//
//  CommerceTypePickModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - CommerceTypePickRouter API
protocol CommerceTypePickRouterApi: RouterProtocol {
  func routeToMyGoodsListForCurrentUser(_ user: UserProtocol)
  func routeToPurchasedGoodsListForCurrentUser(_ user: UserProtocol)
}

//MARK: - CommerceTypePickView API
protocol CommerceTypePickViewControllerApi: ViewControllerProtocol {
}

//MARK: - CommerceTypePickPresenter API
protocol CommerceTypePickPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> CommerceTypePickItemViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentMyGoodsForUser(_ user: UserProtocol)
  func presentPurchasedGoodsForUser(_ user: UserProtocol)
}

//MARK: - CommerceTypePickInteractor API
protocol CommerceTypePickInteractorApi: InteractorProtocol {  
  func performFetchCurrentUserAndPresentMyGoods()
  func performFetchCurrentUserAndPresentPurchasedGoods()
}


protocol CommerceTypePickItemViewModelProtocol {
  var title: String { get }
  var isUpperSeparatorVisible: Bool { get }
  var isRightArrowVisible: Bool { get }
  var titleColor: UIColor { get }
}
