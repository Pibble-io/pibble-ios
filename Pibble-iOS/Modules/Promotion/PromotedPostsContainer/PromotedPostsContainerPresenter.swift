//
//  PromotedPostsContainerPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PromotedPostsContainerPresenter Class
final class PromotedPostsContainerPresenter: Presenter {
}

// MARK: - PromotedPostsContainerPresenter API
extension PromotedPostsContainerPresenter: PromotedPostsContainerPresenterApi {
  func handleSwitchTo(_ segment: PromotedPostsContainer.SelectedSegment) {
    router.routeTo(segment,
                   accountProfile: interactor.currentUserProfile,
                   insideView: viewController.submoduleContainerView)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - PromotedPostsContainer Viper Components
fileprivate extension PromotedPostsContainerPresenter {
  var viewController: PromotedPostsContainerViewControllerApi {
    return _viewController as! PromotedPostsContainerViewControllerApi
  }
  var interactor: PromotedPostsContainerInteractorApi {
    return _interactor as! PromotedPostsContainerInteractorApi
  }
  var router: PromotedPostsContainerRouterApi {
    return _router as! PromotedPostsContainerRouterApi
  }
}
