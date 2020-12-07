//
//  DescriptionPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - DescriptionPickPresenter Class
final class DescriptionPickPresenter: Presenter {
  fileprivate weak var delegate: DescriptionPickDelegateProtocol?
  
  init(delegate: DescriptionPickDelegateProtocol) {
    self.delegate = delegate
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    guard let attributes = delegate?.selectedPostingAttributes() else {
      return
    }
    interactor.setInitialAttributes(attributes)
  }
}

// MARK: - DescriptionPickPresenter API
extension DescriptionPickPresenter: DescriptionPickPresenterApi {
  func presentCurrentText(_ text: String) {
    viewController.setInputText(text)
  }
  
  func handleDoneAction() {
    delegate?.didSelectPostingAttributes(interactor.postingAttributes)
    router.dismiss()
  }
  
  func handleHideAction() {
     router.dismiss()
  }
  
  func handleInputTextChange(_ text: String) {
    interactor.setAttributesText(text)
  }
  
}

// MARK: - DescriptionPick Viper Components
fileprivate extension DescriptionPickPresenter {
    var viewController: DescriptionPickViewControllerApi {
        return _viewController as! DescriptionPickViewControllerApi
    }
    var interactor: DescriptionPickInteractorApi {
        return _interactor as! DescriptionPickInteractorApi
    }
    var router: DescriptionPickRouterApi {
        return _router as! DescriptionPickRouterApi
    }
}
