//
//  ResetPasswordPhonePickModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ResetPasswordPhonePickModuleInteractor Class
final class ResetPasswordPhonePickInteractor: Interactor {
  fileprivate let loginService: AuthServiceProtocol
  fileprivate var fetchedCountries: [SignUpCountryProtocol] = [] {
    didSet {
      presenter.presentDataReload()
    }
  }
  
  
  var signUpCountry: SignUpCountryProtocol?
  
  fileprivate var phoneNumber: String = ""
  
  init(loginService: AuthServiceProtocol) {
    self.loginService = loginService
  }
}

// MARK: - ResetPasswordPhonePickModuleInteractor API
extension ResetPasswordPhonePickInteractor: ResetPasswordPhonePickInteractorApi {
  func numberOfSections() -> Int {
    return 1
  }
  
  func numberOfItemsIn(_ section: Int) -> Int {
    return fetchedCountries.count
  }
  
  func itemFor(_ indexPath: IndexPath) -> SignUpCountryProtocol {
    return fetchedCountries[indexPath.item]
  }
  
  func selectItemAt(_ indexPath: IndexPath) {
    let country = fetchedCountries[indexPath.item]
    signUpCountry = country
    presenter.presentSelectedCountry(country)
  }
  
  func setPhoneNumber(_ number: String) {
    phoneNumber = number
  }
  
  func sendPasswordResetToPhoneNumber() {
    guard let country = signUpCountry else {
      presenter.presentSendVerificationFailed()
      presenter.handleError(ResetPasswordPhonePick.PhonePickError.signUpCountryIsNotSet)
      return
    }
    
    if let error = verifyPhoneNumberValue(phoneNumber) {
      presenter.presentSendVerificationFailed()
      presenter.handleError(error)
      return
    }
    
    let phone = UserPhoneNumber(countryId: country.id, phone: phoneNumber)
    presenter.presentSendPasswordResetSuccessWith(phone)
//    loginService.sendResetPasswordTo(phone) { [weak self] in
//      if let error = $0 {
//        self?.presenter.presentSendVerificationFailed()
//        self?.presenter.handleError(error)
//        return
//      }
//
//      self?.presenter.presentSendPasswordResetSuccessWith(phone)
//    }
  }
  
  func initialFetchData() {
    loginService.fetchSignUpCountries { [weak self] in
      switch $0 {
      case .success(let countries):
        self?.fetchedCountries = countries
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension ResetPasswordPhonePickInteractor {
    var presenter: ResetPasswordPhonePickPresenterApi {
        return _presenter as! ResetPasswordPhonePickPresenterApi
    }
}

extension ResetPasswordPhonePickInteractor {
  func verifyPhoneNumberValue(_ value: String) -> ResetPasswordPhonePick.PhonePickError? {
    guard !value.isEmpty else {
      return .empty
    }
    return nil
  }
  
}
