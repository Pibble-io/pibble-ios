//
//  PromotionDestinationPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 23/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

//MARK: - PromotionDestinationPickRouter API
protocol PromotionDestinationPickRouterApi: RouterProtocol {
  func routeToPickUrlDestination(_ delegate: PromotionUrlDestinationPickDelegateProtocol)
  func routeToNextStepWith(_ draft: PromotionDraft)
}

//MARK: - PromotionDestinationPickView API
protocol PromotionDestinationPickViewControllerApi: ViewControllerProtocol {
  func setSelectedUrlDestination(_ urlDestination: (urlTitle: String, actionTitle: String)?) 
 
  func setUserdestinationSelected(_ selected: Bool)
  func setURLdestinationSelected(_ selected: Bool)
  func setNextStepButtonEnabled(_ enabled: Bool)
}

//MARK: - PromotionDestinationPickPresenter API
protocol PromotionDestinationPickPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleNextStepAction()
  func handleUserProfileDestinationSelection()
  
  func handleUrlDestinationSelection()
  
  func presentDestination(_ destination: PromotionDestination)
}

//MARK: - PromotionDestinationPickInteractor API
protocol PromotionDestinationPickInteractorApi: InteractorProtocol {
  var promotionDraft: PromotionDraft { get }
  var destination: PromotionDestination? { get }
  func setDestination(_ destination: PromotionDestination)
}
