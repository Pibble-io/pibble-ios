//
//  ResetPasswordPhonePickModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ResetPasswordPhonePickModulePresenter Class
final class ResetPasswordPhonePickPresenter: Presenter {
  fileprivate var presentingCountriesHidden = true
  
  
  override func viewWillAppear() {
     super.viewWillAppear()
    interactor.initialFetchData()
//    viewController
//      .setCountriesListPresentation(presentingCountriesHidden)
    viewController
      .setPickCountryButtonPresentation(.pickCodeButton)
   
  }
}

// MARK: - ResetPasswordPhonePickModulePresenter API
extension ResetPasswordPhonePickPresenter: ResetPasswordPhonePickPresenterApi {
  func presentSendVerificationFailed() {
    viewController.setInteractionEnabled(true)
  }
  
  func presentDataReload() {
    viewController.reloadCounriesTable()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsIn(_ section: Int) -> Int {
    return interactor.numberOfItemsIn(section)
  }
  
  func itemFor(_ indexPath: IndexPath) -> SignUpCountryViewModelProtocol {
    return interactor.itemFor(indexPath)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    interactor.selectItemAt(indexPath)
  }
  
  func presentSendPasswordResetSuccessWith(_ phoneNumber: UserPhoneNumberProtocol) {
    viewController.setInteractionEnabled(true)
    router.routeToVerifyCodeWith(phoneNumber)
  }
  
  func handlePhoneValueChanged(_ value: String) {
    interactor.setPhoneNumber(value)
  }
  
  func handleNextStageAction() {
    viewController.setInteractionEnabled(false)
    interactor.sendPasswordResetToPhoneNumber()
  }
  
  func handleCountriesAction() {
    presentingCountriesHidden = !presentingCountriesHidden
    viewController.setCountriesListPresentation(presentingCountriesHidden)
  }
  
  func presentSelectedCountry(_ country: SignUpCountryProtocol) {
    presentingCountriesHidden = true
    viewController.setCountriesListPresentation(presentingCountriesHidden)
    viewController.setPickCountryButtonPresentation(.pickedCode)
    viewController.setSelectedCountry(country)
  }
}

// MARK: - ResetPasswordPhonePickModule Viper Components
fileprivate extension ResetPasswordPhonePickPresenter {
    var viewController: ResetPasswordPhonePickViewControllerApi {
        return _viewController as! ResetPasswordPhonePickViewControllerApi
    }
    var interactor: ResetPasswordPhonePickInteractorApi {
        return _interactor as! ResetPasswordPhonePickInteractorApi
    }
    var router: ResetPasswordPhonePickRouterApi {
        return _router as! ResetPasswordPhonePickRouterApi
    }
}
