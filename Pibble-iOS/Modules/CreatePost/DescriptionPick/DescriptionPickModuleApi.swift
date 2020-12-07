//
//  DescriptionPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - DescriptionPickRouter API
protocol DescriptionPickRouterApi: RouterProtocol {
}

//MARK: - DescriptionPickView API
protocol DescriptionPickViewControllerApi: ViewControllerProtocol {
  func setInputText(_ text: String)
}

//MARK: - DescriptionPickPresenter API
protocol DescriptionPickPresenterApi: PresenterProtocol {
  func handleDoneAction()
  func handleHideAction()
  
  func handleInputTextChange(_ text: String)
  func presentCurrentText(_ text: String)
}

//MARK: - DescriptionPickInteractor API
protocol DescriptionPickInteractorApi: InteractorProtocol {
  func setAttributesText(_ text: String)
  var postingAttributes: PostAttributesProtocol { get }
  func setInitialAttributes(_ description: PostAttributesProtocol)
}

protocol DescriptionPickDelegateProtocol: class {
  func didSelectPostingAttributes(_ description: PostAttributesProtocol)
//  func didSelectUserProfile(_ profile: UserProfileProtocol)
//  func selectedUserProfile() -> UserProfileProtocol?
//  
  func selectedPostingAttributes() -> PostAttributesProtocol
}
