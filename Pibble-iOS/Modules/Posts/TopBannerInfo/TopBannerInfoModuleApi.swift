//
//  TopBannerInfoModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

//MARK: - TopBannerInfoRouter API
protocol TopBannerInfoRouterApi: RouterProtocol {
}

//MARK: - TopBannerInfoView API
protocol TopBannerInfoViewControllerApi: ViewControllerProtocol {
  func setNavigationBarTitle(_ title: String)
  func setWebViewUrl(_ url: URL)
}

//MARK: - TopBannerInfoPresenter API
protocol TopBannerInfoPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func presentUrl(_ url: URL)
}

//MARK: - TopBannerInfoInteractor API
protocol TopBannerInfoInteractorApi: InteractorProtocol {
  func initialFetchData()
}
