//
//  CreatePromotionConfirmModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

//MARK: - CreatePromotionConfirmRouter API
protocol CreatePromotionConfirmRouterApi: RouterProtocol {
  func routeToPostPreview(_ promotionDraft: PromotionDraft)
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
  func routeToFinish()
}

//MARK: - CreatePromotionConfirmView API
protocol CreatePromotionConfirmViewControllerApi: ViewControllerProtocol {
  func setHeaderSubtitle(_ text: String, animated: Bool)
  func setPromotionViewModel(_ vm: CreatePromotionConfirmDraftViewModelProtocol?, animated: Bool)
  
  func showConfirmationAlertWith(_ title: String, message: String)
  func showPromotionCreationSuccessfulAlert()
}

//MARK: - CreatePromotionConfirmPresenter API
protocol CreatePromotionConfirmPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func handlePreviewAction()
  func handleTermsAction()
  func handlePromotionGuideAction()
  
  func handleCreatePromotionAction()
  func handleCreatePromotionConfirmAction()
  func handlePromotionCreationFinishAction()
  
  func presentPromotionDraft(_ draft: CreatePromotionConfirm.PromotionDraftModel?)
  func presentUsersReach(_ reach: (from: Int, to: Int)?)
  
  func presentPromotionCreationSuccess()
}

//MARK: - CreatePromotionConfirmInteractor API
protocol CreatePromotionConfirmInteractorApi: InteractorProtocol {
  var impressionsBudget: Double { get }
  var interactionsBudget: Double { get }
  
  var promotionDraft: PromotionDraft { get }
  
  func initialFetchData()
  func initialRefreshData()
  
  func performPromotionCreation()
}

protocol CreatePromotionConfirmDraftViewModelProtocol {
  var destination: String { get }
  var action: String { get }
  var budget: String { get }
}
