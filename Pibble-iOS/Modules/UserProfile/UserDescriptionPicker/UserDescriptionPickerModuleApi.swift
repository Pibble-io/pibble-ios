//
//  UserDescriptionPickerModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - UserDescriptionPickerRouter API
protocol UserDescriptionPickerRouterApi: RouterProtocol {
}

//MARK: - UserDescriptionPickerView API
protocol UserDescriptionPickerViewControllerApi: ViewControllerProtocol {
  func setDescriptionText(_ text: String)
  func setFirstNameText(_ text: String)
  func setLastNameText(_ text: String)
  func setWebsiteText(_ text: String)
  
  func setDesciptionLimitText(_ text: String)
}

//MARK: - UserDescriptionPickerPresenter API
protocol UserDescriptionPickerPresenterApi: PresenterProtocol {
  func handleDoneAction()
  func handleHideAction()
  
  func handleDescriptionTextChange(_ text: String)
  func handleFirstNameTextChange(_ text: String)
  func handleLastNameTextChange(_ text: String)
  func handleWebsiteTextChange(_ text: String)
  
  func presentDescriptionText(count: Int, countLimit: Int)
  
  func presentText(_ text: String, forInput: UserDescriptionPicker.Inputs)
  
  func presentValidationSuccess() 
}

//MARK: - UserDescriptionPickerInteractor API
protocol UserDescriptionPickerInteractorApi: InteractorProtocol {
  var descriptionLimit: Int { get }
  var userProfile: UserProfileProtocol { get }
  
  func setInputText(_ text: String, forInput: UserDescriptionPicker.Inputs)
  
  func setInitialProfile(_ profile: UserProfileProtocol)
  
  func validateIntputs()
}

protocol UserProfilePickDelegateProtocol: class {
  func didSelectUserProfile(_ profile: UserProfileProtocol)
  func selectedUserProfile() -> UserProfileProtocol?
}

