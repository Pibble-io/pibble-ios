//
//  UserDescriptionPickerPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UserDescriptionPickerPresenter Class
final class UserDescriptionPickerPresenter: Presenter {
  fileprivate weak var delegate: UserProfilePickDelegateProtocol?
  
  init(delegate: UserProfilePickDelegateProtocol) {
    self.delegate = delegate
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    guard let profile = delegate?.selectedUserProfile() else {
      return
    }
    interactor.setInitialProfile(profile)
  }
}

// MARK: - UserDescriptionPickerPresenter API
extension UserDescriptionPickerPresenter: UserDescriptionPickerPresenterApi {
  func presentDescriptionText(count: Int, countLimit: Int) {
    viewController.setDesciptionLimitText("\(count)/\(countLimit)")
  }
  
  func presentText(_ text: String, forInput: UserDescriptionPicker.Inputs) {
    switch forInput {
    case .description:
      viewController.setDescriptionText(text)
    case .firstName:
      viewController.setFirstNameText(text)
    case .lastName:
      viewController.setLastNameText(text)
    case .website:
      viewController.setWebsiteText(text)
    }
  }
  
  func handleFirstNameTextChange(_ text: String) {
    interactor.setInputText(text, forInput: .firstName)
  }
  
  func handleLastNameTextChange(_ text: String) {
    interactor.setInputText(text, forInput: .lastName)
  }
  
  func handleWebsiteTextChange(_ text: String) {
     interactor.setInputText(text, forInput: .website)
  }
  
  func presentDescriptionText(_ text: String, count: Int, countLimit: Int) {
    viewController.setDescriptionText(text)
    viewController.setDesciptionLimitText("\(count)/\(countLimit)")
  }
  
  func handleDoneAction() {
    interactor.validateIntputs()
  }
  
  func presentValidationSuccess() {
    delegate?.didSelectUserProfile(interactor.userProfile)
    router.dismiss()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleDescriptionTextChange(_ text: String) {
    interactor.setInputText(text, forInput: .description)
  }
}

// MARK: - UserDescriptionPicker Viper Components
fileprivate extension UserDescriptionPickerPresenter {
    var viewController: UserDescriptionPickerViewControllerApi {
        return _viewController as! UserDescriptionPickerViewControllerApi
    }
    var interactor: UserDescriptionPickerInteractorApi {
        return _interactor as! UserDescriptionPickerInteractorApi
    }
    var router: UserDescriptionPickerRouterApi {
        return _router as! UserDescriptionPickerRouterApi
    }
}
