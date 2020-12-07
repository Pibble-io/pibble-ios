//
//  PhonePickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

//MARK: - PhonePickModuleRouter API
protocol PhonePickRouterApi: RouterProtocol {
  func routeToVerifyCodeWith(_ phoneNumber: UserPhoneNumberProtocol)
}

//MARK: - PhonePickModuleView API
protocol PhonePickViewControllerApi: ViewControllerProtocol {
  func setCountriesListPresentation(_ hidden: Bool)
  func setSelectedCountry(_ country: SignUpCountryViewModelProtocol)
  func setPickCountryButtonPresentation(_ presentation: PhonePick.PickCountryButtonPresentation)
  
  func reloadCounriesTable()
  
  func setInteractionEnabled(_ enabled: Bool)
  
  func setSelectionAt(_ indexPath: IndexPath, selected: Bool)
}

//MARK: - PhonePickModulePresenter API
protocol PhonePickPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func handlePhoneValueChanged(_ value: String)
  func handleNextStageAction()
  func handleCountriesAction()
  
  func numberOfSections() -> Int
  func numberOfItemsIn(_ section: Int) -> Int
  func itemFor(_ indexPath: IndexPath) -> SignUpCountryViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentSelectedCountry(_ country: SignUpCountryProtocol)
  func presentSendVerificationSuccessWith(_ phoneNumber: UserPhoneNumberProtocol)
  func presentSendVerificationFailed()
  
  
  func presentDataReload()
}

//MARK: - PhonePickModuleInteractor API
protocol PhonePickInteractorApi: InteractorProtocol {
  var signUpCountry: SignUpCountryProtocol?  { get set }
  
  func initialFetchData()
  func sendVerificationToPhoneNumber()
  
  func setPhoneNumber(_ number: String)
  
  func numberOfSections() -> Int
  func numberOfItemsIn(_ section: Int) -> Int
  func itemFor(_ indexPath: IndexPath) -> SignUpCountryProtocol
  func selectItemAt(_ indexPath: IndexPath)
  
  func preselectedItemIndexPath() -> IndexPath?
}

protocol SignUpCountryViewModelProtocol  {
  var countryCode: String { get }
  var countryTitle: String { get }
}


