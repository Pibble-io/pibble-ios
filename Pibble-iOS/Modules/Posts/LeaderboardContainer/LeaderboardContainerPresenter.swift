//
//  LeaderboardContainerPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 19/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - LeaderboardContainerPresenter Class
final class LeaderboardContainerPresenter: Presenter {
}

// MARK: - LeaderboardContainerPresenter API
extension LeaderboardContainerPresenter: LeaderboardContainerPresenterApi {
  func handleHelpAction() {
    router.routeToWebsiteAt(interactor.helpUrl)
  }
  
  func handleSwitchTo(_ segment: LeaderboardContainer.SelectedSegment) {
    router.routeTo(segment, insideView: viewController.submoduleContainerView)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - LeaderboardContainer Viper Components
fileprivate extension LeaderboardContainerPresenter {
  var viewController: LeaderboardContainerViewControllerApi {
    return _viewController as! LeaderboardContainerViewControllerApi
  }
  var interactor: LeaderboardContainerInteractorApi {
    return _interactor as! LeaderboardContainerInteractorApi
  }
  var router: LeaderboardContainerRouterApi {
    return _router as! LeaderboardContainerRouterApi
  }
}
