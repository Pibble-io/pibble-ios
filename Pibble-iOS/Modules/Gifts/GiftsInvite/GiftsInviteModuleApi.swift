//
//  GiftsInviteModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

//MARK: - GiftsInviteRouter API
protocol GiftsInviteRouterApi: RouterProtocol {
}

//MARK: - GiftsInviteView API
protocol GiftsInviteViewControllerApi: ViewControllerProtocol {
  func setNavigationBarTitle(_ title: String)
  func setWebViewUrl(_ url: URL)
}

//MARK: - GiftsInvitePresenter API
protocol GiftsInvitePresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func presentUrl(_ url: URL)
}

//MARK: - GiftsInviteInteractor API
protocol GiftsInviteInteractorApi: InteractorProtocol {
  func initialFetchData()
}
