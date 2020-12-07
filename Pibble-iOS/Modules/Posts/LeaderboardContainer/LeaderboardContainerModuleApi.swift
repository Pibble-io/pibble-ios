//
//  LeaderboardContainerModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 19/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - LeaderboardContainerRouter API
protocol LeaderboardContainerRouterApi: RouterProtocol {
  func routeTo(_ segment: LeaderboardContainer.SelectedSegment, insideView: UIView)
  func routeToWebsiteAt(_ url: URL)
}

//MARK: - LeaderboardContainerView API
protocol LeaderboardContainerViewControllerApi: ViewControllerProtocol {
  var submoduleContainerView: UIView  { get }
}

//MARK: - LeaderboardContainerPresenter API
protocol LeaderboardContainerPresenterApi: PresenterProtocol {
  func handleSwitchTo(_ segment: LeaderboardContainer.SelectedSegment)
  func handleHideAction()
  func handleHelpAction()
}

//MARK: - LeaderboardContainerInteractor API
protocol LeaderboardContainerInteractorApi: InteractorProtocol {
  var helpUrl: URL { get }
}
