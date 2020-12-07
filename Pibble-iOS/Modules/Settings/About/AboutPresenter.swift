//
//  AboutPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - AboutPresenter Class
final class AboutPresenter: Presenter {
  
  fileprivate var sections: [(section: AboutSections, items: [About.SettingsItems])]  {
    return [(section: .nativeCurrency, items: [.appVersion(interactor.appVersion),
                                               .terms(interactor.termsURL),
                                               .privacyPolicy(interactor.privacyPolicyURL),
                                               .communityGuide(interactor.communityGuideURL)])
    ]
  }
  
  fileprivate var pickedBalance: BalanceCurrency?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
  }
}

//MARK:- Helpers
extension AboutPresenter {
  fileprivate func itemAt(indexPath: IndexPath) -> About.SettingsItems {
    return sections[indexPath.section].items[indexPath.item]
  }
  
  fileprivate func getSelectedValueFor(_ item: About.SettingsItems) -> String? {
    switch item {
    case .appVersion(let version):
      return version
    case .terms:
      return nil
    case .privacyPolicy:
      return nil
    case .communityGuide:
      return nil
    }
  }
  
  fileprivate func setAccountCurrency(_ balanceCurrency: BalanceCurrency) {
    pickedBalance = balanceCurrency
    viewController.reloadData()
  }
}

extension AboutPresenter: AccountCurrencyPickerDelegateProtocol {
  func didSelectedCurrency(_ balanceCurrency: BalanceCurrency) {
    setAccountCurrency(balanceCurrency)
    interactor.performSetAccountCurrency(balanceCurrency)
  }
  
  func selectedCurrency() -> BalanceCurrency? {
    return pickedBalance
  }
}


// MARK: - AboutPresenter API
extension AboutPresenter: AboutPresenterApi {
  func presentUserAccount(_ userProfile: AccountProfileProtocol) {
    setAccountCurrency(userProfile.accountNativeCurrency)
  }
   
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> AboutItemViewModelProtocol {
    let settingsItem = itemAt(indexPath: indexPath)
    let shouldHaveUpperSeparator = false
    let value = getSelectedValueFor(settingsItem)
    return About.AboutItemViewModel(settingsItem: settingsItem,
                                                      value: value,
                                                      shouldHaveUpperSeparator: shouldHaveUpperSeparator)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = itemAt(indexPath: indexPath)
    switch item {
    case .appVersion(_):
      break
    case .terms(let url):
      router.routeToExternalLinkWithUrl(url, title: item.title)
    case .privacyPolicy(let url):
      router.routeToExternalLinkWithUrl(url, title: item.title)
    case .communityGuide(let url):
      router.routeToExternalLinkWithUrl(url, title: item.title)
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - About Viper Components
fileprivate extension AboutPresenter {
  var viewController: AboutViewControllerApi {
    return _viewController as! AboutViewControllerApi
  }
  var interactor: AboutInteractorApi {
    return _interactor as! AboutInteractorApi
  }
  var router: AboutRouterApi {
    return _router as! AboutRouterApi
  }
}

fileprivate enum AboutSections {
  case nativeCurrency
}

