//
//  CreatePromotionConfirmPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CreatePromotionConfirmPresenter Class
final class CreatePromotionConfirmPresenter: Presenter {
  fileprivate let numberToStringsFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
    formatter.numberStyle = NumberFormatter.Style.decimal
    return formatter
  }()
  
  func toStringWithFormatter(_ number: Int) -> String {
    let number = NSNumber(value: number)
    return numberToStringsFormatter.string(from: number) ?? ""
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setHeaderSubtitle("", animated: false)
    viewController.setPromotionViewModel(nil, animated: false)
    interactor.initialFetchData()
  }
  
  override func viewDidAppear() {
    super .viewDidAppear()
    interactor.initialRefreshData()
  }
}

// MARK: - CreatePromotionConfirmPresenter API
extension CreatePromotionConfirmPresenter: CreatePromotionConfirmPresenterApi {
  func handleCreatePromotionAction() {
    let impresstionsBudget = "\(String(format: "%.0f", interactor.impressionsBudget * 100.0))%"
    let interactionsBudget = "\(String(format: "%.0f", interactor.interactionsBudget * 100.0))%"
    
    let budgetValue = String(format: "%.0f", interactor.promotionDraft.totalBudget?.value ?? 0.0)
    let budgetString = "\(budgetValue) \(interactor.promotionDraft.dailyBudget?.currency.symbol ?? "")"
    
    viewController.showConfirmationAlertWith(CreatePromotionConfirm.Strings.Alerts.PromotionConfirm.title.localize(value: budgetString),
                                             message: CreatePromotionConfirm.Strings.Alerts.PromotionConfirm.message.localize(values: impresstionsBudget, interactionsBudget))
  }
  
  func handleCreatePromotionConfirmAction() {
    router.routeToPinCodeUnlock(delegate: self)
  }
  
  func handlePromotionCreationFinishAction() {
    router.routeToFinish()
  }
  
  func handlePreviewAction() {
    router.routeToPostPreview(interactor.promotionDraft)
  }
  
  func handleTermsAction() {
    
  }
  
  func handlePromotionGuideAction() {
    
  }
  
  func presentPromotionCreationSuccess() {
    viewController.showPromotionCreationSuccessfulAlert()
  }
  
  
  func presentUsersReach(_ reach: (from: Int, to: Int)?) {
    guard let reach = reach else {
      viewController.setHeaderSubtitle("", animated: false)
      return
    }
    
    let fromString = toStringWithFormatter(reach.from)
    let toString = toStringWithFormatter(reach.to)
    
    let subtitle = CreatePromotionConfirm.Strings.headerSubtitle.localize(values: fromString, toString)
    viewController.setHeaderSubtitle(subtitle, animated: false)
  }
  
  func presentPromotionDraft(_ draft: CreatePromotionConfirm.PromotionDraftModel?) {
    guard let draft = draft else {
      viewController.setPromotionViewModel(nil, animated: false)
      return
    }
    
    let vm = CreatePromotionConfirm.DraftViewModel(draft: draft)
    viewController.setPromotionViewModel(vm, animated: isPresented)
  }
  
  
  func handleHideAction() {
    router.dismiss()
  }  
}


extension CreatePromotionConfirmPresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    interactor.performPromotionCreation()
  }
  
  func walletDidFailToUnlock() {
    
  }
}


// MARK: - CreatePromotionConfirm Viper Components
fileprivate extension CreatePromotionConfirmPresenter {
  var viewController: CreatePromotionConfirmViewControllerApi {
    return _viewController as! CreatePromotionConfirmViewControllerApi
  }
  var interactor: CreatePromotionConfirmInteractorApi {
    return _interactor as! CreatePromotionConfirmInteractorApi
  }
  var router: CreatePromotionConfirmRouterApi {
    return _router as! CreatePromotionConfirmRouterApi
  }
}
