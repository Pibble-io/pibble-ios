//
//  AccountSettingsModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - AccountSettingsRouter API
protocol AccountSettingsRouterApi: RouterProtocol {
  func routeToMutedUsersListFor(_ user: UserProtocol)
  func routeToAppLanguagePicker(_ delegate: LanguagePickerDelegateProtocol)
  func routeToUsernamePicker()
}

//MARK: - AccountSettingsView API
protocol AccountSettingsViewControllerApi: ViewControllerProtocol {
}

//MARK: - AccountSettingsPresenter API
protocol AccountSettingsPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> AccountSettingsItemViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentMutedUsersForUser(_ user: UserProtocol) 
}

//MARK: - AccountSettingsInteractor API
protocol AccountSettingsInteractorApi: InteractorProtocol {
  var appLanguageSettings: AppLanguage { get set }
  func performFetchCurrentUserAndPresentMutedUsers()
}


protocol AccountSettingsItemViewModelProtocol {
  var title: String { get }
  var isUpperSeparatorVisible: Bool { get }
  var isRightArrowVisible: Bool { get }
  var titleColor: UIColor { get }
}
