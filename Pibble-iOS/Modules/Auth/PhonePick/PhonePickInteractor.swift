//
//  PhonePickModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - PhonePickModuleInteractor Class
final class PhonePickInteractor: Interactor {
  fileprivate let loginService: AuthServiceProtocol
  fileprivate var fetchedCountries: [[SignUpCountryProtocol]] = [[]] {
    didSet {
      presenter.presentDataReload()
    }
  }
  
  fileprivate var preselectedIndexPath: IndexPath?
  
  var signUpCountry: SignUpCountryProtocol?
  
  fileprivate var phoneNumber: String = ""
  
  init(loginService: AuthServiceProtocol) {
    self.loginService = loginService
  }
}

// MARK: - PhonePickModuleInteractor API
extension PhonePickInteractor: PhonePickInteractorApi {
  func preselectedItemIndexPath() -> IndexPath? {
    return preselectedIndexPath
  }
  
  func numberOfSections() -> Int {
    return fetchedCountries.count
  }
  
  func numberOfItemsIn(_ section: Int) -> Int {
    return fetchedCountries[section].count
  }
  
  func itemFor(_ indexPath: IndexPath) -> SignUpCountryProtocol {
    return fetchedCountries[indexPath.section][indexPath.item]
  }
  
  func selectItemAt(_ indexPath: IndexPath) {
    let country = fetchedCountries[indexPath.section][indexPath.item]
    signUpCountry = country
    presenter.presentSelectedCountry(country)
  }
  
  func setPhoneNumber(_ number: String) {
    phoneNumber = number
  }
  
  func sendVerificationToPhoneNumber() {
    guard let country = signUpCountry else {
      presenter.presentSendVerificationFailed()
      presenter.handleError(PhonePick.PhonePickError.signUpCountryIsNotSet)
      return
    }
    
    if let error = verifyPhoneNumberValue(phoneNumber) {
      presenter.presentSendVerificationFailed()
      presenter.handleError(error)
      return
    }
    
    let phone = UserPhoneNumber(countryId: country.id, phone: phoneNumber)
    presenter.presentSendVerificationSuccessWith(phone)
  }
  
  func initialFetchData() {
    loginService.fetchSignUpCountries { [weak self] in
      switch $0 {
      case .success(let countries):
        self?.preselectMatchinCountry(countries)
        self?.fetchedCountries = [countries]
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
fileprivate extension PhonePickInteractor {
  var presenter: PhonePickPresenterApi {
      return _presenter as! PhonePickPresenterApi
  }
}

extension PhonePickInteractor {
  func verifyPhoneNumberValue(_ value: String) -> PhonePick.PhonePickError? {
    guard !value.isEmpty else {
      return .empty
    }
    return nil
  }
  
}

extension PhonePickInteractor {
  fileprivate func preselectMatchinCountry(_ countries: [SignUpCountryProtocol]) {
    let regionCode = Locale.current.regionCode
    countries.enumerated().forEach {
      if $0.element.isoCode == regionCode {
        preselectedIndexPath = IndexPath(item:  $0.offset, section: 0)
        return
      }
    }
  }
}
