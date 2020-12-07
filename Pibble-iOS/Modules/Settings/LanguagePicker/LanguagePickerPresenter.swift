//
//  LanguagePickerPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - LanguagePickerPresenter Class
final class LanguagePickerPresenter: Presenter {
  fileprivate weak var delegate: LanguagePickerDelegateProtocol?
  
  fileprivate var sections: [(section: LanguagePickerSections, items: [AppLanguage])] =  [
    (section: .language, items: [.english, .korean])
  ]
  
  fileprivate var selectedItem: AppLanguage?
  
  override func viewWillAppear() {
    super.viewWillAppear()
    selectedItem = delegate?.selectedAppLanguage()
    viewController.reloadData()
  }
  
  init(delegate: LanguagePickerDelegateProtocol) {
    self.delegate = delegate
  }
}

//MARK:- Helpers
extension LanguagePickerPresenter {
  fileprivate func itemAt(indexPath: IndexPath) -> AppLanguage {
    return sections[indexPath.section].items[indexPath.item]
  }
}


// MARK: - LanguagePickerPresenter API
extension LanguagePickerPresenter: LanguagePickerPresenterApi {
  func confirmLanguagePick() {
    viewController.reloadData()
    if let selectedItem = selectedItem {
      delegate?.didSelectAppLanguage(selectedItem)
    }
    
    router.dismiss()
  }
  
  func presentMyGoodsForUser(_ user: UserProtocol) {
    router.routeToMyGoodsListForCurrentUser(user)
  }
  
  func presentPurchasedGoodsForUser(_ user: UserProtocol) {
    router.routeToPurchasedGoodsListForCurrentUser(user)
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> LanguagePickerItemViewModelProtocol {
    let item = itemAt(indexPath: indexPath)
    let shouldHaveUpperSeparator = false
    let isSelected = item == selectedItem
    
    return LanguagePicker.LanguagePickerItemViewModel(language: item,
                                                      isSelected: isSelected,
                                                      shouldHaveUpperSeparator: shouldHaveUpperSeparator)
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = itemAt(indexPath: indexPath)
    guard selectedItem != item else {
      return
    }
    
    selectedItem = item
    viewController.showLanguagePickConfirmationAlert()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - LanguagePicker Viper Components
fileprivate extension LanguagePickerPresenter {
  var viewController: LanguagePickerViewControllerApi {
    return _viewController as! LanguagePickerViewControllerApi
  }
  var interactor: LanguagePickerInteractorApi {
    return _interactor as! LanguagePickerInteractorApi
  }
  var router: LanguagePickerRouterApi {
    return _router as! LanguagePickerRouterApi
  }
}

fileprivate enum LanguagePickerSections {
  case language
}

