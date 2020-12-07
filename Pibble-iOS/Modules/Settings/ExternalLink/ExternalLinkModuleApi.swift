//
//  ExternalLinkModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

//MARK: - ExternalLinkRouter API
protocol ExternalLinkRouterApi: RouterProtocol {
}

//MARK: - ExternalLinkView API
protocol ExternalLinkViewControllerApi: ViewControllerProtocol {
  func setNavigationBarTitle(_ title: String)
  func setWebViewUrl(_ url: URL)
}

//MARK: - ExternalLinkPresenter API
protocol ExternalLinkPresenterApi: PresenterProtocol {
  func handleHideAction()
}

//MARK: - ExternalLinkInteractor API
protocol ExternalLinkInteractorApi: InteractorProtocol {
}
