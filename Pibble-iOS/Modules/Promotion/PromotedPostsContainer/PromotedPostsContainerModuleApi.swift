//
//  PromotedPostsContainerModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - PromotedPostsContainerRouter API
protocol PromotedPostsContainerRouterApi: RouterProtocol {
  func routeTo(_ segment: PromotedPostsContainer.SelectedSegment, accountProfile: AccountProfileProtocol, insideView: UIView)
}

//MARK: - PromotedPostsContainerView API
protocol PromotedPostsContainerViewControllerApi: ViewControllerProtocol {
  var submoduleContainerView: UIView  { get }
}

//MARK: - PromotedPostsContainerPresenter API
protocol PromotedPostsContainerPresenterApi: PresenterProtocol {
  func handleSwitchTo(_ segment: PromotedPostsContainer.SelectedSegment)
  func handleHideAction()
}

//MARK: - PromotedPostsContainerInteractor API
protocol PromotedPostsContainerInteractorApi: InteractorProtocol {
  var currentUserProfile: AccountProfileProtocol { get }
}
