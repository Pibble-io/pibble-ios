//
//  UsernamePickerPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 21/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UsernamePickerPresenter Class
final class UsernamePickerPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
}

// MARK: - UsernamePickerPresenter API
extension UsernamePickerPresenter: UsernamePickerPresenterApi {
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleDoneAction() {
    interactor.performUsernameChange()
  }
  
  func handleUsernameTextChange(_ text: String) {
    interactor.setUsernameValue(text)
  }
  
  func presentUsername(_ username: String) {
    viewController.setUsername(username)
  }
  
  func presentUsernameChangeSuccess() {
    router.dismiss()
  }
}

// MARK: - UsernamePicker Viper Components
fileprivate extension UsernamePickerPresenter {
  var viewController: UsernamePickerViewControllerApi {
    return _viewController as! UsernamePickerViewControllerApi
  }
  var interactor: UsernamePickerInteractorApi {
    return _interactor as! UsernamePickerInteractorApi
  }
  var router: UsernamePickerRouterApi {
    return _router as! UsernamePickerRouterApi
  }
}
