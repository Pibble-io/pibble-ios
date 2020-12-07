//
//  ResetPasswordPhonePickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import Foundation

//MARK: - ResetPasswordPhonePickModuleRouter API
protocol ResetPasswordPhonePickRouterApi: RouterProtocol {
  func routeToVerifyCodeWith(_ phoneNumber: UserPhoneNumberProtocol)
}

//MARK: - ResetPasswordPhonePickModuleView API
protocol ResetPasswordPhonePickViewControllerApi: ViewControllerProtocol {
  func setCountriesListPresentation(_ hidden: Bool)
  func setSelectedCountry(_ country: SignUpCountryViewModelProtocol)
  func setPickCountryButtonPresentation(_ presentation: PhonePick.PickCountryButtonPresentation)
  
  func setInteractionEnabled(_ enabled: Bool)
  func reloadCounriesTable()
}

//MARK: - ResetPasswordPhonePickModulePresenter API
protocol ResetPasswordPhonePickPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func handlePhoneValueChanged(_ value: String)
  func handleNextStageAction()
  func handleCountriesAction()
 
  func numberOfSections() -> Int
  func numberOfItemsIn(_ section: Int) -> Int
  func itemFor(_ indexPath: IndexPath) -> SignUpCountryViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentSelectedCountry(_ country: SignUpCountryProtocol)
  func presentDataReload()
  func presentSendPasswordResetSuccessWith(_ phoneNumber: UserPhoneNumberProtocol)
  func presentSendVerificationFailed()
}

//MARK: - ResetPasswordPhonePickModuleInteractor API
protocol ResetPasswordPhonePickInteractorApi: InteractorProtocol {
  var signUpCountry: SignUpCountryProtocol?  { get set }
  
  func initialFetchData()
  func sendPasswordResetToPhoneNumber()
  
  func setPhoneNumber(_ number: String)
  
  func numberOfSections() -> Int
  func numberOfItemsIn(_ section: Int) -> Int
  func itemFor(_ indexPath: IndexPath) -> SignUpCountryProtocol
  func selectItemAt(_ indexPath: IndexPath)
}
