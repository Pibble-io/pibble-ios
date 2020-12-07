//
//  UsernamePickerModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 21/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

//MARK: - UsernamePickerRouter API
protocol UsernamePickerRouterApi: RouterProtocol {
}

//MARK: - UsernamePickerView API
protocol UsernamePickerViewControllerApi: ViewControllerProtocol {
  func setUsername(_ text: String)
}

//MARK: - UsernamePickerPresenter API
protocol UsernamePickerPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleDoneAction()
  
  func handleUsernameTextChange(_ text: String)
  
  func presentUsername(_ username: String)
  func presentUsernameChangeSuccess()
}

//MARK: - UsernamePickerInteractor API
protocol UsernamePickerInteractorApi: InteractorProtocol {
  func initialFetchData()
  func setUsernameValue(_ text: String)
  func performUsernameChange()
}
