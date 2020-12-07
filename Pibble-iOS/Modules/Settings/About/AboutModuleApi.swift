//
//  AboutModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - AboutRouter API
protocol AboutRouterApi: RouterProtocol {
  func routeToNativeCurrencyPicker(_ delegate: AccountCurrencyPickerDelegateProtocol)
  func routeToExternalLinkWithUrl(_ url: URL, title: String)
}

//MARK: - AboutView API
protocol AboutViewControllerApi: ViewControllerProtocol {
  func reloadData()
}

//MARK: - AboutPresenter API
protocol AboutPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> AboutItemViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentUserAccount(_ userProfile: AccountProfileProtocol)
}

//MARK: - AboutInteractor API
protocol AboutInteractorApi: InteractorProtocol {
  func initialFetchData()
  func initialRefreshData()
  func performSetAccountCurrency(_ balanceCurrency: BalanceCurrency)
  
  var termsURL: URL { get }
  
  var privacyPolicyURL: URL { get }
  
  var communityGuideURL: URL { get }
  
  var appVersion: String { get }
  
}


protocol AboutItemViewModelProtocol {
  var title: String { get }
  var pickedValue: String { get }
  var isUpperSeparatorVisible: Bool { get }
  var isRightArrowVisible: Bool { get }
  var titleColor: UIColor { get }
}
