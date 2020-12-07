//
//  PlayRoomModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

//MARK: - PlayRoomRouter API
protocol PlayRoomRouterApi: RouterProtocol {
  func routeToSearchScreen()
}

//MARK: - PlayRoomView API
protocol PlayRoomViewControllerApi: ViewControllerProtocol {
  func setNavigationBarTitle(_ title: String)
  func setWebViewUrl(_ url: URL)
}

//MARK: - PlayRoomPresenter API
protocol PlayRoomPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func presentURL(_ url: URL, user: UserProtocol) 
}

//MARK: - PlayRoomInteractor API
protocol PlayRoomInteractorApi: InteractorProtocol {
  func intitialFetchData()
}
