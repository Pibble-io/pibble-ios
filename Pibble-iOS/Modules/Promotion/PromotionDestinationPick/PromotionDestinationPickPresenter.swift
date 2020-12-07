//
//  PromotionDestinationPickPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 23/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotionDestinationPickPresenter Class
final class PromotionDestinationPickPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setURLdestinationSelected(false)
    viewController.setUserdestinationSelected(false)
    viewController.setSelectedUrlDestination(nil)
    viewController.setNextStepButtonEnabled(false)
  }
}

// MARK: - PromotionDestinationPickPresenter API
extension PromotionDestinationPickPresenter: PromotionDestinationPickPresenterApi {
  func handleNextStepAction() {
    router.routeToNextStepWith(interactor.promotionDraft)
  }
  
  func handleUserProfileDestinationSelection() {
    interactor.setDestination(.userProfile(VisitProfilePromotionActionType()))
  }
  
  func handleUrlDestinationSelection() {
    router.routeToPickUrlDestination(self)
  }
  
  func presentDestination(_ destination: PromotionDestination) {
    switch destination {
    case .userProfile:
      viewController.setURLdestinationSelected(false)
      viewController.setUserdestinationSelected(true)
      viewController.setSelectedUrlDestination(nil)
      viewController.setNextStepButtonEnabled(true)
    case .url(let url, let action):
      viewController.setURLdestinationSelected(true)
      viewController.setUserdestinationSelected(false)
      viewController.setSelectedUrlDestination((url.absoluteString, action.actionTitle))
      viewController.setNextStepButtonEnabled(true)
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - PromotionDestinationPick Viper Components
fileprivate extension PromotionDestinationPickPresenter {
  var viewController: PromotionDestinationPickViewControllerApi {
    return _viewController as! PromotionDestinationPickViewControllerApi
  }
  var interactor: PromotionDestinationPickInteractorApi {
    return _interactor as! PromotionDestinationPickInteractorApi
  }
  var router: PromotionDestinationPickRouterApi {
    return _router as! PromotionDestinationPickRouterApi
  }
}

extension PromotionDestinationPickPresenter: PromotionUrlDestinationPickDelegateProtocol {
  func didSelectUrlDestination(_ url: URL, promotionAction: PromotionActionTypeProtocol) {
    interactor.setDestination(.url(url, promotionAction))
  }
  
  func selectedUrlDestination() -> (url: URL, promotionAction: PromotionActionTypeProtocol)? {
    guard let destination = interactor.destination else {
      return nil
    }
    
    switch destination {
    case .userProfile:
      return nil
    case .url(let url, let actionType):
      return (url, actionType)
    }
  }
  
  
}
