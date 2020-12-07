//
//  FundingPostsContainerPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - FundingPostsContainerPresenter Class
final class FundingPostsContainerPresenter: Presenter {
}

// MARK: - FundingPostsContainerPresenter API
extension FundingPostsContainerPresenter: FundingPostsContainerPresenterApi {
  func handleSwitchTo(_ segment: FundingPostsContainer.SelectedSegment) {
    router.routeTo(segment,
                   accountProfile: interactor.currentUserProfile,
                   insideView: viewController.submoduleContainerView)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - FundingPostsContainer Viper Components
fileprivate extension FundingPostsContainerPresenter {
  var viewController: FundingPostsContainerViewControllerApi {
    return _viewController as! FundingPostsContainerViewControllerApi
  }
  var interactor: FundingPostsContainerInteractorApi {
    return _interactor as! FundingPostsContainerInteractorApi
  }
  var router: FundingPostsContainerRouterApi {
    return _router as! FundingPostsContainerRouterApi
  }
}
