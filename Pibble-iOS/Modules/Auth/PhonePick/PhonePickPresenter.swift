//
//  PhonePickModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PhonePickModulePresenter Class
final class PhonePickPresenter: Presenter {
  fileprivate var presentingCountriesHidden = true
  fileprivate var countriesFirstPresentation = true
  
  override func viewWillAppear() {
    interactor.initialFetchData()
    viewController.setCountriesListPresentation(presentingCountriesHidden)
    viewController.setPickCountryButtonPresentation(.pickCodeButton)
    super.viewWillAppear()
  }
}

// MARK: - PhonePickModulePresenter API
extension PhonePickPresenter: PhonePickPresenterApi {
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
  
  func presentSendVerificationSuccessWith(_ phoneNumber: UserPhoneNumberProtocol) {
    viewController.setInteractionEnabled(true)
    router.routeToVerifyCodeWith(phoneNumber)
  }
  
  func handlePhoneValueChanged(_ value: String) { 
    interactor.setPhoneNumber(value)
  }
  
  func handleNextStageAction() {
    viewController.setInteractionEnabled(false)
    interactor.sendVerificationToPhoneNumber()
  }
  
  func handleCountriesAction() {
    presentingCountriesHidden = !presentingCountriesHidden
    viewController.setCountriesListPresentation(presentingCountriesHidden)
    
    guard countriesFirstPresentation,
      let indexPath = interactor.preselectedItemIndexPath()
    else {
      countriesFirstPresentation = false
      return
    }
    
    countriesFirstPresentation = false
    viewController.setSelectionAt(indexPath, selected: true)
  }
  
  func presentSelectedCountry(_ country: SignUpCountryProtocol) {
    presentingCountriesHidden = true
    viewController.setCountriesListPresentation(presentingCountriesHidden)
    viewController.setPickCountryButtonPresentation(.pickedCode)
    viewController.setSelectedCountry(country)
  }
}

// MARK: - PhonePickModule Viper Components
fileprivate extension PhonePickPresenter {
  var viewController: PhonePickViewControllerApi {
    return _viewController as! PhonePickViewControllerApi
  }
  var interactor: PhonePickInteractorApi {
    return _interactor as! PhonePickInteractorApi
  }
  var router: PhonePickRouterApi {
    return _router as! PhonePickRouterApi
  }
}

extension SignUpCountryProtocol {
  var countryCode: String {
    return phoneCode
  }
  var countryTitle: String {
    return title
  }
}

